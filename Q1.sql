--월평균
SELECT a.sales_month 월
             , ROUND(AVG(a.amount_sold)) 월평균  
FROM sales a, customers b, countries c
WHERE a.cust_id = b.cust_id
AND b.country_id = c.country_id
AND c.country_name = 'Italy'
AND a.sales_month Like '2000%'
GROUP BY a.sales_month;
-- 연 평균
SELECT ROUND(AVG(a.amount_sold)) 연평균  
FROM sales a, customers b, countries c
WHERE a.cust_id = b.cust_id
AND b.country_id = c.country_id
AND c.country_name = 'Italy'
AND a.sales_month Like '2000%';
-- 문제
SELECT a.월
     , a.월평균
FROM (SELECT a.sales_month 월
             , ROUND(AVG(a.amount_sold)) 월평균  
FROM sales a, customers b, countries c
WHERE a.cust_id = b.cust_id
AND b.country_id = c.country_id
AND c.country_name = 'Italy'
AND a.sales_month Like '2000%'
GROUP BY a.sales_month) a
,
(SELECT ROUND(AVG(a.amount_sold)) 연평균  
FROM sales a, customers b, countries c
WHERE a.cust_id = b.cust_id
AND b.country_id = c.country_id
AND c.country_name = 'Italy'
AND a.sales_month Like '2000%') b
WHERE a.월평균 > b.연평균;

