/*
member  : 고객
cart    : 장바구니
prod    : 상품
buyer   : 거래처
buyprod : 거래상품
lprod   : 상품카테고리
*/

--member(고객) 고객 중 대전에 거주하고 직업이 회사원인 고객을 출력 

SELECT MEM_NAME     /*고객명*/
     , MEM_ADD1     /*고객주소*/
     , MEM_JOB      /*고객직업*/
     , MEM_MAIL     /*고객이메일*/
FROM MEMBER
WHERE MEM_ADD1 like '%대전%' 
AND MEM_JOB = '회사원'; 

/* 함수 (function)
    오라클 데이터 베이스에서 함수는 특정 연산처리 결과를
    '단일 값'으로 반환하는 객체
    내장함수와 사용자 정의함수가 있음
*/
-- '숫자 함수'
-- ABS 매개변수로 숫자를 받아 절대값 반환
SELECT ABS(-10)
     , ABS(-10.123)
     , ABS(10)
FROM dual ; --dual <-- 임시테이블 개념(테스트용)

-- ROUND(n, i)
-- 매개변수 n을 소수점 (i + 1)번째에서 반올림한 결과를 반환
-- i 디폴트는 0
-- i 가 음수이면 소수점 왼쪽에서 반올림 
SELECT ROUND(10.154)
     , ROUND(10.526,  1)
     , ROUND(16.123, -1)
FROM dual;

--employees 직원의 일당을 계산하여 출력하시오 (한달 30일 기준)
--                                     소수점 둘째자리 반올림
SELECT EMP_NAME
     , SALARY
     , round(SALARY / 30, 2) as 일당
FROM employees;

-- MOD(m, n) m을 n으로 나눈 나머지를 반환
SELECT MOD(4, 2)
     , MOD(5, 2)
     , 15
FROM dual;

SELECT *
FROM TB_INFO;

-- INFO_NO 가 짝수면 짝수를 홀수면 홀수를 출력하시오

SELECT INFO_NO 
     , CASE WHEN MOD(INFO_NO, 2) = 0 THEN '짝수'
--            WHEN MOD(INFO_NO, 2) = 1 THEN '홀수'
            ELSE '홀수'
        END as 홀짝
     , NM
FROM TB_INFO;    

-- 문자 함수
-- 문자 함수는 연산 대상이 문자이며 반환 값은 함수에 따라
-- 문자 또는 숫자를 반환함.

-- INITCAP : 첫글자 대문자, LOWER : 모두 소문자, UPPER : 모두 대문자
SELECT INITCAP('pangsu')
     , LOWER('PangSu')
     , UPPER('pangsu')
FROM dual;

SELECT LOWER(emp_name)
     , UPPER(emp_name)
     , emp_name
FROM employees
WHERE LOWER(emp_name) like LOWER('%donald%'); -- LOWER함수로 비교대상을 소문자로 변경 후 비교  

-- SUBSTR(char, pos, len)문자열 char에서
-- pos번째부터 len만큼 문자열을 자른뒤에 반환
-- len 미 입력 시 pos번째부터 나머지 모든 문자 반환
SELECT substr('ABCD EFG', 1, 4)
     , substr('ABCD EFG', 2, 4)
     , substr('ABCD EFG', 2)
     , substr('ABCD EFG', -4, 2) as test-- pos 마이너스면 뒤에서부터 자름
FROM dual;

SELECT mem_regno1
     , mem_regno2
     , mem_name
FROM member;
-- member 테이블의 고객 정보를
-- 이름 : 김은대 주민번호 : 750115-1****** 
-- 형태로 출력하시오

SELECT '이름:' || mem_name || ' 주민번호:' || mem_regno1 || '-' || substr(mem_regno2, 1, 1) || '******' as 정보
FROM member;

-- LPAD, RPAD L : 왼쪽 R : 오른쪽에 지정한 문자로 채움
-- LPAD(값, 자릿 수, 지정문자)
SELECT LPAD(123, 5, '0')
     , LPAD(1  , 5, '0')
     , LPAD(11234, 5, '0')
     , RPAD(123 , 5, '0')
     , RPAD(1   , 5, '0')
     , RPAD(11234 , 5, '0')
FROM dual;     

SELECT LPAD(INFO_NO, 10, '*'), nm
FROM TB_INFO;

-- LTRIM, RTRIM, TRIM 공백제거
SELECT LTRIM(' 안녕하세요 ')
     , RTRIM(' 안녕하세요 ')
     ,  TRIM(' 안녕하세요 ')
FROM dual;

-- REPLACE(char, i, j)
-- 대상문자열 char에서 i를 찾아서 j로 치환
-- TRANSLATE 동일하지만 한 글자씩 변환 
SELECT REPLACE('나는 너를 모르는데 너는 나를 알겠는가?','나는','너를') -- '나는'을 '너를'로
     , TRANSLATE('나는 너를 모르는데 너는 나를 알겠는가?','나는','너를')--'나'를 '너' '는'을 '를'로
FROM dual;

--LENGTH 문자열 길이
--LENGTHB 문자열 byte수
SELECT LENGTH('홍길동')
     , LENGTHB('홍길동') --한글 한 자리 수에 3byte 
     , LENGTHB('abc') --영어 한 자리 수에 1byte 
FROM dual;

-- INSTR(char, check, pos, i)
-- char의 pos 위치에서부터 i번째 위치하는 check 문자열의 인덱스(자리 수) 값 반환 
SELECT INSTR('abc abc abc ab','ab') as a -- 디폴트 값 1, 1
     , INSTR('abc abc abc ab','ab', 1) as b
     , INSTR('abc abc abc ab','ab', 1, 2) as c
     , INSTR('abc abc abc ab','ab', 4, 2) as d
FROM dual;     

-- mem_mail @의 위치를 idx에 출력하시오     
SELECT mem_name
     , mem_mail
     , INSTR(mem_mail,'@') as idx
FROM member;

-- 문제 : email 주소의 @앞 문자열을 id
--                    @뒤 문자열을 domain으로 출력하시오
-- ex name      id       domain
--    김은대  pyoedab    lycos.co.kr
SELECT mem_name
     , substr(mem_mail, 1 , INSTR(mem_mail, '@') - 1) as id 
     , substr(mem_mail, INSTR(mem_mail, '@') + 1) as domain 
     , mem_mail
FROM member;

-- 날짜함수  **
SELECT SYSDATE        as 현재날짜
     , SYSTIMESTAMP   as 현재시간_밀리세컨드
FROM dual;
-- ADD_MONTHS 월 추가
SELECT ADD_MONTHS(SYSDATE, 1)
     , ADD_MONTHS(SYSDATE, -1)
FROM dual;
-- LAST_DAY 마지막날
-- NEXT_DAY 다음 해당 요일
SELECT LAST_DAY(SYSDATE)
     , NEXT_DAY(SYSDATE, '금요일')
     , NEXT_DAY(SYSDATE, '목요일')
FROM dual;     

SELECT SYSDATE + 1
     , SYSDATE + 100
     , ROUND(SYSDATE, 'month') 
     , ROUND(SYSDATE, 'year')
FROM dual;

-- 문제 오늘부터 이번 달 마지막 날까지 D-day를 구하시오
SELECT (LAST_DAY(SYSDATE)) || '는 ' || (LAST_DAY(SYSDATE)-SYSDATE) || '일 남았습니다.' as d_day
FROM dual;
-- 남은 수강 일 수 
SELECT '수업일 수 ' || ((ADD_MONTHS(SYSDATE, 6) + 10 )- SYSDATE) || '일 남았습니다.' as d_day 
FROM dual;

-- 변환 함수 to 문자 : TO_CHAR
--          to 숫자 : TO_NUMBER
--          to 날짜 : TO_DATE
SELECT TO_CHAR(SYSDATE, 'YYYY')
     , TO_CHAR(SYSDATE, 'YYYY/MM/DD HH:MI:SS')
     , TO_CHAR(SYSDATE, 'MM')
     , TO_CHAR(SYSDATE, 'YYMMDD')
     , TO_CHAR(SYSDATE, 'YYYY-MM-DD')
     , TO_CHAR(SYSDATE, 'DAY')  -- 요일 
     , TO_CHAR(SYSDATE, 'D')  -- 요일을 1~7 형태로 
     , TO_CHAR(123456789, '999,999,999') -- 원
     , TO_CHAR(123, 'RN') -- 로마자 
FROM dual;

SELECT TO_CHAR(123, 'RN') -- 로마자 
FROM dual;

SELECT TO_DATE('22020201') -- 디폴트 형태 
     , TO_DATE('2002 02 14', 'YYYY MM DD') --형태가 다르면 맞춰줘야 함 
     , TO_DATE('2002_02_14', 'YYYY_MM_DD')
     , TO_DATE('2002', 'YYYY')
     , TO_DATE('200202', 'YYYYMM')

FROM dual;

SELECT TO_DATE('22020201')
FROM dual;

-- 현재 일자를 기준으로 사원테이블(employees)의 입사일자를 참조해서
-- 근속년수가 15년 이상인 사원을 출력하시오 
SELECT EMP_NAME
     , HIRE_DATE 
     , TO_CHAR(SYSDATE, 'YYYY') - TO_CHAR(HIRE_DATE, 'YYYY') as 근속년수
FROM employees
WHERE TO_CHAR(SYSDATE, 'YYYYMMDD') - TO_CHAR(HIRE_DATE, 'YYYYMMDD') >= 230000
ORDER by HIRE_DATE;