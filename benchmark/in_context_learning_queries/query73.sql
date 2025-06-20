SELECT c_last_name, c_first_name, c_salutation, c_preferred_cust_flag, ss_ticket_number, cnt
FROM (
    SELECT ss_ticket_number, ss_customer_sk, COUNT(*) AS cnt
    FROM store_sales
    JOIN date_dim ON store_sales.ss_sold_date_sk = date_dim.d_date_sk
    JOIN store ON store_sales.ss_store_sk = store.s_store_sk
    JOIN household_demographics ON store_sales.ss_hdemo_sk = household_demographics.hd_demo_sk
    WHERE date_dim.d_dom BETWEEN 1 AND 2
    AND (household_demographics.hd_buy_potential = '1001-5000' OR household_demographics.hd_buy_potential = '5001-10000')
    AND household_demographics.hd_vehicle_count > 0
    AND household_demographics.hd_dep_count / household_demographics.hd_vehicle_count > 1
    AND date_dim.d_year IN (1999, 2000, 2001)
    AND store.s_county IN ('Williamson County', 'Williamson County', 'Williamson County', 'Williamson County')
    GROUP BY ss_ticket_number, ss_customer_sk
) AS dj
JOIN customer ON dj.ss_customer_sk = c_customer_sk
WHERE cnt BETWEEN 1 AND 5
ORDER BY cnt DESC, c_last_name ASC;
