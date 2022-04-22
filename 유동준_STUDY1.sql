-- 1번 문제 

SELECT *
FROM customer
WHERE JOB IN ('자영업', '의사')
AND SUBSTR(birth, 1, 4) >= 1988
ORDER BY birth desc; 

-- 2번 문제
SELECT customer_name
     , phone_number
FROM customer a, address b
WHERE a.zip_code = b.zip_code
AND b.address_detail = '강남구';

-- 3번 문제
SELECT job
     , COUNT(job) as CNT
     , COUNT(*)
FROM customer
WHERE NOT job IS NULL
GROUP BY job
ORDER BY 2 desc;

-- 4-1번 문제
SELECT t1.요일
     , t1.건수
FROM  (SELECT TO_CHAR(first_reg_date, 'DAY') 요일 
             , COUNT(first_reg_date)          건수
       FROM customer
       GROUP BY TO_CHAR(first_reg_date, 'DAY')) t1
WHERE ROWNUM = 1;
-- 4-2번 문제

SELECT DECODE(DECODE(GROUPING_id(sex_code), 1, '총계', sex_code)
     ,'M', '남자', 'F', '여자','총계','총계','미등록') as GENDER
     , COUNT(*) as CNT
FROM customer
GROUP BY ROLLUP (sex_code);

-- 5번 문제

SELECT SUBSTR(reserv_date, 5, 2) as 월
     , COUNT(*)                  as 취소건수
FROM reservation
WHERE cancel = 'Y'
GROUP BY SUBSTR(reserv_date, 5, 2)
ORDER BY 2 desc;

-- 6번 문제

SELECT b.product_name as 상품이름 
     , SUM(sales)     as 상품매출
FROM order_info a, item b
WHERE a.item_id = b.item_id
GROUP BY b.product_name
ORDER BY 2 desc;

-- 7번 문제 

SELECT 매출월
     , sum(DECODE(t1.상품이름, 'SPECIAL_SET' , 매출, 0)) as SPECIAL_SET 
     , sum(DECODE(t1.상품이름, 'PASTA' , 매출, 0))       as PASTA
     , sum(DECODE(t1.상품이름, 'PIZZA' , 매출, 0))       as PIZZA
     , sum(DECODE(t1.상품이름, 'SEA_FOOD' , 매출, 0))    as SEA_FOOD
     , sum(DECODE(t1.상품이름, 'STEAK' , 매출, 0))       as STEAK
     , sum(DECODE(t1.상품이름, 'SALAD_BAR' , 매출, 0))   as SALAD_BAR
     , sum(DECODE(t1.상품이름, 'SALAD' , 매출, 0))       as SALAD
     , sum(DECODE(t1.상품이름, 'SANDWICH' , 매출, 0))    as SANDWICH
     , sum(DECODE(t1.상품이름, 'WINE' , 매출, 0))        as WINE
     , sum(DECODE(t1.상품이름, 'JUICE' , 매출, 0))       as JUICE
FROM
    (SELECT substr(reserv_no,1,6) as 매출월 
         , b.product_name         as 상품이름 
         , sum(a.sales)           as 매출
    FROM order_info a, ITEM b
    WHERE a.item_id = b.item_id
    GROUP BY substr(reserv_no,1,6), b.product_name) t1
GROUP BY 매출월;


-- 8번문제

SELECT 날짜
     , 상품명
     , sum(decode(요일, '일요일', 매출, 0)) as 일요일 
     , sum(decode(요일, '월요일', 매출, 0)) as 월요일 
     , sum(decode(요일, '화요일', 매출, 0)) as 화요일 
     , sum(decode(요일, '수요일', 매출, 0)) as 수요일 
     , sum(decode(요일, '목요일', 매출, 0)) as 목요일 
     , sum(decode(요일, '금요일', 매출, 0)) as 금요일 
     , sum(decode(요일, '토요일', 매출, 0)) as 토요일   
FROM  
(SELECT SUBSTR(a.reserv_no,1,6) as 날짜 
     , b.product_name         as 상품명 
     , sum(a.sales)           as 매출
     , to_char(TO_DATE(SUBSTR(a.reserv_no,1,8)),'day') as 요일
FROM order_info a, item b
WHERE a.item_id = b.item_id
AND a.item_id = 'M0001'
GROUP BY SUBSTR(a.reserv_no,1,6), b.product_name
, to_char(TO_DATE(SUBSTR(a.reserv_no,1,8)),'day'))
GROUP BY 날짜, 상품명
ORDER BY 1;

-- 9번 문제 
SELECT SUM(고객수)                           고객수
     , SUM(decode(성별, 'M', 성별수, 0))      남자 
     , SUM(decode(성별, 'F', 성별수, 0))      여자 
     , ROUND(avg(평균나이), 1)                 평균나이
     , ROUND(avg(평균거래기간), 1)             평균거래기간
FROM
(SELECT customer_name  고객
      , sex_code       성별
      , MONTHS_BETWEEN(SYSDATE, birth) / 12 평균나이 
      , MONTHS_BETWEEN(SYSDATE, first_reg_date) 평균거래기간
      , COUNT(DISTINCT customer_name)   고객수
      , COUNT(sex_code) 성별수
      , birth          나이
      , first_reg_date 거래기간 
FROM customer
WHERE NOT birth IS NULL AND NOT sex_code IS NULL
GROUP BY customer_name, sex_code, birth
, first_reg_date, MONTHS_BETWEEN(SYSDATE, birth) / 12
, MONTHS_BETWEEN(SYSDATE, first_reg_date));

-- 10번 문제

SELECT b.address_detail                     주소 
     , COUNT(DISTINCT a.customer_name)      카운팅
FROM customer a, address b, reservation c
WHERE a.zip_code = b.zip_code
AND a.customer_id = c.customer_id
AND c.cancel = 'N'
GROUP BY b.address_detail
ORDER BY 2 desc;

