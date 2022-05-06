-- PL/SQL 에서 결과값을 보기 위해서 처음에 아래 구문을 실행해주어야함 
SET SERVEROUTPUT ON;
-- [보기 - DBMS 출력] 에서도 확인 가능함

-- 기본 단위를 블록이라고 하며
-- 블록은 : 이름부, 선언부, 실행부, 예외처리부로 구성
-- 이름부는 블록의 명칭이 오는데 없을 경우 익명으로(DECLARE)
DECLARE
 vi_num number := 10; -- 변수 
 vn_pi CONSTANT number := 3.14; -- 상수 
BEGIN
 vi_num := 100; -- 값 변경 가능 
-- vn_pi := 4; --값 변경 불가능
 DBMS_OUTPUT.PUT_LINE(vi_num);
END;

DECLARE
 vs_emp_name varchar2(80); 
 vs_dep_name varchar2(80);
BEGIN
 SELECT a.emp_name, b.department_name
 INTO vs_emp_name, vs_dep_name -- INTO 조회 결과를 변수에 저장
 FROM employees a 
    , departments b
 WHERE a.department_id = b.department_id
 AND a.employee_id = 100;
 DBMS_OUTPUT.PUT_LINE(vs_emp_name ||':' || vs_dep_name);
END;

DECLARE
 vs_emp_name employee.emp_name%TYPE; 
 vs_dep_name department.department_name%TYPE;
BEGIN
 SELECT a.emp_name, b.department_name
 INTO vs_emp_name, vs_dep_name -- INTO 조회 결과를 변수에 저장
 FROM employees a 
    , departments b
 WHERE a.department_id = b.department_id
 AND a.employee_id = 100;
 DBMS_OUTPUT.PUT_LINE(vs_emp_name ||':' || vs_dep_name);
END;

select *
from 학생;

-- 이름을 입력 받아 학번을 출력하는 익명블록 작성
DECLARE
 vs_nm 학생.이름%TYPE := :nm;
 vn_hakno 학생.학번%TYPE;
BEGIN
 /* 입력받은 이름으로 학생테이블에서 학번 조회 SQL */
 select 이름, 학번
 into vs_nm, vn_hakno
 from 학생
 where 이름 like vs_nm; 
 DBMS_OUTPUT.PUT_LINE(vs_nm || ':' || vn_hakno);
END;

BEGIN -- 선언부가 필요없으면 BEGIN END 가능
 DBMS_OUTPUT.PUT_LINE(2 * 2); 
END;

/* IF */
DECLARE
 vn_num number := 10;
 vn_user_num number := :su;
BEGIN
 IF vn_num > vn_user_num THEN
    DBMS_OUTPUT.PUT_LINE('10보다 작음');
 ELSIF vn_user_num = vn_num THEN
    DBMS_OUTPUT.PUT_LINE('10임');
 ELSE
    DBMS_OUTPUT.PUT_LINE('10보다 큼');
 END IF;
END;

/* 신입생이 들어왔습니다.
   학번을 생성하여 등록해주세요 
   
   가장 마지막 학번 앞자리(4)년도가 올해와 같다면 '마지막학번 + 1' 
                                       다르다면 올해 + 000001
                                       번으로 생성
*/

DECLARE
 vn_year varchar(4) := TO_CHAR(sysdate, 'yyyy');
 vn_max_no 학생.학번%TYPE;
 vn_hakno 학생.학번%TYPE; 
BEGIN
 /*학번 생성 */
 --(1) 마지막 학번 조회
 --(2) 번호 앞자리와 올해를 비교하여 학번생성
 select MAX(학번)
 into vn_max_no
 from 학생;
   
     IF substr(vn_max_no, 1, 4) = vn_year THEN
        vn_hakno := vn_max_no+1;
     ELSE vn_hakno := (vn_year || LPAD(1, 6, '0'));
     END IF;
     
 INSERT INTO 학생(학번, 이름, 전공, 생년월일)
 VALUES(vn_hakno, :이름, :전공, TO_DATE(:생년월일));
 COMMIT;
END;

-- 단순 LOOP 문
DECLARE
 vn_base number := 3;
 vn_cnt number := 1;
BEGIN
 LOOP
    DBMS_OUTPUT.PUT_LINE(vn_base || '*' || vn_cnt
                                 || '=' || vn_base*vn_cnt);
    vn_cnt := vn_cnt + 1;
    EXIT WHEN vn_cnt > 9; -- 루프 종료
 END LOOP;
END;

DECLARE
 vn_base number := 2;
 vn_cnt number := 1;
BEGIN
 LOOP  DBMS_OUTPUT.PUT_LINE('=== ' || vn_base || '단 ===');
     LOOP
        DBMS_OUTPUT.PUT_LINE(vn_base || '*' || vn_cnt
                                     || '=' || vn_base*vn_cnt);
        vn_cnt := vn_cnt + 1;
        EXIT WHEN vn_cnt > 9; -- 루프 종료
     END LOOP;
     vn_cnt := 1;
     vn_base := vn_base + 1;
     EXIT WHEN vn_base > 9;
 END LOOP;    
END;

DECLARE
 vn_base number := 3;
 vn_cnt number := 1;
BEGIN
 WHILE vn_cnt <= 9
 LOOP
    DBMS_OUTPUT.PUT_LINE(vn_base || '*' || vn_cnt
                                 || '=' || vn_base*vn_cnt);
    EXIT WHEN 5 = vn_cnt; -- 탈출도 가능
    vn_cnt := vn_cnt + 1;
 END LOOP;
END;

DECLARE
 i number := 3;
BEGIN
 FOR j IN 1..9  -- 초기값..종료 (IN REVERSE = 거꾸로 수행)
                -- 초기값에서 1씩 증가하여 j에 할당 
 LOOP
 DBMS_OUTPUT.PUT_LINE(i||'*'||j||'='||i*j);
 END LOOP;
END;

-- 2단부터 9단까지 FOR문 이용하여 출력
DECLARE
BEGIN
 FOR i IN 2..9
 LOOP
 DBMS_OUTPUT.PUT_LINE('=== ' || i || '단 ===');
     FOR j IN 1..9  -- 초기값..종료 (IN REVERSE = 거꾸로 수행)
                    -- 초기값에서 1씩 증가하여 j에 할당 
     LOOP
     DBMS_OUTPUT.PUT_LINE(i||'*'||j||'='||i*j);
     END LOOP;
 END LOOP;
END;

-- 숫자를 입력받아 
-- 입력받은 수 만큼 *을 프린트하는 익명블록을 작성하시오
-- ex) 5
--    *****
DECLARE
 vn_user_num number := :su;
 vs_result long := '';
BEGIN
 FOR i IN 1..vn_user_num
 LOOP
    vs_result := vs_result || '*';
 END LOOP;
 DBMS_OUTPUT.PUT_LINE(vn_user_num || ' : 입력 ' || vs_result);
END;

