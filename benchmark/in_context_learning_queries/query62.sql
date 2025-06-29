SELECT
  SUBSTR(w_warehouse_name, 1, 20),
  sm_type,
  web_name,
  SUM(CASE WHEN (
    ws_ship_date_sk - ws_sold_date_sk <= 30
  ) THEN 1 ELSE 0 END) AS "30 days",
  SUM(CASE WHEN (
    ws_ship_date_sk - ws_sold_date_sk > 30
  ) AND (
    ws_ship_date_sk - ws_sold_date_sk <= 60
  ) THEN 1 ELSE 0 END) AS "31-60 days",
  SUM(CASE WHEN (
    ws_ship_date_sk - ws_sold_date_sk > 60
  ) AND (
    ws_ship_date_sk - ws_sold_date_sk <= 90
  ) THEN 1 ELSE 0 END) AS "61-90 days",
  SUM(CASE WHEN (
    ws_ship_date_sk - ws_sold_date_sk > 90
  ) AND (
    ws_ship_date_sk - ws_sold_date_sk <= 120
  ) THEN 1 ELSE 0 END) AS "91-120 days",
  SUM(CASE WHEN (
    ws_ship_date_sk - ws_sold_date_sk > 120
  ) THEN 1 ELSE 0 END) AS ">120 days"
FROM web_sales AS ws
JOIN warehouse AS w
  ON ws.ws_warehouse_sk = w.w_warehouse_sk
JOIN ship_mode AS sm
  ON ws.ws_ship_mode_sk = sm.sm_ship_mode_sk
JOIN web_site AS web
  ON ws.ws_web_site_sk = web.web_site_sk
JOIN date_dim AS dd
  ON ws.ws_ship_date_sk = dd.d_date_sk
WHERE
  dd.d_month_seq BETWEEN 1217 AND 1227
GROUP BY
  SUBSTR(w_warehouse_name, 1, 20),
  sm_type,
  web_name
ORDER BY
  SUBSTR(w_warehouse_name, 1, 20),
  sm_type,
  web_name
LIMIT 100
