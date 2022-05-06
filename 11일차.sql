SELECT DBMS_RANDOM.VALUE() * 10 as 난수1
     , DBMS_RANDOM.VALUE(0, 10) as 난수2
     -- 0 ~ 10 자연수 랜덤생성
     , ROUND(DBMS_RANDOM.VALUE() * 10) as 난수3
     , ROUND(DBMS_RANDOM.VALUE(0, 10)) as 난수4
FROM dual;

CREATE TABLE ex12_1 AS
(SELECT rownum as seq
    , TO_CHAR(sysdate, 'yyyy') || LPAD(ceil(rownum/1000), 2, '0') as months
    , ROUND(DBMS_RANDOM.VALUE(100, 1000)) as amt
FROM DUAL
CONNECT BY level < 12000);

SELECT *
FROM ex12_1;

SELECT *
FROM TB_INFO;

-- TB_INFO 에서 DBMS_RANDOM.VALUE 활용하여
-- SSAM을 제외하고 랜덤으로 학생 1명만 뽑은 SQL을 작성하시오
SELECT *
FROM TB_INFO
WHERE INFO_NO = ROUND(DBMS_RANDOM.VALUE(1, 22))
AND PC_NO != 'SSAM';

/* 가장 매출이 높은 지점의 BEST TOP3 메뉴이름과 가격을 출력하시오
   (1) 가장 매출이 높은 지점명 SQL
   (2) 지점의 메뉴 매출순위 3개 출력 SQL
   (3) (1)의 지점명으로 (2)를 조회하여 출력
   study의 item, reservation, order_info 활용
*/
--1번
SELECT 지점
FROM 
(SELECT b.branch 지점 
     , sum(a.sales) 매출
FROM order_info a , reservation b
WHERE a.reserv_no = b.reserv_no
AND b.cancel = 'N'
GROUP BY b.branch
ORDER BY 2 desc) t1
WHERE ROWNUM = 1;


--2번
SELECT 음식명
     , 총매출
FROM
(SELECT c.product_desc  음식명 
     , SUM(a.sales)     총매출 
     , c.price          음식가격 
FROM order_info a, reservation b, item c
WHERE a.reserv_no = b.reserv_no
AND a.item_id = c.item_id
AND b.branch = (SELECT 지점
                FROM 
                (SELECT b.branch 지점 
                     , sum(a.sales) 매출
                FROM order_info a , reservation b
                WHERE a.reserv_no = b.reserv_no
                AND b.cancel = 'N'
                GROUP BY b.branch
                ORDER BY 2 desc)
WHERE ROWNUM = 1)
GROUP BY c.product_desc, c.price
ORDER BY 2 desc)
WHERE ROWNUM BETWEEN 1 AND 3;

--3번
SELECT rownum 순위
     , t1.음식명
     , t1.음식가격
FROM 
        (SELECT c.product_desc  음식명 
             , SUM(a.sales)     매출가격 
             , c.price          음식가격 
        FROM order_info a, reservation b, item c
        WHERE a.reserv_no = b.reserv_no
        AND a.item_id = c.item_id
        AND b.branch = (SELECT 지점
                        FROM  (SELECT b.branch 지점 
                                     , sum(a.sales) 매출
                                FROM order_info a , reservation b
                                WHERE a.reserv_no = b.reserv_no
                                AND b.cancel = 'N'
                                GROUP BY b.branch
                                ORDER BY 2 desc)
                        WHERE ROWNUM = 1)
        GROUP BY c.product_desc, c.price
        ORDER BY 2 desc) t1
WHERE ROWNUM BETWEEN 1 AND 3;