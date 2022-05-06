-- 계층형 쿼리

SELECT department_id, 
       department_name, 
       0 AS PARENT_ID,
       1 as levels,
        parent_id || department_id AS sort
FROM departments 
WHERE parent_id IS NULL
UNION ALL
SELECT t2.department_id, 
       LPAD(' ' , 3 * (2-1)) || t2.department_name AS department_name, 
       t2.parent_id,
       2 AS levels,
       t2.parent_id || t2.department_id AS sort
FROM departments t1,
     departments t2
WHERE t1.parent_id is null
  AND t2.parent_id = t1.department_id
UNION ALL
SELECT t3.department_id, 
       LPAD(' ' , 3 * (3-1)) || t3.department_name AS department_name, 
       t3.parent_id,
       3 as levels,
       t2.parent_id || t3.parent_id || t3.department_id as sort
FROM departments t1,
     departments t2,
     departments t3
WHERE t1.parent_id IS NULL
  AND t2.parent_id = t1.department_id
  AND t3.parent_id = t2.department_id
UNION ALL
SELECT t4.department_id, 
       LPAD(' ' , 3 * (4-1)) || t4.department_name as department_name, 
       t4.parent_id,
       4 as levels,
       t2.parent_id || t3.parent_id || t4.parent_id || t4.department_id AS sort
FROM departments t1,
     departments t2,
     departments t3,
     departments t4
WHERE t1.parent_id IS NULL
  AND t2.parent_id = t1.department_id
  AND t3.parent_id = t2.department_id
  and t4.parent_id = t3.department_id
ORDER BY sort;

/* 10일차 */

SELECT department_id
     , LPAD(' ', 3 * (level - 1)) || department_name as 부서명
     , level
     , parent_id -- parent_id를 기준으로 순서대로 level이 정해진다.
                 -- level 1 = parent_id null 
                 -- level 2 = parent_id 10 -> department_id 20, 30, 40, 50...등 
                 -- level 3 = level 2의 department_id의 값이 parent_id가 되는 곳
                 -- ex) parent_id 30, 40 ..= department_id 170, 180 ..등 
FROM departments
START WITH parent_id is null   --시작점      -- 최상위(root) 조건
-- parent_id 값이 null인 쪽부터 시작
CONNECT BY PRIOR department_id = parent_id; -- 계층구조 조건

SELECT employee_id
    , manager_id
    , level
    , LPAD(' ', 3 * (level - 1)) || emp_name as 직원명
FROM employees
START WITH manager_id is null
CONNECT BY PRIOR employee_id = manager_id;

-- 30번 부서직원의 관리자

SELECT a.employee_id
     , a.emp_name
     , level
     , b.department_name
     , b.department_id
FROM employees a
    ,departments b
WHERE a.department_id = b.department_id
AND a.department_id = 30 -- 검색조건( depart_id가 30번인 결과)
START WITH a.manager_id is null
CONNECT BY PRIOR a.employee_id = a.manager_id
--최상위 계층도 나오게 하려면 AND절을 계층형쿼리 다음에 쓴다.
-- AND a.department_id = 30 이 위치에 검색조건 
ORDER SIBLINGS BY a.emp_name desc;
-- 계층형 쿼리절에서 ORDER BY절을 사용하려면 SIBLINGS를 붙여야한다.

select *
from employees;

-- 부서아이디 = 230 부서명 : IT 헬프데스크
-- 팀의 하위 부서가 신설됐습니다.
-- 5 level에 해당하는 'IT 데이터 수집팀'을 부서테이블에
-- INSERT 후 조회하시오

select department_id
from departments; 
INSERT INTO departments (department_id, department_name, parent_id)
VALUES ('280', 'IT 데이터 수집팀', '230');

SELECT level
     , a.department_name
     , a.department_id
FROM departments a
WHERE a.department_id = 60 -- 검색조건( depart_id가 30번인 결과)
START WITH a.parent_id is null
CONNECT BY PRIOR a.department_id = a.parent_id;
--최상위 계층도 나오게 하려면 AND절을 계층형쿼리 다음에 쓴다.
-- AND a.department_id = 30 이 위치에 검색조건 

--아래와같이 출력되도록 (1) 테이블 생성 ex (테이블 명 : 팀)
--                   (2) 데이터 삽입 
--                   (3) 계층형쿼리 조회 하시오

CREATE TABLE team1 (
       team_id number(10)
     , team_name varchar2(20)
     , department_name varchar2(20)
     , manager_id number(10)
);
INSERT INTO team1 VALUES('', '이사장', '사장', 101);
INSERT INTO team1 VALUES(101, '김부장', '부장', 102);
INSERT INTO team1 VALUES(102, '서차장', '차장', 103);
INSERT INTO team1 VALUES(103, '장과장', '과장', 104);
INSERT INTO team1 VALUES(104, '이대리', '대리', 105);
INSERT INTO team1 VALUES(105, '최사원', '사원', 110);
INSERT INTO team1 VALUES(105, '김사원', '사원', 111);
INSERT INTO team1 VALUES(103, '박과장', '과장', 120);
INSERT INTO team1 VALUES(120, '김대리', '대리', 108);
INSERT INTO team1 VALUES(108, '강사원', '사원', 112);
DELETE team1;
drop table team1;

select *
from team1;


SELECT team_name       이름 
     , LPAD(' ', 3 * (level - 1)) || department_name as 부서명
     , level 
FROM team1
START WITH team_id is null
CONNECT BY PRIOR manager_id = team_id;
--최상위 계층도 나오게 하려면 AND절을 계층형쿼리 다음에 쓴다.
-- AND a.department_id = 30 이 위치에 검색조건 

--CONNECT BY PRIOR 자식 = 부모 
--CONNECT BY PRIOR 부모 = 부모 

-- 무한루프 상황
UPDATE departments
SET parent_id = 170
WHERE department_id = 30;

SELECT *
FROM departments
WHERE department_id = 30;

SELECT level
     , b.department_name
     , b.department_id
     , CONNECT_BY_ISCYCLE -- 문제가 되는 데이터 1
     , LPAD(' ', 3 * (level - 1)) || department_name as 부서명
FROM departments b
START WITH parent_id = 30
CONNECT BY NOCYCLE b.department_id = parent_id;

-- 무한루프 상황일경우에는 NOCYCLE 사용하여 멈추게하고
-- CONNECT_BY_ISCYCLE 함수를 사용하여 원인이 되는 행을 찾는다

SELECT department_id
     , parent_id
     , level
     , LPAD(' ', 3 * (level - 1)) || department_name as 부서명
     , CONNECT_BY_ROOT department_name as 최상위데이터
     , CONNECT_BY_ISLEAF as 하위있는지 -- 마지막이면 1, 자식이 있으면 0
     , SYS_CONNECT_BY_PATH (department_name, '|') as 연결정보 
FROM departments 
START WITH parent_id is null
CONNECT BY NOCYCLE department_id = parent_id;

-- LEVEL은 오라클에서 실행되는 모든 쿼리 내에서 사용가능한
-- 가상의 열로 (CONNECT BY 절과) 함께 사용된다.
-- 트리 내에서 어떤 단계에 있는지를 나타내는 정수 값 
-- 정수형 데이터가 필요할 때 사용
SELECT level
FROM dual
CONNECT BY LEVEL <= 12;
-- 201701 ~ 201712
SELECT '2011'|| LPAD(level, 2, '0') as 년월
FROM dual
CONNECT BY LEVEL <= 12;

SELECT period            as 년월
     , sum(loan_jan_amt) as 합계
FROM kor_loan_status
WHERE period like '2011%'
GROUP BY period;

SELECT a.년월
     , NVL(b.합계, 0) as 합계 
FROM  (SELECT '2011'|| LPAD(level, 2, '0') as 년월
      FROM dual
      CONNECT BY LEVEL <= 12) a
,     (SELECT period            as 년월
          , sum(loan_jan_amt) as 합계
      FROM kor_loan_status
      WHERE period like '2011%'
      GROUP BY period) b
WHERE a.년월 = b.년월(+)
ORDER BY 1;

-- CONNECT BY LEVEL을 서용하여 (동적으로) 다음 달이 되면
--                          쿼리 수정없이 31일까지 출력이 되도록
-- 이번달 20220401 ~ 이번달 마지막 날까지 데이터를 출력하시오 
-- 20220401
-- 20220402
-- .....
-- 20220430

--월--
SELECT a.년월일 || b.년월일
FROM
(SELECT '2022'|| LPAD(level, 2, '0') as 년월일
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE),'MM')) a
,
(SELECT LPAD(level, 2, '0') as 년월일
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE),'DD')) b
WHERE b.년월일 = a.년월일(+);

SELECT TO_CHAR(SYSDATE,'YYYYMM') || LPAD(level, 2, '0') as 년월일
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(SYSDATE),'DD');

-- reservation 테이블을 활용하여 (study계정)
-- 금천 지점의 요일별 예약수를 출력하시오 (취소제외)

SELECT b.요일
     , NVL(a.예약수, 0) 예약수
FROM
    (SELECT TO_CHAR(TO_DATE('20220423','yyyymmdd')+level,'day') as 요일
    FROM dual
    CONNECT BY LEVEL <= 7) b
,
    (SELECT TO_CHAR(TO_DATE(reserv_date,'yyyymmdd'),'day') 요일
         , count(reserv_no) 예약수 
    FROM reservation   
    WHERE BRANCH = '금천'
    AND CANCEL = 'N'
    GROUP BY TO_CHAR(TO_DATE(reserv_date,'yyyymmdd'),'day')
    ORDER BY 1) a
WHERE b.요일 = a.요일(+)
ORDER BY 1;

SELECT *
FROM
(SELECT TO_DATE('20220423','yyyymmdd')+level as 요일
    FROM dual
    CONNECT BY LEVEL <= 7) b
,    
(SELECT TO_DATE(reserv_date,'yyyymmdd') 요일
         , count(reserv_no) 예약수 
    FROM reservation   
    WHERE BRANCH = '금천'
    AND CANCEL = 'N'
    GROUP BY TO_DATE(reserv_date,'yyyymmdd')
    ORDER BY 1) a   
WHERE b.요일 = a.요일(+)
ORDER BY 1;