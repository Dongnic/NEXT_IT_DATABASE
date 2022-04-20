/* CUSTOMERS 고객 정보를 출력하시오
    젊은고객부터 출력  
    1. 필요한 컬럼 출력
    2. 원하는 표현으로 출력(성별 ,나이 ,국가)
country_id
*/
SELECT *
FROM CUSTOMERS;

SELECT a.cust_name                                          as 이름 
     , DECODE(a.cust_gender, 'M', '남자', 'F', '여자')       as 성별
     , TO_CHAR(sysdate, 'YYYY') - a.cust_year_of_birth      as 나이 
     , a.cust_city                                          as 도시 
     , b.country_name                                       as 국가
     , (select country_name
        from countries
        where country_id = a.country_id)                    as 국가
FROM CUSTOMERS a, COUNTRIES b
WHERE a.country_id = b.country_id(+)
--GROUP BY a.cust_name, a.cust_city, b.country_name;
ORDER BY 3 asc;


-- 직원과 고객의 실적내용이 많은 관계는?
SELECT  a.prod_id, a.sales_date, amount_sold -- 테이블 명을 안써도 되는 이유
        ,(select cust_name
          from  customers
          where cust_id = a.cust_id) as 구매고객
        ,(select emp_name
          from employees
          where employee_id = a.employee_id) as 판매직원
FROM sales a, customers b;

SELECT b.cust_name as 구매고객이름
     , c.emp_name as 판매직원이름
     , count(*)
FROM sales a , customers b, employees c
WHERE a.cust_id = b.cust_id
AND a.employee_id = c.employee_id
GROUP BY b.cust_id, b.cust_name
       , c.employee_id, c.emp_name
ORDER BY  desc;



select prod_category
     , prod_subcategory
from products
group by prod_category
    , prod_subcategory
order by 1 ;

-- 세미 조인
SELECT department_id
     , department_name
FROM departments a
WHERE EXISTS (select * 
              from employees b
              where a.department_id = b.department_id);
    -- 존재하지 않을 경우 NOT EXISTS
    
-- 수강이력이 없는 학생 조회
SELECT *
FROM 학생 a
WHERE NOT EXISTS (select *
                  from 수강내역
                  where 학번 = a.학번);
-- 학생 테이블에서 -> 수강내역 테이블에서 학번이 존재하지 않는 값을 출력

/*  ANSI_JOIN
*/

-- 일반 내부조인(INNER JOIN)
SELECT *
FROM 학생
   , 수강내역
   , 과목
WHERE 학생.학번 = 수강내역.학번
AND 수강내역.과목번호 = 과목.과목번호;
-- ANSI 내부조인 ( 조인관련 내용이 모두 FROM절에 위치함)
SELECT *
FROM 학생
INNER JOIN 수강내역
ON (학생.학번 = 수강내역.학번)
INNER JOIN 과목
ON (수강내역.과목번호 = 과목.과목번호);
-- 일반 외부조인 (OUTER JOIN)
SELECT *
FROM 학생
   , 수강내역
   , 과목
WHERE 학생.학번 = 수강내역.학번(+)
AND 수강내역.과목번호 = 과목.과목번호(+);
-- ANSI 외부조인
SELECT *
FROM 학생
LEFT OUTER JOIN 수강내역  -- OUTER는 생략가능
ON (학생.학번 = 수강내역.학번)
LEFT JOIN 과목
ON (수강내역.과목번호 = 과목.과목번호);

SELECT *
FROM 수강내역
RIGHT OUTER JOIN 학생  -- OUTER는 생략가능
ON (학생.학번 = 수강내역.학번) -- 순서는 상관없음 
RIGHT JOIN 과목
ON (수강내역.과목번호 = 과목.과목번호);

-- FULL OUTER JOIN
CREATE TABLE test_a (emp_id number);
CREATE TABLE test_b (emp_id number);
CREATE TABLE test_c (emp_id VARCHAR2(20));
select *
from test_c;

INSERT INTO test_a VALUES(10);
INSERT INTO test_c VALUES('액션, 로맨스');
INSERT INTO test_a VALUES(20);
INSERT INTO test_a VALUES(40);

INSERT INTO test_b VALUES(10);
INSERT INTO test_b VALUES(20);
INSERT INTO test_b VALUES(30);

SELECT a.emp_id
     , b.emp_id
FROM test_a a, test_b b
WHERE a.emp_id(+) = b.emp_id; -- 한 쪽에만(+) OUTER JOIN이 가능함(양 쪽엔 불가능) 

--ANSI FULL OUTER JOIN 
SELECT a.emp_id
     , b.emp_id
FROM test_a a 
FULL OUTER JOIN test_b b
ON(a.emp_id = b.emp_id); -- 양 쪽에(+)하여 값 출력

-- 2000년도 판매(금액)왕을 출력하시오 (sales)
-- 직원명은 서브쿼리사용(select)
-- 1. sales 테이블을 활용하여 직원별 판매금액(amount_sold), 수량을 집계
-- 2. 금액합계컬럼 기준으로 정렬하여 1건만 출력(인라인 뷰 사용)
-- 3. 사번으로 employees테이블 이용하여 이름 가져오기(스칼라서브쿼리 사용)
SELECT (select emp_name
        from employees
        where employee_id = a.employee_id) as 직원
        , 판매수량
        , to_char(판매금액,'999,999,999,99') as 판매금액
FROM (SELECT employee_id
     , SUM(quantity_sold) 판매수량 
     , SUM(amount_sold)   판매금액
    FROM sales
    WHERE to_char(sales_date,'yyyy') = '2000'
    GROUP BY employee_id
    ORDER BY 3 desc
    ) a
WHERE rownum = 1;


-- 직원 sales.employee_id(157) , 건수 quantity_sold
SELECT 이름
     , 사번
     , to_char(판매금액,'999,999,999.99') 판매금액
     , 판매수량
FROM  (SELECT (select emp_name
            from employees
            where employee_id = a.employee_id) as 이름 
         , a.employee_id                      as 사번
         , sum(a.amount_sold)                  as 판매금액
         , sum(a.quantity_sold)              as 판매수량
    FROM sales a
    WHERE TO_CHAR(a.sales_date, 'yyyy') = '2000'
    GROUP BY a.employee_id
    ORDER BY 3 desc)
WHERE rownum = 1;

-- 2000년도 최다판매상품(수량기준) 1 ~ 3등까지 출력하시오
SELECT *
FROM sales;

SELECT  상품아이디 as 상품이름
      , to_char(판매금액,'999,999,999.99') as 판매금액
      , 판매수량
FROM (SELECT (select prod_name
              from products
              where prod_id = a.prod_id)            상품아이디
            , SUM(a.amount_sold) 판매금액
            , SUM(quantity_sold) 판매수량 
       FROM sales a
       WHERE to_char(sales_date,'yyyy') = '2000'
       GROUP BY prod_id
       ORDER BY 3 desc
      ) b
WHERE ROWNUM BETWEEN 1 AND 3;