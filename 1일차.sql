CREATE TABLE ex1_1 (
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
CREATE TABlE ex1_3 (
     col1 DATE
    ,col2 TIMESTAMP

);
-- SYSDATE, SYSTIMESTAMP <-- 현재시간 
INSERT INTO ex1_3 VALUES(SYSDATE, SYSTIMESTAMP);

SELECT * FROM ex1_3;