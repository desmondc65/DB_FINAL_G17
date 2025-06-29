SELECT
  COUNT(DISTINCT cs1.cs_order_number) AS "order count",
  SUM(cs1.cs_ext_ship_cost) AS "total shipping cost",
  SUM(cs1.cs_net_profit) AS "total net profit"
FROM catalog_sales AS cs1
JOIN date_dim AS d
  ON cs1.cs_ship_date_sk = d.d_date_sk
JOIN customer_address AS ca
  ON cs1.cs_ship_addr_sk = ca.ca_address_sk
JOIN call_center AS cc
  ON cs1.cs_call_center_sk = cc.cc_call_center_sk
WHERE
  d.d_date BETWEEN '1999-05-01' AND DATE_ADD(CAST('1999-05-01' AS DATE), INTERVAL 60 DAY)
  AND ca.ca_state = 'ID'
  AND cc.cc_county IN (
    'Williamson County',
    'Williamson County',
    'Williamson County',
    'Williamson County',
    'Williamson County'
  )
  AND EXISTS(
    SELECT
      1
    FROM catalog_sales AS cs2
    WHERE
      cs1.cs_order_number = cs2.cs_order_number
      AND cs1.cs_warehouse_sk <> cs2.cs_warehouse_sk
  )
  AND NOT EXISTS(
    SELECT
      1
    FROM catalog_returns AS cr1
    WHERE
      cs1.cs_order_number = cr1.cr_order_number
  )
ORDER BY
  COUNT(DISTINCT cs1.cs_order_number)
LIMIT 100
