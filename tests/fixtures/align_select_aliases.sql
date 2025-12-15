#title: basic
SELECT foo AS f, bar AS b, baz AS z FROM x;
SELECT
  foo AS f,
  bar AS b,
  baz AS z
FROM x;

#title: per_cte
WITH cte1 AS (
  SELECT short AS s, very_long_name AS v FROM x
), cte2 AS (
  SELECT a AS a_col, b AS b_col FROM y
) SELECT * FROM cte1;
WITH cte1 AS (
  SELECT
    short          AS s,
    very_long_name AS v
  FROM x
), cte2 AS (
  SELECT
    a AS a_col,
    b AS b_col
  FROM y
)
SELECT
  *
FROM cte1;

#title: multiline_case
SELECT
  CASE WHEN x > 0 THEN 'positive' ELSE 'negative' END AS case_result,
  y AS y_col
FROM z;
SELECT
  CASE WHEN x > 0 THEN 'positive' ELSE 'negative' END AS case_result,
  y                                                   AS y_col
FROM z;

#title: leading_comma
#leading_comma: true
SELECT foo AS f, bar AS b FROM x;
SELECT
  foo   AS f
  , bar AS b
FROM x;

#title: mixed_alias_and_plain
SELECT foo, bar AS b, baz, qux AS q FROM x;
SELECT
  foo,
  bar AS b,
  baz,
  qux AS q
FROM x;

#title: align_disabled
#align_select_aliases: false
SELECT short AS s, very_long_expression AS v FROM x;
SELECT
  short AS s,
  very_long_expression AS v
FROM x;

#title: align_enabled
SELECT short AS s, very_long_expression AS v FROM x;
SELECT
  short                AS s,
  very_long_expression AS v
FROM x;

#title: max_width_break
#max_text_width: 50
SELECT short AS s, very_very_very_very_long_expression_name AS v FROM x;
SELECT
  short                                    AS s,
  very_very_very_very_long_expression_name AS v
FROM x;

#title: multiline_case_forced
#max_text_width: 40
SELECT
  CASE
    WHEN x > 0 THEN 'positive'
    WHEN x < 0 THEN 'negative'
    ELSE 'zero'
  END AS case_result,
  y AS y_col
FROM z;
SELECT
  CASE
    WHEN x > 0
    THEN 'positive'
    WHEN x < 0
    THEN 'negative'
    ELSE 'zero'
  END AS case_result,
  y   AS y_col
FROM z;

#title: multiline_function
SELECT
  CONCAT(
    'prefix_',
    column_name,
    '_suffix'
  ) AS concatenated,
  other_col AS other
FROM table;
SELECT
  CONCAT('prefix_', column_name, '_suffix') AS concatenated,
  other_col                                 AS other
FROM table;

#title: very_long_strings
SELECT 
    a.foo AS a_foo,
    "very_long_string_that_extends_beyond_normal_length" AS long_alias,
    b.bar AS b_bar
FROM a, b;
SELECT
  a.foo                                                AS a_foo,
  "very_long_string_that_extends_beyond_normal_length" AS long_alias,
  b.bar                                                AS b_bar
FROM a, b;

#title: mixed_long_short
SELECT 
    x AS x,
    "extremely_long_string_expression_that_goes_on_and_on" AS very_long_alias,
    y AS y
FROM t;
SELECT
  x                                                      AS x,
  "extremely_long_string_expression_that_goes_on_and_on" AS very_long_alias,
  y                                                      AS y
FROM t;

#title: leading_comma_mixed
#leading_comma: true
SELECT 
    a.foo AS a_foo
    , b.bar AS b_bar
    , CASE WHEN a.baz > 0 THEN 'positive' ELSE 'negative' END AS case_result
    , "long_string" AS long_alias
FROM a, b;
SELECT
  a.foo                                                     AS a_foo
  , b.bar                                                   AS b_bar
  , CASE WHEN a.baz > 0 THEN 'positive' ELSE 'negative' END AS case_result
  , "long_string"                                           AS long_alias
FROM a, b;

#title: nested_case
SELECT 
    CASE 
        WHEN x > 0 THEN 
            CASE WHEN y > 0 THEN 'both' ELSE 'x_only' END
        ELSE 'none'
    END AS nested_case,
    simple_col AS simple_alias
FROM t;
SELECT
  CASE WHEN x > 0 THEN CASE WHEN y > 0 THEN 'both' ELSE 'x_only' END ELSE 'none' END AS nested_case,
  simple_col                                                                         AS simple_alias
FROM t;

#title: cte_multiple_selects
WITH cte AS (
    SELECT a AS a_alias, b AS b_alias FROM t1
)
SELECT c AS c_alias, d AS d_alias FROM cte;
WITH cte AS (
  SELECT
    a AS a_alias,
    b AS b_alias
  FROM t1
)
SELECT
  c AS c_alias,
  d AS d_alias
FROM cte;

