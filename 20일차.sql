/* 정규식
1-1 :  .(dot)은 모든 문자와 match
      [] <-- 문자 1글자를 의미
      ^ : 시작을 의미함 $ : 끝을 의미함
      [^] : 부정을 의미함
*/

SELECT mem_name, mem_hometel
FROM member
WHERE REGEXP_LIKE(mem_hometel, '^..-\');

SELECT mem_name, mem_hometel
FROM member
WHERE REGEXP_LIKE(mem_hometel, '^[0-9][0-9]-');
/*
    {m} : 정확히 m회 매치
    {m, } : 최소한 m회 매치
    {m, n} : 최소 m회 최대 n회 매치 
    ? : 0 or 1회 매치 
    + : 1 ~ 1회 이상 매치
    * : 0번 이상 매치 
*/
-- 8이 3번 출현하는 전화번호
SELECT mem_name, mem_hometel
FROM member
WHERE REGEXP_LIKE(mem_hometel, '[8]{3}');

-- 이메일 주소중 영문자 3번 이하 출현 후 
-- @ 있는 이메일 주소를 출력하시오
-- ex abc@gmail.com, ab@gmail.com ....
-- [a-z] : 소문자 1자리, [A-Z]: 대문자 1자리
SELECT mem_name, mem_mail
FROM member
WHERE REGEXP_LIKE(mem_mail, '^[a-zA-Z]{1,3}@');

-- 숫자가 포함되지 않은 비밀번호를 검색하시오 
SELECT mem_name, mem_pass
FROM member
WHERE REGEXP_LIKE(mem_pass, '^[^][0-9]+$');


SELECT *
FROM employees
WHERE REGEXP_LIKE(phone_number, '....\.');

