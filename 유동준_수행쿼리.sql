
-- 1번 문제
CREATE TABLESPACE TS_STUDY
datafile '/u01/app/oracle/oradata/XE/ts_study.dbf'
size 100M autoextend on next 5M;

-- 2번 문제 
CREATE USER java2 IDENTIFIED BY oracle
DEFAULT TABLESPACE TS_STUDY
TEMPORARY TABLESPACE temp;

-- 3번 문제
GRANT connect, resource TO java2;

-- 4번 문제
CREATE TABLE EX_MEM (
       MEM_ID varchar2(10) constraint PK_EX_MEM primary key not null
     , MEM_NAME varchar2(20) not null
     , MEM_JOB varchar2(30)
     , MEM_MILEAGE number(8, 2) DEFAULT 0
     , MEM_REG_DATE DATE DEFAULT SYSDATE    
);

COMMENT ON TABLE EX_MEM IS '임시회원테이블';
COMMENT ON COLUMN EX_MEM.MEM_ID IS '아이디';
COMMENT ON COLUMN EX_MEM.MEM_NAME IS '회원명';
COMMENT ON COLUMN EX_MEM.MEM_JOB IS '직업';
COMMENT ON COLUMN EX_MEM.MEM_MILEAGE IS '마일리지';
COMMENT ON COLUMN EX_MEM.MEM_REG_DATE IS '등록일';

-- 5번 문제 
ALTER TABLE EX_MEM MODIFY MEM_NAME VARCHAR2(50);

-- 6번 문제 

CREATE SEQUENCE SEQ_CODE
INCREMENT BY 1        -- 증강숫자
START WITH   1000     -- 시작숫자
MINVALUE     1        -- 최솟값 
MAXVALUE     9999   -- 최댓값 
NOCYCLE               -- 디폴트 NOCYCLE 최대, 최소 도달중지
NOCACHE; 

SELECT SEQ_CODE.nextval -- 값 증가
     , SEQ_CODE.currval -- 현재 값 
FROM dual;

DROP SEQUENCE SEQ_CODE;

-- 7번 문제 

INSERT INTO EX_MEM (MEM_ID, MEM_NAME, MEM_JOB, MEM_REG_DATE)
VALUES ('hong', '홍길동', '주부', sysdate);

-- 8번 문제

INSERT INTO EX_MEM (MEM_ID, MEM_NAME, MEM_JOB, MEM_MILEAGE)
SELECT MEM_ID
     , MEM_NAME
     , MEM_JOB
     , MEM_MILEAGE  
FROM member
WHERE MEM_LIKE = '독서' or MEM_LIKE = '등산' or MEM_LIKE = '바둑';  

-- 9번 문제 

DELETE EX_MEM
WHERE MEM_NAME = '김%';

-- 10번 문제

SELECT MEM_ID
     , MEM_NAME
     , MEM_JOB
     , MEM_MILEAGE
FROM member
WHERE MEM_JOB = '주부'
AND MEM_MILEAGE > 1000 and MEM_MILEAGE < 3000
ORDER BY 4 desc;

-- 11번 문제

SELECT PROD_ID, PROD_NAME, PROD_SALE
FROM PROD
WHERE PROD_SALE = 23000
OR PROD_SALE = 26000
OR PROD_SALE = 33000;

-- 12번 문제

SELECT *
FROM       (SELECT MEM_JOB
                 , COUNT(MEM_JOB) as MEM_CNT
                 , TO_CHAR(MAX(MEM_MILEAGE),'999,999,999') as MAX_MLG
                 , TO_CHAR(AVG(MEM_MILEAGE),'999,999,999') as AVG_MLG
            FROM member
            GROUP BY MEM_JOB) t1
WHERE t1.mem_cnt >= 3;

-- 13번 문제

SELECT a.MEM_ID
     , a.MEM_NAME
     , a.MEM_JOB
     , b.CART_PROD
     , b.CART_QTY
FROM member a, cart b
WHERE a.mem_id = b.cart_member
AND substr(b.cart_no,0,8) = '20050728';

-- 14번 문제

SELECT a.MEM_ID
     , a.MEM_NAME
     , a.MEM_JOB
     , b.CART_PROD
     , b.CART_QTY
FROM member a
LEFT OUTER JOIN cart b 
ON (a.mem_id = b.cart_member)
WHERE a.mem_id = b.cart_member
AND substr(b.cart_no,0,8) = '20050728';

-- 15번 문제

SELECT  MEM_ID
      , MEM_NAME
      , MEM_JOB
      , MEM_MILEAGE
      , RANK() OVER(PARTITION BY MEM_JOB
                   ORDER BY MEM_MILEAGE DESC) as MEM_RANK             
FROM member;