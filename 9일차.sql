SELECT a.employee_id, a.emp_name
     , a.department_id, b.department_name
FROM employees a
   , departments b
WHERE a.department_id = b.department_id;

--VIEW 생성 
CREATE OR REPLACE VIEW emp_dept AS
SELECT a.employee_id, a.emp_name
     , a.department_id, b.department_name
FROM employees a
   , departments b
WHERE a.department_id = b.department_id;

--java 사용자에게 VIEW를 만들 수 있는 권한을 부여 (system 계정 사용)
GRANT CREATE VIEW TO java; 

-- 1. 계정 생성 (system 계정 사용)
CREATE USER study IDENTIFIED BY study;
-- 1. 접속 권한 부여 (system 계정 사용)
GRANT CONNECT TO study;

-- 2. emp_dept(view객체) 조회할 수 있는 권한 부여(emp_dept테이블을 만든 계정에서 부여(java))
GRANT SELECT ON emp_dept TO study;

/* 권한부여 실행순서
    
    1. System계정(Oracle)에서 계정 생성(study) 및 접속 권한 부여   
    2. java 계정에서 만든 view객체(emp_dept)를 조회할수 있는 권한을 부여
    3. study 계정에서 java의 view객체 조회
       문법 = select * from java.emp_dept;

*/

CREATE OR REPLACE VIEW tb_hak AS
SELECT 학번 as hak_no
     , 이름 as han_nm
FROM 학생; -- 한 개의 테이블만 사용한 VIEW는 단순 뷰라고 함 
GRANT SELECT ON tb_hak TO study; -- 조회 권한
GRANT INSERT ON tb_hak TO study; -- 삽입 권한
/*
    VIEW는 실제 데이터는 테이블에 있지만 마치 테이블처럼 사용
    1. 자주 사용하는 SQL을 뷰로 만들어 편리하게 이용가능
    2. 데이터 보안 측면에서 중요한 컬럼은 감출 수 있음
    단순 뷰
      - 테이블 하나로 생성하여 INSERT/UPDATE/DELETE 가능
      - 그룹함수 불가능 
    복합 뷰 
      - 여러개 테이블로 생성 INSERT/UPDATE/DELETE 가능
      - 그룹함수 가능

    CONNECT, RESOURCE, DBA (롤)
    롤 : 다수 사용자와 다양한 권한을 효과적으로
         관리하기위해 권한을 그룹화 한 개념
    CONNECT : 사용자가 데이터 베이스 접속할 수 있는 권한을 그룹화한 롤      
    RESOURCE : 테이블, 시퀀스, 트리거와 같은 객체 생성 권한을 그룹화한 롤
    DBA : 모든권한 

*/

--시스템 계정에서 조회 가능
--계정 롤 권한 조회
SELECT *
FROM DBA_ROLE_PRIVS
WHERE GRANTEE ='JAVA';

SELECT *
FROM DBA_SYS_PRIVS
WHERE GRANTEE ='JAVA';

SELECT *
FROM DBA_SYS_PRIVS
WHERE GRANTEE ='RESOURCE';

/*  시노님 Synonym '동의어'란 뜻으로 객체 각자의
    고유한 이름에 대한 동의어를 만드는 것
    
    PUBLIC 모든 사용자 접근가능
    PRIVATE 특정 사용자만 사용(디폴트 값)

*/
-- 시노님 생성 권한 부여
GRANT CREATE SYNONYM TO java;
-- channels 테이블 이름에 별칭을 syn_channel로 부여
CREATE OR REPLACE SYNONYM syn_channel
FOR channels;

SELECT *
FROM syn_channel;
-- study 계정에 해당 테이블 조회 권한을 부여 (java계정에서) 
GRANT SELECT ON syn_channel TO study;

-- PUBLIC 시노님은 DBA권한이 있는 계정만 가능함 (Oracle 계정)
CREATE OR REPLACE PUBLIC SYNONYM hak
FOR java.학생;
GRANT SELECT ON hak TO study;

DROP PUBLIC SYNONYM hak;
DROP VIEW emp_dept;

SELECT *
FROM user_constraints
WHERE CONSTRAINT_NAME LIKE '%PK%';

--commant
COMMENT ON TABLE TB_INFO IS '4월반';
COMMENT ON COLUMN TB_INFO.PC_NO IS '컴퓨터번호';
COMMENT ON COLUMN TB_INFO.INFO_NO IS '기본번호';
COMMENT ON COLUMN TB_INFO.NM IS '이름';
COMMENT ON COLUMN TB_INFO.HOBBY IS '취미';

/*  시퀀스 객체 SEQUENCE
    자동 순번을 반환하는 객체로 (CURRVAL, NEXTVAL) 사용
*/
CREATE SEQUENCE my_seq
INCREMENT BY 1        -- 증강숫자
START WITH   1        -- 시작숫자
MINVALUE     1        -- 최솟값 
MAXVALUE     999999   -- 최댓값 
NOCYCLE               -- 디폴트 NOCYCLE 최대, 최소 도달중지
NOCACHE;              -- 디폴트 NOCACHE 메모리에 값 미리할당 여부 

SELECT my_seq.nextval -- 값 증가
     , my_seq.currval -- 현재 값 
FROM dual;

DROP SEQUENCE my_seq;
--시퀀스 생성 직후 현재 값이 없으므로 아래 구문은 오류 
SELECT my_seq.currval -- 현재 값 
FROM dual;

CREATE TABLE ex9_1 (
    seq number
  , dt timestamp default systimestamp
  );
  
INSERT INTO ex9_1 (seq) VALUES(my_seq.nextval); 

SELECT *
FROM ex9_2;

CREATE TABLE ex9_2 (
    seq varchar2(10) primary key
  , dt timestamp default systimestamp
  );
-- ex9_2 테이블에 seq 값이 0000000001 ~ 0000010000
-- 위의 형태로 저장되도록 INSERT문을 작성하시오 
DROP SEQUENCE seq_test;
DROP TABLE ex9_2;

INSERT INTO ex9_2 (seq) VALUES(seq_test.nextval);
INSERT INTO ex9_2 (seq) VALUES(LPAD(seq_test.nextval,10,'0'));

SELECT LPAD(my_seq.nextval,10,'0')
FROM dual;


SELECT *
FROM ex9_1;
INSERT INTO ex9_1(seq)
VALUES((SELECT NVL(max(seq), 0) + 1
FROM ex9_1));

/* 과목 테이블에 머신러닝 과목이 있으면 학점을 6으로 업데이트
                              없으면 번호를 생성하여 인서트
                            (과목이름 : 머신러닝, 학점 3)
*/
SELECT NVL(max(과목번호), 0) + 1
FROM 과목;

MERGE INTO 과목 a --대상테이블
USING DUAL        --비교테이블
ON (a.과목이름 = '머신러닝')
WHEN MATCHED THEN
 UPDATE SET a.학점 = 6
WHEN NOT MATCHED THEN
 INSERT (a.과목번호, a.과목이름, a.학점)
 VALUES ((SELECT NVL(MAX(과목번호), 0) +1
        FROM 과목)
        , '머신러닝', 3);
        
        
-- 이탈리아의 2000년 연평균 매출보다 
--                 월평균 매출이 높은 월과 평균 월평균 매출액을 출력하시오

-- sales a, customers b, countries c 사용 
-- sales_month, amount_sold, country_id, country_name, cust_id
/*select 월평균.월 , 월평균.값
  from ()월평균 
      ,()년평균
where 월평균.값 > 년평균.값
*/

-- 연 평균
SELECT ROUND(AVG(a.amount_sold)) 연평균  
FROM sales a, customers b, countries c
WHERE a.cust_id = b.cust_id
AND b.country_id = c.country_id
AND c.country_name = 'Italy'
AND a.sales_month Like '2000%'; 
-- 월 평균 
SELECT a.sales_month 월
             , ROUND(AVG(a.amount_sold)) 월평균  
FROM sales a, customers b, countries c
WHERE a.cust_id = b.cust_id
AND b.country_id = c.country_id
AND c.country_name = 'Italy'
AND a.sales_month Like '2000%'
GROUP BY a.sales_month; 

-- 문제 -- 
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




SELECT *
FROM sales a, customers b, countries c
WHERE a.cust_id = b.cust_id
AND b.country_id = c.country_id
AND c.country_name = 'Italy';