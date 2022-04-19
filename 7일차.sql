SELECT *
FROM 학생;

SELECT *
FROM 수강내역;


--외부조인(OUTER JOIN) 어느 한쪽 테이블의 컬럼에 값이 없어도(NULL)이라도 출력 
SELECT *
FROM  학생
    , 수강내역
WHERE 학생.학번 = 수강내역.학번(+) -- 수강내역.학번에 대해 외부조인 (값이 없는쪽에 해야함) 
AND 학생.이름 = '윤지미';

SELECT 학생.학번
     , 학생.이름
     , COUNT(수강내역.수강내역번호) as 수강건수
FROM 학생
   , 수강내역
WHERE 학생.학번 = 수강내역.학번(+)
GROUP BY 학생.학번
       , 학생.이름; 
       
SELECT 학생.이름
     , 수강내역.강의실
     , 과목.과목이름
FROM  학생
    , 수강내역
    , 과목
WHERE 학생.학번 = 수강내역.학번(+)
AND   수강내역.과목번호 = 과목.과목번호(+);

-- 모든 교수의 강의내역을 출력하시오

SELECT *
FROM 교수;

SELECT *
FROM 강의내역;

SELECT 교수.교수이름
     , 교수.전공
     , 강의내역.강의내역번호
     , 강의내역.과목번호
     , 강의내역.강의실 
FROM 교수
   , 강의내역
WHERE 교수.교수번호 = 강의내역.교수번호(+);

SELECT 교수.교수이름
     , 교수.전공
     , COUNT(강의내역.강의내역번호) as 강의수 -- NULL값을 제외  
     , COUNT(*) as 전체 -- 행에 대한 컬럼 값을 출력(NULL 포함) / 부정확
FROM 교수
   , 강의내역
WHERE 교수.교수번호 = 강의내역.교수번호(+)
GROUP BY 교수.교수이름
       , 교수.전공;
       
-- 학생들의 '수강건수'와 '수강학점합계'를 출력하시오      
--                     * 과목에 학점이 있음 

SELECT *
FROM 학생;

SELECT *
FROM 수강내역;

SELECT *
FROM 과목;

SELECT 학생.학번
     , 학생.이름
     , COUNT(수강내역.수강내역번호) as 수강건수 
     , DECODE(SUM(과목.학점), null, 0, SUM(과목.학점)) as 수강학점합계
     , CASE WHEN SUM(과목.학점) is not null THEN SUM(과목.학점)
          ELSE 0 
          END as 합 
     , NVL(SUM(과목.학점),0) as 수강학점합계
FROM 학생
   , 수강내역
   , 과목
WHERE 학생.학번 = 수강내역.학번
AND   수강내역.과목번호 = 과목.과목번호(+)
GROUP BY 학생.이름, 학생.학번
ORDER BY 3 desc;

/*  서브쿼리 (sub query)
    SQL문장 안에 보조로 사용되는 또 다른 SELECT문
    
    1. 메인 쿼리와 연관성에 따라
     (1) 연관성 없는 서브쿼리
     (2) 연관성 있는 서브쿼리

    2. 형태(위치)에 따라
     (1) 일반 서브쿼리(SELECT 절) '스칼라 서브쿼리'라고도 함.
     (2) 인라인 뷰(FROM 절)
     (3) 중첩쿼리(WHERE 절)
*/

SELECT emp_name
     , department_name
FROM employees     a
    ,departments   b
WHERE a.department_id = b.department_id;
--(1) 일반 서브쿼리(SELECT 절) '스칼라 서브쿼리'라고도 함.
-- 규칙. 1:1로만 맵핑 
-- 가벼운 테이블에만 사용 (성능의 문제 때문)
SELECT a.emp_name
     , a.department_id
     , (select department_name
        from departments
        where department_id = a.department_id) as nm
     , a.job_id
     , (select job_title
        from jobs
        where job_id = a.job_id) as job_nm
FROM employees a;

-- 학생, 수강내역 
select *
from 과목;
select *
from 수강내역;
SELECT 학생.이름
     , 수강내역.과목번호
     , (select 과목이름
        from 과목
        where 과목.과목번호 = 수강내역.과목번호 ) as 과목명
FROM 학생, 수강내역 
WHERE 학생.학번 = 수강내역.학번(+);

-- (2) 인라인 뷰(FROM 절)
-- SELECT 출력결과를 테이블처럼 사용
SELECT *    
FROM (SELECT rownum as rnum
         , a.*
      FROM 학생 a
      ) t1 -- 하나의 테이블로 사용(길기때문에 보통 as설정을 함) 
      
WHERE t1.rnum BETWEEN 1 and 10;

-- 평점이 높은 5명의 학생만 출력시오
-- 1. 평점이 높은 학생부터 출력되도록 정렬
SELECT 이름, 평점
FROM 학생
ORDER BY 평점 desc;
-- 2. 정렬된 결과에 rownum 생성하여 인라인 뷰를 만듬
SELECT *
FROM (SELECT 이름, 평점
      FROM 학생
      ORDER BY 평점 desc) a;
-- 3. (2.)의 결과에서 2~5등까지만 나도록 조건
SELECT *
FROM (SELECT rownum as rnum
            , a.*
        FROM (SELECT 이름, 평점
              FROM 학생
              ORDER BY 평점 desc) a
    ) -- 감싼 이유 rownum은 임시로 존재하는 문이지만 ()을 통해 rnum을 픽스함
WHERE rnum BETWEEN 2 AND 5; -- 픽스했기 때문에 검색가능

-- (3) 중첩쿼리(WHERE 절)
-- 전체 직원의 평균월급 이상 받는 직원만 출력하시오
SELECT emp_name, salary
FROM employees
WHERE salary >= (SELECT AVG(salary)
                 FROM employees);
                 
--수강내역이 있는 학생만 학생정보를 조회하시오
SELECT *
FROM 학생
WHERE 학번 IN (SELECT distinct 학번 -- 중복제거
              FROM 수강내역);
--수강내역이 없는 학생만 학생정보를 조회하시오
SELECT *
FROM 학생
WHERE 학번 NOT IN (SELECT distinct 학번 -- 포함되지 않는
                  FROM 수강내역);
                  
                  
-- 평균평점 이상인 학생만 조회하시오 
SELECT 이름
     , 전공
     , 평점
FROM 학생
WHERE 평점 > (SELECT AVG(평점)
             FROM 학생)
ORDER BY 3 desc;

-- member, cart
-- 고객의 cart사용 이력의 최대, 최소 건수를 출력
SELECT min(cart사용수) 카트사용최소
     , max(cart사용수) 카트사용최대
FROM (SELECT a.mem_id
             , a.mem_name
             , count(b.cart_no) as cart사용수
        FROM member a, cart  b
        WHERE a.mem_id = b.cart_member(+)
        GROUP BY a.mem_id, a.mem_name
        ORDER BY 3 asc
     );
     
/*  member, cart, prod
    테이블을 사용하여  mem_id = cart_member
    고객별 카트 사용횟수, 구매상품 품목 수,
    전체 상품구매 수, 총 구매 금액을 출력하시오
    (구매이력이 없으면 0건, 정렬조건 카트사용 내림)
*/
-- mem_id = cart_member
-- prod_id = cart_prod
SELECT *
FROM member;
SELECT *
FROM cart;
SELECT *
FROM prod;

SELECT m.mem_name                           이름
     , count(DISTINCT c.cart_no)            카트사용횟수
     , count(DISTINCT p.prod_id)            구매상품_품목_수
     , NVL(sum(c.cart_qty), 0)              전체상품_구매_수 
     , NVL(sum(c.cart_qty * prod_sale), 0)  총구매금액
FROM member m, cart c, prod p
WHERE m.mem_id = c.cart_member(+)
AND c.cart_prod = p.prod_id(+)
GROUP BY m.mem_name
ORDER BY 2 desc;
