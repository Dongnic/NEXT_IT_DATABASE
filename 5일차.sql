--TO_NUMBER 숫자 데이터 타입으로
SELECT
    '12' * '300' -- 숫자형 문자열이지만 오롯이 숫자인 경우 Number타입으로 형변환
FROM
    dual;

CREATE TABLE ex5_1 (
    col1 VARCHAR2(1000)
);

INSERT INTO ex5_1 VALUES ( '123' );

INSERT INTO ex5_1 VALUES ( '92' );

INSERT INTO ex5_1 VALUES ( '1111' );

INSERT INTO ex5_1 VALUES ( '999' );

SELECT
    *
FROM
    ex5_1
ORDER BY
    to_number(col1) DESC; -- Number 방식으로 변환하여 숫자 값 기준 내림차순으로 정렬 

--문제 : CUSTOMERS 테이블에서
--CUST_YEAR_OF_BIRTH <- 활용하여 
--1980 이후 출생자를 출력하시오
--이름, 출생년도, 나이(올해년도 - 출생년도), 성별 출력 

SELECT
    *
FROM
    customers;

SELECT
    cust_name            AS 이름,
    cust_year_of_birth   AS 출생년도,
    ( to_char(sysdate, 'YYYY') - cust_year_of_birth ) AS 나이,
    replace(replace(cust_gender, 'M', '남'), 'F', '여') AS 성별
FROM
    customers
WHERE
    cust_year_of_birth >= 1980
ORDER BY
    나이,
    1 ASC;
    
/* 집계함수 대상 데이터에서 특정 그룹으로 묶어
   그 그룹에 대해 총합, 평균, 최댓값 등을 구하는 함수
*/
-- COUNT <- 로우의 건수 집계
SELECT COUNT(*)                  -- NULL 포함 
     , COUNT(ALL department_id)  -- default ALL
     , COUNT(department_id)  -- all은 중복 포함 = ALL 
     , COUNT(distinct department_id)  -- 중복제거 
FROM employees;

-- 반 학생의 수
SELECT COUNT(*)
FROM TB_INFO;
WHERE PC_NO != 'SSAM';

-- AVG : 평균
SELECT AVG(mem_mileage)
FROM member;

-- employee의 평균 급여와 직원수를 출력하시오
-- 소수점 둘째자리까지 출력
SELECT
    *
FROM
    employees;
SELECT ROUND(AVG(salary), 2) as 평균급여
     , COUNT(employee_id) as 직원수
FROM employees;

SELECT ROUND(AVG(salary),2)
     , MIN(salary)
     , MAX(salary)
     , SUM(salary)
FROM employees;

-- 50 부서의 직원수와 평균 최소 최대 급여를 출력하시오

SELECT COUNT(employee_id)     as 직원수 
     , ROUND(AVG(salary), 2)  as 평균급여   
     , MIN(salary)            as 최소급여 
     , MAX(salary)            as 최대급여
FROM employees
WHERE department_id = 50
OR    department_id = 60;   -- 두 값을 비교

-- 부서별 '직원수'와, '평균 급여'
-- GROUP BY 절
SELECT department_id
     , COUNT(employee_id)     as 부서별직원수
     , ROUND(AVG(salary), 2)  as 부서평균급여
FROM employees
GROUP BY department_id    -- 집계함수를 제외한 SELECT절에 들어간 컬럼(department_id)은
                          -- GROUP BY절에 들어가야함
ORDER BY 1;

-- member 테이블 직업별 고객 수를 출력하시오
SELECT *
FROM member;

SELECT MEM_JOB as 직업
     , COUNT(mem_id) as 고객수
FROM member
GROUP BY MEM_JOB
ORDER BY 2 desc;

-- distinct 중복제거
SELECT distinct mem_job
FROM member;


- 연도별, 지역별, 대출총액을 구하시오
SELECT region
     , sum(loan_jan_amt) as 대출총액
FROM kor_loan_status
GROUP BY region
ORDER BY 2 desc;

desc kor_loan_status; -- 타입 확인

SELECT substr(period, 1, 4) as 연도
     , region
     , sum(loan_jan_amt) as 대출합계
FROM kor_loan_status
WHERE substr(period, 1, 4) = '2013'
GROUP BY substr(PERIOD, 1, 4), region
ORDER BY 2;

-- HAVING
-- 3명 이상 있는 직업만 출력하시오
SELECT MEM_JOB as 직업
     , COUNT(mem_id) as 고객수
FROM member
GROUP BY MEM_JOB
HAVING COUNT(mem_id) >= 3
ORDER BY 2 desc;
-- 작업 순서 
-- FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY 

-- 직원수가 30명 이상인 부서와 직원수를 출력하시오
-- employees

SELECT department_id  as 부서 
     , COUNT(employee_id) as 직원수
FROM employees
GROUP BY department_id
HAVING COUNT(employee_id) >= 30
ORDER BY 2 desc;

SELECT department_id
     , COUNT(employee_id)
FROM employees;

-- 의사컬럼 ROWNUM : 테이블에 없는데 있는 것처럼 사용 
-- 임시로 번호가 생김 
SELECT ROWNUM as rnum
     , a.*
FROM member a;

SELECT *
FROM (
        SELECT rownum as rnum
             , a.*
        FROM (  SELECT *
                FROM member
                ORDER BY mem_name
             ) a
      );
SELECT *
FROM member
ORDER BY mem_name;

--요일별 입사직원수를 조회하시오(hire_date) 
--employee에 있는 직원 
SELECT *
FROM employees;

SELECT TO_CHAR(HIRE_DATE , 'Day') as 요일
       , COUNT(employee_id)        as 직원수
FROM employees
GROUP BY TO_CHAR(HIRE_DATE, 'Day');
ORDER BY to_char(hire_date-1,'D');

SELECT cust_gender
     , cust_name
     , case when cust_gender = 'M' then '남자'
            when cust_gender = 'F' then '여자'
        else '?'
    END as gender
    , DECODE(cust_gender, 'M', '남자', 'F', '여자','?') as gender2
                        --조건1 결과1 조건2 결과2 그밖
FROM customers;

-- 직원의 고용일자 컬럼을 활용하여 employee
-- 연도별 요일별 입사인원수를 출력하시오 (정렬 연도)
-- ex) TO_CHAR, DECODE, GROUP BY, COUNT, SUM .. 사용
-- 1. 고용일자 데이터로 연도도컬럼 생성, 요일 컬럼 생성
-- 2. 생성한 데이터로 집계

SELECT TO_CHAR(HIRE_DATE, 'YYYY') as 연도
     , SUM(DECODE(TO_CHAR(HIRE_DATE, 'DAY'), '월요일', '1','0')) as 월요일
     , SUM(DECODE(TO_CHAR(HIRE_DATE, 'DAY'), '화요일', '1','0')) as 화요일
     , SUM(DECODE(TO_CHAR(HIRE_DATE, 'DAY'), '수요일', '1','0')) as 수요일
     , SUM(DECODE(TO_CHAR(HIRE_DATE, 'DAY'), '목요일', '1','0')) as 목요일
     , SUM(DECODE(TO_CHAR(HIRE_DATE, 'DAY'), '금요일', '1','0')) as 금요일
     , SUM(DECODE(TO_CHAR(HIRE_DATE, 'DAY'), '토요일', '1','0')) as 토요일
     , SUM(DECODE(TO_CHAR(HIRE_DATE, 'DAY'), '일요일', '1','0')) as 일요일
     , COUNT(employee_id)
FROM employees
GROUP BY TO_CHAR(HIRE_DATE, 'YYYY')
ORDER BY 1;