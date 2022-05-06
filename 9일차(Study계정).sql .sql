select *
from java.emp_dept; -- java. <- 스키마라고함

SELECT *
FROM java.tb_hak;
INSERT INTO java.tb_hak VALUES(202100001, '펭수');

SELECT *
FROM java.syn_channel;

select *
from hak; -- hak테이블은 PUBLIC 시노님이기 때문에 스키마 없이 조회 가능