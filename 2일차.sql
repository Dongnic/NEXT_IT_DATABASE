CREATE TABLE ex2_2 (
    col1 varchar2(3)       
   ,col2 varchar2(3 byte) 
   ,col3 varchar2(3 char)
);
--데이터 삽입 
INSERT INTO ex1_2 (col1) VALUES('오라클');
INSERT INTO ex1_2 (col2) VALUES('오라클');
INSERT INTO ex1_2 (col3) VALUES('오라클');
VALUES ('abc', 'abc');
--데이터 조회

INSERT 
SELECT lengthb(col1)
      ,col3
FROM ex1_1;

SELECT * FROM ex1_2;

/* 날짜 데이터 타입
    DATE : 년월일시분초
    TIMESTAMP : 년월일시분초, 밀리세컨드
*/
CREATE TABlE ex2_3 (
     col1 DATE
    ,col2 TIMESTAMP

);
-- SYSDATE, SYSTIMESTAMP <-- 현재시간 
INSERT INTO ex1_3 VALUES(SYSDATE, SYSTIMESTAMP);

SELECT * FROM ex1_3;

/* 숫자 데이터 타입
  number(p, s)
  p : 소수점 기준으로 모든 유효숫자 자릿수
  s : s가 양수이면 소수점 이하,
      s가 음수이면 소수점 기준 왼쪽 유효숫자 자릿수를 나타냄
*/
CREATE TABLE ex1_4 (
    col1 number(3)
   ,col2 number(3, 2)
   ,col3 number(5, -2) -- 왼쪽으로 -2만큼 반올림 ex) 12345 > 12300 
);
CREATE TABLE ex1_5 (
    col1 number
);
SELECT * FROM ex1_5;
INSERT INTO ex1_4 (col1) VALUES(0.7898); --반올림 
INSERT INTO ex1_4 (col1) VALUES(99.5);   --반올림 
INSERT INTO ex1_4 (col1) VALUES(1004);   --오류 

INSERT INTO ex1_4 (col2) VALUES(0.7898); --소수점 3째 자리에서 반올림 
INSERT INTO ex1_4 (col2) VALUES(2.234);
INSERT INTO ex1_4 (col2) VALUES(23.23);  --오류 

INSERT INTO ex1_4 (col3) VALUES(12345.343);  --오류 
INSERT INTO ex1_4 (col3) VALUES(12355);  --오류 
INSERT INTO ex1_4 (col3) VALUES(23.23);  --오류 


SELECT * FROM ex1_4;

/* 제약조건
    1. not null
    2. UNIQUE 제약조건 (중복불가)
    3. Check 제약조건 (조건을 검)
*/

-- 1. not null
CREATE TABLE ex1_6(
    col1 varchar2(50)
   ,col2 varchar2(50) not null
);

INSERT INTO ex1_6 (col1) VALUES('안녕하세요'); --오류 
INSERT INTO ex1_6 (col2) VALUES('안녕하세요');

SELECT * FROM ex1_6;
-- 2. UNIQUE 제약조건 (중복불가)

CREATE TABLE ex1_7(
     col1 varchar2(50)
    ,col2 varchar2(50) unique
);
INSERT INTO ex1_7 VALUES ('abc','abc');
INSERT INTO ex1_7 VALUES ('abc','abc');

--3. Check 제약조건 (조건을 검)
CREATE TABLE ex1_8(
    nm varchar2(30) not null
    ,age number
    ,gender char(1)
    ,constraint ck_ex_age check(age between 1 and 150)
    ,constraint ck_ex_gender check(gender in ('M', 'F'))
);

INSERT INTO ex1_8 VALUES ('짱구', 10, 'M');     --정상처리 
INSERT INTO ex1_8 VALUES ('홍길동', 200, 'M');  --오류 check 1 ~ 150 범주 밖 
INSERT INTO ex1_8 VALUES ('펭수', 11, 'P');     --오류 check M or F 아님 

SELECT * FROM ex1_8;
/*
    기본키 Primary key (PK)
    외래키 Foreign key (FK)
*/

CREATE TABLE dep (
     deptno number(3) primary key
    ,depyname varchar2(20)
    ,floor number(5)
);
CREATE TABLE emp (
     empno number(5) primary key
    ,empname varchar2(20)
    ,title varchar2(20)
    ,dno number(3) constraint emp_fk references dep(deptno)
    ,salary number
);
INSERT INTO dep VALUES(1, '영업', 8);
INSERT INTO dep VALUES(2, '기획', 10);
INSERT INTO dep VALUES(3, '개발', 9);
INSERT INTO emp VALUES(1001, '김창섭', '대리', 2, 2000000);
INSERT INTO emp VALUES(1002, '박영권', '과장', 3, 3000000);
INSERT INTO emp VALUES(1003, '김펭귄', '사장', 5, 12000000);  --4번째 5가 참조할 항목이 없으므로 오류 

SELECT * FROM dep, emp
where dep.deptno = emp.dno
and emp.empno = '김창섭';

/*
    DEFAULT 제약조건
*/
CREATE TABLE ex1_9 (
     col1 varchar2(10)
    ,col2 date default sysdate
    ,col3 date default sysdate - 1
);
INSERT INTO ex1_9 (col1) VALUES ('1');
INSERT INTO ex1_9 (col1) VALUES ('2');
INSERT INTO ex1_9 (col1) VALUES ('3');
INSERT INTO ex1_9 VALUES ('4','20220101','20220401');

SELECT * FROM EX1_9;

SELECT emp_name             as nm  ----Alias(별칭)
    , phone_number          as 전화번호
    , salary                as "월  급" -- 띄어쓰기 하려면 쌍 따옴표 사용 
    , email                    이메일  -- as 안써도 문법상 컬럼 옆에 문구는 별칭으로 인식 
From employees
WHERE department_id = 60  -- 검색조건 
ORDER BY salary asc, emp_name desc; -- 정렬조건 asc 오름, desc 내림

-- 시스템 실행 순서 FROM -> WHERE -> SELECT -> ORDER BY 
-- 고로 Alias 는 SELECT 이전 순서에서 사용할 수 없다. 

/*
INSERT : 데이터 삽입
*/
--1. 기본형태
CREATE TABLE ex3_1 (
      col1 varchar2(30)
     ,col2 number
     ,col3 date
);
--1. 기본형태
INSERT INTO ex3_1 (col1, col2, col3)
VALUES ('abc', 10, sysdate);
--2. 컬럼명 생략
INSERT INTO ex3_1
VALUES ('abc', 10, sysdate);
--3. SELECT - INSERT
INSERT INTO ex3_1
SELECT emp_name
     , salary
     , hire_date
FROM employees;
SELECT *
FROM ex3_1;

--employee 테이블의 emp_name과 department_id를
--다음 테이블에 저장하시오
CREATE TABLE ex3_2(
    nm varchar2(30)
   ,dep_no number 
   );
INSERT INTO ex3_2
SELECT emp_name 
     , department_id
FROM employees;
SELECT *
FROM ex3_2
ORDER BY DEP_NO asc;

/*
데이터 수정 UPDATE
*/

UPDATE emp             --수정하고자 하는 테이블
SET salary = 2500000   --수정 데이터
    , title = '사원'
WHERE empno = 1001;    --수정될 데이터 검색 조건 매우 중요!! 주로 pk가 걸려있는 식별자 사용 

SELECT *
FROM emp;

/*
데이터 삭제
*/
DELETE emp
WHERE empno = 1001;

CREATE TABLE TB_INFO2 (
     INFO_NO number(3) primary key
    ,PC_NO varchar2(10) not null
    ,NM varchar2(20)
    ,EMAIL varchar2(100)
    ,HOBBY varchar2(1000)
);

--제약조건 조회
SELECT *
FROM user_constraints
WHERE owner = 'JAVA';

CREATE TABLE ex3_3 (
    seq number
    ,nm varchar2(20)
    ,dt data
    ,constraint pk_3_3 primary key (seq, nm)
);
