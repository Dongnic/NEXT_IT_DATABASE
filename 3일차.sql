/* 수식연산자
    + - * /
*/

SELECT employee_id
     , emp_name
     , ROUND(salary / 30, 2)    as 일당
     , salary                   as 월급
     , salary * salary * 0.1    as 실수령액
     , salary * 12              as 연봉
     , emp_name || ':' || email as 이메일 -- 문자연산자 -> ||(문자 합) (emp_name:email)

FROM employees;

-- 논리 연산자 

SELECT * FROM employees WHERE salary  = 2600 ;  --같다
SELECT * FROM employees WHERE salary <> 2600 ;  --같지 않다
SELECT * FROM employees WHERE salary != 2600 ;  --같지 않다
SELECT * FROM employees WHERE salary <  2600 ;  --미만
SELECT * FROM employees WHERE salary >  2600 ;  --초과
SELECT * FROM employees WHERE salary <= 2600 ;  --이하
SELECT * FROM employees WHERE salary >= 2600 ;  --이상 

-- products 테이블에서 상품 최저 금액(min_price)가 50 원 '미만'인
-- 제품명을 출력하시오, min_price를 내림차순으로 조회하시오

SELECT prod_name
     , prod_min_price
FROM products
WHERE prod_min_price < 50
AND prod_min_price >= 30
OR prod_min_price < 10
AND prod_min_price > 7
AND prod_name = '%C%' -- ?
ORDER BY prod_min_price desc;
-- 30원 이상 50원 미만
-- AND(그리고), OR(또는)
--
/* 표현식 CASE */
SELECT CUST_GENDER
     , CUST_NAME
     , CASE WHEN CUST_GENDER = 'M' THEN '남자'
            WHEN CUST_GENDER = 'F' THEN '여자'
            ELSE '?'
        END as 성별       
FROM customers;    

SELECT employee_id, salary
     , CASE WHEN salary <= 5000 THEN 'C'
            WHEN salary > 5000 AND salary <= 15000 THEN 'B'
            ELSE 'A'
       END as grade -- CASE문도 하나의 컬럼이기때문에 as를 설정해주는게 좋음
FROM employees
ORDER BY 2 desc; -- 2 = SELECT 의 2번째(salary)를 뜻함 

/* LIKE 조건식*** */
SELECT emp_name
FROM employees
WHERE emp_name LIKE 'A%'; -- %는 자바의 *의 의미를 가짐 


CREATE TABLE ex3_5 (
    nm varchar2(100)
);
INSERT INTO ex3_5 VALUES('홍길동');
INSERT INTO ex3_5 VALUES('홍길');
INSERT INTO ex3_5 VALUES('홍');
INSERT INTO ex3_5 VALUES('길홍길동');
INSERT INTO ex3_5 VALUES('동');

SELECT *
FROM ex3_5
--WHERE nm like '홍%'; -- 홍으로 시작하는 
--WHERE nm like '%길'; -- 길로 끝나는 
--WHERE nm like '%길%'; -- 길이 포함된 
-- 길이가 맞아야 할때는 % 대신 _ 사용
WHERE nm like '_'; --한글자인 데이터 출력
-- 동이 들어가는 사람 검색
SELECT *
FROM TB_INFO
WHERE nm like '%동%';
-- 이씨 또는 김씨를 검색하시오 
SELECT *
FROM TB_INFO
WHERE nm like '이%' or nm like '김%' and email like '%naver%';

SELECT *
FROM TB_INFO
WHERE nm NOT LIKE '%동%'; -- 동이 들어가지 않는 사람 검색 부정의 의미 

-- 이메일 주소가 gmail이 아닌 학생을 출력하시오
SELECT *
FROM TB_INFO
WHERE EMAIL NOT LIKE '%gmail%';