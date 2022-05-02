/*
     이름이 있는 블록
     이름 
     IS
      선언부
     BEGIN
      실행부
      EXCEPTION
     END;
*/
-- 국가번호를 입력 받아 국가명을 반환하는 함수
CREATE OR REPLACE FUNCTION fn_get_country(p_id NUMBER) -- REPLACE는 동일한 명칭이 있는
 RETURN VARCHAR2 -- 리턴 타입             p_id는 입력 값   경우에 덮어쓰기
IS
 vs_country_name countries.country_name%TYPE;
BEGIN
   SELECT country_name
    INTO vs_country_name
   FROM countries
   WHERE country_id = p_id;
   
   RETURN vs_country_name; -- 리턴 값
END;

SELECT fn_get_country(57777) as 국가명
FROM dual;

-- 입력값에 해당되는 국가가 없으면 
-- '해당 국가 없음' 출력

CREATE OR REPLACE FUNCTION fn_get_country(p_id NUMBER) -- REPLACE는 동일한 명칭이 있는
 RETURN VARCHAR2 -- 리턴 타입             p_id는 입력 값   경우에 덮어쓰기
IS
 vs_country_name countries.country_name%TYPE;
 vn_num  number;
BEGIN
    SELECT COUNT(country_name)
     INTO vn_num
    FROM countries
    WHERE country_id = p_id;
 IF vn_num != 0 THEN
    SELECT country_name as
     INTO vs_country_name
    FROM countries
    WHERE country_id = p_id;
 ELSE vs_country_name := '해당 국가 없음';  
 END IF;
   RETURN vs_country_name; -- 리턴 값
END;

-- 입력값이 없는 경우 생략가능
CREATE OR REPLACE FUNCTION fn_year
 RETURN VARCHAR2
IS
BEGIN
 RETURN TO_CHAR(sysdate, 'yyyy');
END;

SELECT fn_year
FROM dual;


/*  학생 이름을 입력받아 수강학점의 총합을 리턴하는 함수를 작성하시오
    해당이름의 학생이 없으면 0 or '없음'
    입력값 이름 : varchar2
    리턴값 학점 : varchar2    
*/

CREATE OR REPLACE FUNCTION fn_get_score(p_name VARCHAR2)
 RETURN VARCHAR2
IS
 vn_score VARCHAR2(30);
 vn_num number;
BEGIN
 -- 입력받은 학생이름이 존재하는지 체크
    SELECT COUNT(*)
     INTO vn_num
    FROM 학생 
    WHERE 이름 = p_name;
 IF vn_num != 0 THEN
    SELECT SUM(과목.학점)
    INTO vn_score
    FROM 학생, 수강내역, 과목
    WHERE 학생.이름  = p_name
    AND 학생.학번 = 수강내역.학번(+)
    AND 수강내역.과목번호 = 과목.과목번호(+);    
 ELSE
    vn_score := '없음';
 END IF;
 RETURN NVL(vn_score, 0);
END;

SELECT 이름
     , fn_get_score(이름)  
FROM 학생;

SELECT *
FROM 학생
WHERE 이름 = '최숙경';

SELECT SUM(과목.학점)
FROM 학생, 수강내역, 과목
WHERE 학생.이름  = '최숙경'
AND 학생.학번 = 수강내역.학번(+)
AND 수강내역.과목번호 = 과목.과목번호(+);


/*
    mem_id를 입력받아
    등급을 리턴하는 함수를 만드시오
    VIP  : 마일리지 5000이상 또는 구매수량 100 이상
    GOLD : 마일리지 3000이상 5000미만 또는 구매수량 50 이상 
    SILVER : 나머지
    
    SELECT fn_get_mem_grade('a001') <-- return VIP
    FROM member;
    1. 필요한 SQL 작성 (고객별 마일리지 ,구매수량(qty))
    2. 1. 의 데이터로 조건문 작성 
    IF ~ VIP
    ELSE IF GOLD
    ELSE SILVER
*/

CREATE OR REPLACE FUNCTION fn_get_mem_grade(p_id VARCHAR2)
 RETURN VARCHAR2
IS
 vs_grade VARCHAR2(30);
 vn_mlieage member.mem_mileage%TYPE;
 vn_qty cart.cart_qty%TYPE;
BEGIN
    SELECT MAX(a.mem_mileage)
         , SUM(b.cart_qty)
     INTO vn_mlieage, vn_qty
    FROM member a, cart b
    WHERE a.mem_id = b.cart_member(+)
    AND b.cart_member = p_id;
 IF vn_mlieage >= 5000 OR vn_qty >= 100 THEN
 vs_grade := 'Vip';
 ELSIF vn_mlieage >= 3000 OR vn_qty >= 50 THEN
 vs_grade := 'Gold';
 ELSE
 vs_grade := 'Sliver';
 END IF;
 RETURN vs_grade;
END;

-- 필요한 SQL
SELECT MAX(a.mem_mileage)
     , SUM(b.cart_qty)
FROM member a, cart b
WHERE a.mem_id = b.cart_member(+)
AND b.cart_member = 'a001';

SELECT mem_name as 이름
     , fn_get_mem_grade(mem_id) as 등급 
FROM member;

/*
    YYYYMMDD(문자) 형태의 날짜를 입력받아
    d_day를 계산하는 함수를 만드시오 (네이버 d_day기준)
    지났다면   : 기준일로부터 1721일째 되는 날입니다.
    오늘이라면 : 오늘은 기준일부터 1일째 되는 날입니다.
    남았다면   : 오늘부터 기준일까지 1141일 남았습니다.
    (입력 : 문자열, 리턴 : 문자열)
*/

CREATE OR REPLACE FUNCTION fn_d_day(f_day VARCHAR2)
 RETURN VARCHAR2
IS
 vs_date VARCHAR2(80) := TO_CHAR(sysdate, 'YYYYMMDD');
 vs_return VARCHAR2(80);
BEGIN
 IF vs_date > f_day THEN
 vs_return := ROUND(sysdate - to_date(f_day));
 DBMS_OUTPUT.PUT_LINE('오늘부터 기준일 까지 ' || vs_return || '일 남았습니다.');
 ELSIF vs_date < f_day THEN
 vs_return := CEIL(to_date(f_day) - sysdate);
 DBMS_OUTPUT.PUT_LINE('기준일로부터 ' || vs_return || '일째 되는날입니다.');
 ELSE 
 vs_return := 1;
 DBMS_OUTPUT.PUT_LINE('오늘은 기준일로부터 ' || vs_return || '일째 되는날입니다.');
 END IF;
 RETURN vs_return;
END;

SELECT fn_d_day('20170815')
     , fn_d_day('20220502')
     , fn_d_day('20221231')
FROM dual;

SELECT ROUND(sysdate - to_date('20221231'))
FROM dual;
