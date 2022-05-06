-- 집합 연산자 UNION ------------------------------------------------------------------------
--UNION 합집합, UNION ALL 중복허용, INTERSECT 교집합, MINUS 차집합


CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));

INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('한국', 5, 'LCD');
INSERT INTO exp_goods_asia VALUES ('한국', 6, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('한국', 7, '휴대전화');
INSERT INTO exp_goods_asia VALUES ('한국', 8, '환식탄화수소');
INSERT INTO exp_goods_asia VALUES ('한국', 9, '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES ('한국', 10,'철 또는 비합금강');

INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');

COMMIT;

SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
 ORDER BY seq;

SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'
 ORDER BY seq;
 

UNION 합집합(중복제거)  UNION ALL 전체합  MINUS 차집합  INTERSECT 교집합

SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
UNION 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본';

SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
UNION ALL
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본';
     
------------------------------------- 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
INTERSECT
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'; 
------------------------------------- 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
MINUS
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본';  

SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'   
MINUS
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국';   
------------------------------------- 
- 컬럼의 수와 타입이 맞아야함. 
SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
UNION 
SELECT seq, goods
  FROM exp_goods_asia
 WHERE country = '일본'; 
 
 
SELECT seq, goods
  FROM exp_goods_asia
 WHERE country = '한국'
INTERSECT  -- 교집합 
SELECT seq, goods
  FROM exp_goods_asia
 WHERE country = '일본';  


 -----------정렬은 마지막에만 가능 
 SELECT goods
  FROM exp_goods_asia
 WHERE country = '한국'
UNION
SELECT goods
  FROM exp_goods_asia
 WHERE country = '일본'
  ORDER BY goods;  