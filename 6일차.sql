SELECT PERIOD
     , GUBUN
     , SUM(LOAN_JAN_AMT)
FROM kor_loan_status
WHERE PERIOD LIKE '2013%'
GROUP BY ROLLUP(PERIOD, GUBUN); -- ROLLUP 총계 정보를 나타냄   
-- 표현식의 갯수가 n개면 n + 1 레벨까지 출력( 위는 n = 2 )
-- 1레벨 = 전체 총계, 2레벨 월의 소계(10월 11월 등)

-- member의 직업별 마일리지 합계를 출력하시오
SELECT mem_job
     , sum(mem_mileage) as 마일리지합계
     , GROUPING_id(mem_job) as GROUPING_ID -- 수는 이진수로 표기
                                           -- 이를 이용하여(DECODE로) 로우명을 바꿀 수 있다
     , DECODE(GROUPING_id(mem_job), 1, '총계', mem_job) as mem_job
FROM member
GROUP BY ROLLUP(mem_job);

SELECT mem_job
     , sum(mem_mileage) as 마일리지합계
FROM member
GROUP BY mem_job
UNION
SELECT '합계'
     , SUM(mem_mileage)
FROM member;

SELECT *
FROM member;

SELECT *
FROM cart;

SELECT member.mem_name    /* 고객이름  */
     , member.mem_hp      /* 고객전화번호 */  
     , cart.cart_prod     /* 상품아이디 */
     , cart.cart_qty      /* 구매수량 */ as 갯수
     , prod.prod_name     /* 상품명 */ 
     , prod.prod_sale     /* 상품가격 */
FROM member
    , cart
    , prod
WHERE member.mem_id = cart.cart_member -- 동등 조인 mem_id와 cart_member를 연결
AND cart.cart_prod = prod.prod_id -- 동등 조인 
AND member.mem_name = '김은대';

SELECT m.mem_name    /* 고객이름  */
     , prod.prod_name
     , sum(c.cart_qty * prod.prod_sale) as 총사용금액
FROM member m -- 테이블에도 AS를 설정할 수 있음 
    , cart c
    , prod
WHERE m.mem_id = c.cart_member -- 동등 조인 mem_id와 cart_member를 연결
AND c.cart_prod = prod.prod_id -- 동등 조인 
AND m.mem_name = '김은대'
GROUP BY m.mem_id, m.mem_name, prod.prod_name
order by 3 desc;

-- 동등조인(equi-join) 두 테이블에 데이터가 동등하게 있는 row만 추출
-- 내부조인(inner join)이라고도 함 
SELECT e.emp_name
     , d.department_name
FROM employees e
    , departments d
WHERE e.department_id = d.department_id;
-- 직원번호, 직원이름, 급여, 직업아이디, 직업명을 출력하시오
-- 급여가 15000 이상인 직원만 

SELECT e.employee_id  직원번호 /* 직원번호 */
     , e.emp_name     직원이름 /* 직원이름 */
     , e.salary       급여    /*  급여  */
     , e.job_id       직업아이디 /* 직업아이디 */
     , j.job_title    직업명  /* 직업명 */
-- 두 테이블의 컬럼이 다를 경우 생략해도 가능하나 써주는게 좋음
-- 같은 경우 안쓰면 오류 ex) job_id 
FROM employees e
    , jobs j
WHERE e.job_id = j.job_id
AND e.salary > 15000;



-- 테이블 생성 CREATE
-- 테이블 삭제 DROP
-- 테이블 수정 ALTER
CREATE TABLE ex6_1 (
    col1 varchar2(10) not null
  , col2 varchar2(10) null
  , col3 date default sysdate
);
-- DROP TABLE ex6_1; 테이블 삭제
-- 컬럼명 수정 
ALTER TABLE ex6_1 RENAME COLUMN col1_1 TO col1;
-- 타입 수정
ALTER TABLE ex6_1 MODIFY col2 VARCHAR(30);
-- 컬럼 추가 
ALTER TABLE ex6_1 ADD col4 number;
-- 컬럼 삭제
ALTER TABLE ex6_1 DROP COLUMN col4;
-- 제약조건 추가
ALTER TABLE ex6_1 ADD CONSTRAINTS pk_ex6_1 PRIMARY KEY(col1);
-----------------------------------------------------------

CREATE TABLE 강의내역 (
     강의내역번호 NUMBER(3)
    ,교수번호 NUMBER(3)
    ,과목번호 NUMBER(3)
    ,강의실 VARCHAR2(10)
    ,교시  NUMBER(3)
    ,수강인원 NUMBER(5)
    ,년월 date
);

CREATE TABLE 과목 (
     과목번호 NUMBER(3)
    ,과목이름 VARCHAR2(50)
    ,학점 NUMBER(3)
);

CREATE TABLE 교수 (
     교수번호 NUMBER(3)
    ,교수이름 VARCHAR2(20)
    ,전공 VARCHAR2(50)
    ,학위 VARCHAR2(50)
    ,주소 VARCHAR2(100)
);

CREATE TABLE 수강내역 (
    수강내역번호 NUMBER(3)
    ,학번 NUMBER(10)
    ,과목번호 NUMBER(3)
    ,강의실 VARCHAR2(10)
    ,교시 NUMBER(3)
    ,취득학점 VARCHAR(10)
    ,년월 DATE 
);

CREATE TABLE 학생 (
     학번 NUMBER(10)
    ,이름 VARCHAR2(50)
    ,주소 VARCHAR2(100)
    ,전공 VARCHAR2(50)
    ,부전공 VARCHAR2(500)
    ,생년월일 DATE
    ,학기 NUMBER(3)
    ,평점 NUMBER
);

ALTER TABLE 학생 ADD CONSTRAINTS 학생 PRIMARY KEY(학번);
ALTER TABLE 수강내역 ADD CONSTRAINTS 수강내역 PRIMARY KEY(수강내역번호);
ALTER TABLE 과목 ADD CONSTRAINTS 과목 PRIMARY KEY(과목번호);
ALTER TABLE 교수 ADD CONSTRAINTS 교수 PRIMARY KEY(교수번호);
ALTER TABLE 강의내역 ADD CONSTRAINTS 강의내역 PRIMARY KEY(강의내역번호);

ALTER TABLE 수강내역 ADD CONSTRAINT FK_학생_학번 
            FOREIGN KEY(학번) REFERENCES 학생(학번);
ALTER TABLE 수강내역 ADD CONSTRAINT FK_과목_과목번호 
            FOREIGN KEY(과목번호) REFERENCES 과목(과목번호);
ALTER TABLE 강의내역 ADD CONSTRAINT FK_교수_교수번호 
            FOREIGN KEY(교수번호) REFERENCES 교수(교수번호);
ALTER TABLE 강의내역 ADD CONSTRAINT FK_과목_과목번호2 
            FOREIGN KEY(과목번호) REFERENCES 과목(과목번호);


COMMIT;


