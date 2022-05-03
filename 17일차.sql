SET SERVEROUTPUT ON;
/*
    PROCEDURE 프로시저
    업무적으로 복잡한 구문을 별도의 구문으로 작성하여
    DB에 저장하고 실행가능한 고유한 기능을 수행하는 객체
    함수와 유사하지만 서버에서 실행되며 리턴값을 0 ~ n개로 설정가능
    DML문에서는 사용하지 못하며 PL/SQL 문에서 사용가능
*/
CREATE OR REPLACE PROCEDURE my_job_proc
(     p_job_id IN JOBS.JOB_ID%TYPE
    , p_job_title IN JOBS.JOB_TITLE%TYPE
    , p_min_sal   IN JOBS.MIN_SALARY%TYPE
    , p_max_sal   IN JOBS.MAX_SALARY%TYPE -- :=1000; 방식으로 DEFAULT 설정 가능
)
IS
BEGIN
  INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
  VALUES (p_job_id, p_job_title, p_min_sal, p_max_sal);
  COMMIT;
END;
-- 실행
EXEC my_job_proc('SM_JOB1', 'Sample JOB1', 1000, 5000);
-- EXECUTE my_job_proc('SM_JOB1', 'Sample JOB1', 1000, 5000);
SELECT *
FROM JOBS
WHERE JOB_ID = 'SM_JOB1';

-- IN : 프로시저 내부에서 사용
-- OUT : 리턴 변수
-- IN OUT : 내부에서도 사용 리턴도 됨
CREATE OR REPLACE PROCEDURE test_proc (
     p_val1 VARCHAR2 --디폴트 IN
    ,p_val2 OUT VARCHAR2
    ,p_val3 IN OUT VARCHAR2
)
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE('p_val1 :' || p_val1);
  DBMS_OUTPUT.PUT_LINE('p_val2 :' || p_val2);
  DBMS_OUTPUT.PUT_LINE('p_val3 :' || p_val3);
  p_val2 := 'B2';
  p_val3 := 'C2';
END;
-- OUT 변수 테스트는 리턴받을 변수가 필요함 
DECLARE
  v_var1 VARCHAR2(30) := 'A';
  v_var2 VARCHAR2(30) := 'B';
  v_var3 VARCHAR2(30) := 'C';
BEGIN
 --PL/SQL에서 실행시 호출명령어 필요없음
 test_proc(v_var1, v_var2, v_var3);
 DBMS_OUTPUT.PUT_LINE('v_var2 :' || v_var2);
 DBMS_OUTPUT.PUT_LINE('v_var3 :' || v_var3);
END; 

/*  매개변수
    구분 값, 부서번호, 부서명을 입력 받아
    INSERT : I
    UPDATE : U
    DELECT : D를 수행하는 프로시저를 작성하시오
*/
--CREATE TABLE ex17_1 AS
--SELECT department_id, department_name
--FROM departments;
--ALTER TABLE ex17_1 ADD CONSTRAINT pk_17 PRIMARY KEY(department_id);
--
--CREATE OR REPLACE PROCEDURE dep_proc (
--    p_flag VARCHAR2
--    ,P_id ex17_1.department_id%TYPE
--    ,p_nm ex17_1.department_name%TYPE := NULL)
--IS
--BEGIN
--    -- I INSERT, U UPDATE, D DELETE
--    IF p_flag = 'I' THEN
--     INSERT INTO ex17_1 VALUES(p_id, p_nm);
--    ELSIF p_flag = 'U' THEN
--     UPDATE ex17_1
--     SET department_id
--    END IF;
--    COMMIT;
--END;    

EXEC('I',300,'소셜마케팅팀');

CREATE OR REPLACE PROCEDURE test_no_ex_proc
IS
 vi_num number 
END;

BEGIN
 test_no_ex_proc; -- 프로시저 내부 오류로 멈춤
 DBMS_OUTPUT.PUT_LINE('success!');
END;

/*   트랜잭션(Transaction) : '거래'라는 뜻으로 은행에서는 입금과
                             출금을 하는 거래를 뜻하며 
                             사용자, 오라클 서버, 개발자, DBA 등에게
                             데이터 일치성과 동시발생을 보장하기 위해
                             트랜잭션 처리를 한다
                             업무의 가장 작은 단위로 구분하며
                             해당업무가 성공하면 COMMIT;
                             하나라도 실패하면 ROLLBACK을 통해
                             작업 이력을 제거한다.
                             
    SAVEPOINT : 작업 취소의 부분을 지정할 수 있음                       
*/

CREATE TABLE ex17_2 (
    seq number
    ,nm varchar2(20)
);

CREATE OR REPLACE PROCEDURE save_teat_proc(flag varchar2)
IS
    point1 EXCEPTION;
    point2 EXCEPTION;
    vn_num NUMBER;
BEGIN
    INSERT INTO ex17_2 VALUES(1, 'POINT1 BEFORE');
    SAVEPOINT mysavepoint1;
    INSERT INTO ex17_2 VALUES(2, 'POINT2 BEFORE');
    SAVEPOINT mysavepoint2;
    INSERT INTO ex17_2 VALUES(3, 'END');
    
    IF flag = '1' THEN
     RAISE point1;
    ELSIF flag = '2' THEN
     RAISE point2;
    ELSIF flag = '3' THEN
     vn_num := 10/0;
    END IF;
COMMIT;
EXCEPTION
WHEN point1 THEN
 DBMS_OUTPUT.PUT_LINE('error1');
 ROLLBACK TO mysavepoint1;
 commit;
WHEN point2 THEN
 DBMS_OUTPUT.PUT_LINE('error2');
 ROLLBACK TO mysavepoint2;
 commit;
WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('error3');
ROLLBACK;

END;

EXEC save_test_proc('1');

select *
FROM ex17_2;