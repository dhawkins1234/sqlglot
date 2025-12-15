import unittest

from sqlglot import exp, parse_one
from sqlglot.expressions import Func
from sqlglot.parser import Parser
from sqlglot.tokens import Tokenizer
from tests.helpers import load_sql_fixture_pairs, string_to_bool


class TestGenerator(unittest.TestCase):
    def test_fallback_function_sql(self):
        class SpecialUDF(Func):
            arg_types = {"a": True, "b": False}

        class NewParser(Parser):
            FUNCTIONS = SpecialUDF.default_parser_mappings()

        tokens = Tokenizer().tokenize("SELECT SPECIAL_UDF(a) FROM x")
        expression = NewParser().parse(tokens)[0]
        self.assertEqual(expression.sql(), "SELECT SPECIAL_UDF(a) FROM x")

    def test_fallback_function_var_args_sql(self):
        class SpecialUDF(Func):
            arg_types = {"a": True, "expressions": False}
            is_var_len_args = True

        class NewParser(Parser):
            FUNCTIONS = SpecialUDF.default_parser_mappings()

        tokens = Tokenizer().tokenize("SELECT SPECIAL_UDF(a, b, c, d + 1) FROM x")
        expression = NewParser().parse(tokens)[0]
        self.assertEqual(expression.sql(), "SELECT SPECIAL_UDF(a, b, c, d + 1) FROM x")

        self.assertEqual(
            exp.DateTrunc(this=exp.to_column("event_date"), unit=exp.var("MONTH")).sql(),
            "DATE_TRUNC('MONTH', event_date)",
        )

    def test_identify(self):
        self.assertEqual(parse_one("x").sql(identify=True), '"x"')
        self.assertEqual(parse_one("x").sql(identify=False), "x")
        self.assertEqual(parse_one("X").sql(identify=True), '"X"')
        self.assertEqual(parse_one('"x"').sql(identify=False), '"x"')
        self.assertEqual(parse_one("x").sql(identify="safe"), '"x"')
        self.assertEqual(parse_one("X").sql(identify="safe"), "X")
        self.assertEqual(parse_one("x as 1").sql(identify="safe"), '"x" AS "1"')
        self.assertEqual(parse_one("X as 1").sql(identify="safe"), 'X AS "1"')

    def test_generate_nested_binary(self):
        sql = "SELECT 'foo'" + (" || 'foo'" * 1000)
        self.assertEqual(parse_one(sql).sql(copy=False), sql)

    def test_align_select_aliases(self):
        for i, (meta, sql, expected) in enumerate(
            load_sql_fixture_pairs("align_select_aliases.sql"), start=1
        ):
            title = meta.get("title") or f"align_select_aliases_{i}"
            dialect = meta.get("dialect")
            leading_comma = string_to_bool(meta.get("leading_comma"))
            pretty = True if meta.get("pretty") is None else string_to_bool(meta.get("pretty"))
            max_text_width = meta.get("max_text_width")
            align_flag = meta.get("align_select_aliases")
            align_select_aliases = True if align_flag is None else string_to_bool(align_flag)

            kwargs = {
                "pretty": pretty,
                "align_select_aliases": align_select_aliases,
            }

            if leading_comma:
                kwargs["leading_comma"] = True
            if max_text_width:
                kwargs["max_text_width"] = int(max_text_width)
            if dialect:
                kwargs["dialect"] = dialect

            with self.subTest(title):
                self.assertEqual(
                    expected,
                    parse_one(sql, read=dialect).sql(**kwargs),
                )
