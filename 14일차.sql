/*  분석함수

    분석함수(매개변수) OVER (PARTITION BY expr1, expr2....
                           ORDER BY expr3, expr4...
                           WINDOW 절...
                           )
    PARTITION BY : 계산 대상 그룹지정
    ORDER BY : 대상 그룹에 대한 정렬
    WINDOW : 파티션으로 분할된 그룹에 대해 더 상세한 그룹을 분할
*/

SELECT department_id, emp_name
     , ROW_NUMBER() OVER (PARTITION BY department_id
                          ORDER BY emp_name) as dep_row
     , ROUND(AVG(salary) OVER (PARTITION BY department_id)) as dep_avg
     , ROUND(AVG(salary) OVER()) as all_avg
FROM employees;
-- 모든 학생의 이름, 전공, 전공별 평점평균, 전체 평균평점을 출력하시오  
SELECT AVG(평점) OVER() -- 전체를 대상으로 평점을 출력함 (AVG(평점)은 한 행에만 출력함)
FROM 학생;

SELECT 이름, 전공
     , ROUND(AVG(평점) OVER(PARTITION BY 전공), 2) as 전공평균평점
     , ROUND(AVG(평점) OVER(),2) as 전체평균평점
FROM 학생;     

SELECT *
FROM 학생;

-- RANK() 동일 값 순위 건너뜀 DENSE_RANK() 건너뛰지 않음(공동 1위로 처리후 다음은 3위)
SELECT department_id
     , emp_name
     , RANK() OVER(PARTITION BY department_id
                   ORDER BY salary DESC) as rank_dep
     , DENSE_RANK() OVER(PARTITION BY department_id              
                        ORDER BY salary DESC) as dense_rank_dep
     , DENSE_RANK() OVER(ORDER BY salary DESC) as all_dense_rank_dep                   
FROM employees
WHERE department_id IN(30, 60);

-- 부서별로 월급을 가장 많이 받는 직원 1명씩 출력하시오
-- (부서없는 직원은 제외)

SELECT *
FROM employees;

SELECT *
FROM   (SELECT emp_name
             , department_id
             , salary
             , RANK() OVER(PARTITION BY department_id
                           ORDER BY salary DESC) as rank_dep
        FROM employees
        WHERE department_id is not null)
WHERE rank_dep = 1;

-- 부서별 월급 비용이 많이 드는 순위를 출력하시오
-- 가장 많은 부서가 1등

SELECT a.*
     , RANK() OVER(PARTITION BY department_id
                   ORDER BY dep_sum) as rank
FROM 
(SELECT department_id 
      , SUM(salary) as dep_sum       
    FROM employees
    GROUP BY department_id) a;

SELECT department_id
     , SUM(salary) as dep_sum
     , RANK() OVER(ORDER BY SUM(salary) DESC) as dep_rank
FROM employees
GROUP BY department_id;

-- cart, prod 활용하여 물품별 판매금액의 순위를 출력하세요
-- dense_rank 사용 
SELECT *
FROM cart;

SELECT *
FROM prod;

SELECT t1.*
     , DENSE_RANK() OVER(ORDER BY prod_sum DESC) as rank
FROM (SELECT a.prod_id
            , a.prod_name
            , sum(a.prod_sale * b.cart_qty) as prod_sum
        FROM prod a, cart b
        WHERE a.prod_id = b.cart_prod
        GROUP BY a.prod_name, a.prod_id
        ORDER BY 3 desc) t1;
        
        
/*  LAG 선행로우 값 반환
    LEAD 후행로우 값 반환
*/        
SELECT emp_name
     , department_id
     , salary
                  -- 1단계 앞 로우의 emp_name 
                  -- (emp_name을, N단계 앞(뒤) 출력, 없으면' '출력)
     , LAG(emp_name, 1, '가장높음') OVER(PARTITION BY department_id
                                        ORDER BY salary desc) as ap_emp
                   -- 1단계 뒤 로우의 emp_name                        
     , LEAD(emp_name, 1, '가장낮음') OVER(PARTITION BY department_id
                                        ORDER BY salary desc) as back_emp                                    
FROM employees
WHERE department_id IN(30, 60);

-- 각 학생들의 평점이 1단계 높은 학생과의 평점 차이를 출력하시오
-- 이름과의 평점 차이를 출력하시오 가장 높은 학생은 이름:'1등' 차이: 0

SELECT t1.*
     , LAG(t1.평점, 1, t1.평점) OVER(ORDER BY t1.평점 desc)-t1.평점 as 차이    
FROM    (SELECT 이름
                , ROUND(평점,1) as 평점
                , LAG(이름, 1, '1등') OVER(ORDER BY 평점 desc) as 나보다높은      
        FROM 학생) t1;

-- 실무에선 이런 식으로 사용하기도 함        
SELECT COUNT(*) OVER() as 전체건수
     , a.*
FROM employees a;
        
        
        