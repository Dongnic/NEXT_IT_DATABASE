SELECT * FROM quotes order by 1 desc;
SELECT count(*) FROM quotes;
SELECT writer, COUNT(writer) 
FROM quotes 
GROUP BY writer
HAVING COUNT(*) <= 10 and COUNT(*) > 5; 
SELECT DISTINCT writer
    FROM quotes;
SELECT DISTINCT mem_name FROM member;

ALTER TABLE quotes ADD img2 VARCHAR(4000) DEFAULT 'https://www.google.com/search' NOT NULL;
ALTER TABLE quotes MODIFY img VARCHAR(5000);
ALTER TABLE quotes RENAME COLUMN img TO img1;

SELECT img1, writer FROM quotes where img2 not like ' %' and img1 not like 'data%' order by 1 desc;


drop SEQUENCE seq_quotes;
CREATE SEQUENCE seq_quotes START WITH 12104;

SELECT * FROM quotes where writer like '%체스터필드%';

SELECT DISTINCT count(img1) FROM quotes where img1 like '%upload.wikimedia.org%';
SELECT DISTINCT count(img2) FROM quotes where img2 not like ' %';
SELECT writer, img1 FROM quotes where LENGTH(img2) > 1 and img1 like 'data%';

SELECT writer, LENGTH(writer) FROM quotes order by 2 desc;                                        

commit;

SELECT img1 FROM quotes where img1 not like 'www.google.com/search?q' order by 1 desc;

UPDATE quotes
set img1 = 'https://www.google.com/search?q='
where writer like '체스터필드';

UPDATE
/*+ bypass_ujvc */
(   SELECT a.writer
          ,TRIM(SUBSTR(a.writer, 0, INSTR(writer, '(')-1)) as upwriter 
    FROM quotes a
    WHERE writer like '%dsadasdas)%'
)
SET writer = upwriter  ;

UPDATE
/*+ bypass_ujvc */
(   SELECT img, writer
    FROM quotes a
    WHERE writer = '빌sadas헬름 뮐러'
)
SET img = 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/4QFeRXhpZgAASUkqAAgAAAABAA4BAgA8AQAAGgAAAAAAAABjaXJjYSAxODI1OiAgV2lsaGVsbSBNdWxsZXIgKDE3OTQtMTgyNykuIEdlcm1hbiBwb2V0LCB0b29rIHBhcnQgaW4gUHJ1c3NpYW4gdXByaXNpbmcgYWdhaW5zdCBOYXBvbGVvbiwgMTgxMywgdGVhY2hlciBhbmQgZHVjYWwgbGlicmFyaWFuIGluIERlc3NhdSwgMTgxOSwgYXV0aG9yIG9mIGx5cmljIHBvZW1zIGluY2x1ZGluZyBjeWNsZXMgJ0RpZSBzY2hvbmUgTXVsbGVyaW4nIGFuZCAnV2ludGVycmVpc2UnLCBib3RoIHNldCB0byBtdXNpYyBieSBGcmFueiBTY2h1YmVydCwgMTgyNC4gIChQaG90byBieSBIdWx0b24gQXJjaGl2ZS9HZXR0eSBJbWFnZXMp/+0BglBob3Rvc2hvcCAzLjAAOEJJTQQEAAAAAAFlHAJQAA5IdWx0b24gQXJjaGl2ZRwCeAE8Y2lyY2EgMTgyNTogIFdpbGhlbG0gTXVsbGVyICgxNzk0LTE4MjcpLiBHZXJtYW4gcG9ldCwgdG9vayBwYXJ0IGluIFBydXNzaWFuIHVwcmlzaW5nIGFnYWluc3QgTmFwb2xlb24sIDE4MTMsIHRlYWNoZXIgYW5kIGR1Y2FsIGxpYnJhcmlhbiBpbiBEZXNzYXUsIDE4MTksIGF1dGhvciBvZiBseXJpYyBwb2VtcyBpbmNsdWRpbmcgY3ljbGVzICdEaWUgc2Nob25lIE11bGxlcmluJyBhbmQgJ1dpbnRlcnJlaXNlJywgYm90aCBzZXQgdG8gbXVzaWMgYnkgRnJhbnogU2NodWJlcnQsIDE4MjQuICAoUGhvdG8gYnkgSHVsdG9uIEFyY2hpdmUvR2V0dHkgSW1hZ2VzKRwCbgAMR2V0dHkgSW1hZ2VzAP/hBkdodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+Cjx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iPgoJPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KCQk8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczpwaG90b3Nob3A9Imh0dHA6Ly9ucy5hZG9iZS5jb20vcGhvdG9zaG9wLzEuMC8iIHhtbG5zOklwdGM0eG1wQ29yZT0iaHR0cDovL2lwdGMub3JnL3N0ZC9JcHRjNHhtcENvcmUvMS4wL3htbG5zLyIgICB4bWxuczpHZXR0eUltYWdlc0dJRlQ9Imh0dHA6Ly94bXAuZ2V0dHlpbWFnZXMuY29tL2dpZnQvMS4wLyIgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIiB4bWxuczpwbHVzPSJodHRwOi8vbnMudXNlcGx1cy5vcmcvbGRmL3htcC8xLjAvIiAgeG1sbnM6aXB0Y0V4dD0iaHR0cDovL2lwdGMub3JnL3N0ZC9JcHRjNHhtcEV4dC8yMDA4LTAyLTI5LyIgeG1sbnM6eG1wUmlnaHRzPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvcmlnaHRzLyIgcGhvdG9zaG9wOkNyZWRpdD0iR2V0dHkgSW1hZ2VzIiBHZXR0eUltYWdlc0dJRlQ6QXNzZXRJRD0iMzIzOTYwMSIgeG1wUmlnaHRzOldlYlN0YXRlbWVudD0iaHR0cHM6Ly93d3cuZ2V0dHlpbWFnZXMuY29tL2V1bGE/dXRtX21lZGl1bT1vcmdhbmljJmFtcDt1dG1fc291cmNlPWdvb2dsZSZhbXA7dXRtX2NhbXBhaWduPWlwdGN1cmwiID4KPGRjOmNyZWF0b3I+PHJkZjpTZXE+PHJkZjpsaT5IdWx0b24gQXJjaGl2ZTwvcmRmOmxpPjwvcmRmOlNlcT48L2RjOmNyZWF0b3I+PGRjOmRlc2NyaXB0aW9uPjxyZGY6QWx0PjxyZGY6bGkgeG1sOmxhbmc9IngtZGVmYXVsdCI+Y2lyY2EgMTgyNTogIFdpbGhlbG0gTXVsbGVyICgxNzk0LTE4MjcpLiBHZXJtYW4gcG9ldCwgdG9vayBwYXJ0IGluIFBydXNzaWFuIHVwcmlzaW5nIGFnYWluc3QgTmFwb2xlb24sIDE4MTMs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';

UPDATE quotes
SET img2 = ' ';

UPDATE quotes
set writer = 
    (select writer from quotes where writer like '%탈레브%' GROUP BY writer HAVING COUNT(*) = 
        (select MAX(count(writer)) from quotes where writer like '%탈레브%' GROUP BY writer))
where writer like '%탈레브%';

SELECT TRIM(SUBSTR(writer, 0, INSTR(writer, '(')-1))
FROM quotes
WHERE writer like '%(%)%';

SELECT writer, LENGTH(writer) FROM quotes order by 2 desc;   

DELETE FROM quotes a
WHERE LENGTH(writer) = 29;

commit;

select writer, count(writer) from quotes where writer like '%니체%' GROUP BY writer HAVING COUNT(*) = 
        (select MAX(count(writer)) from quotes where writer like '%니체%' GROUP BY writer);

select MAX(count(writer)) from quotes where writer like '%로슈푸코%' GROUP BY writer;
DELETE FROM quotes a
      WHERE ROWID < (SELECT MAX(ROWID) 
                       FROM quotes b
                        WHERE a.text = b.text);
                        
SELECT *
FROM
    (SELECT rownum as rnum, a.*
     FROM 
            (SELECT
                    seq
                  , writer
                  , text
                  , substr(text, 0, 15) as title
             FROM
                   quotes 
             ORDER by seq desc) a
     ) b
WHERE b.rnum BETWEEN 1 AND 20;   

commit;

ALTER TABLE quotes ADD PRIMARY KEY (seq);
CREATE SEQUENCE seq_recommend;
DROP SEQUENCE   seq_recommend;
DROP TABLE recommend;
CREATE TABLE recommend(
  rec_no number PRIMARY KEY,
  board_no number, 
  rec_id varchar2(100), 
  CONSTRAINT delete_with_board FOREIGN KEY(board_no) REFERENCES quotes(seq) ON DELETE CASCADE,
  CONSTRAINT delete_with_member FOREIGN KEY(rec_id) REFERENCES member(mem_id) ON DELETE CASCADE,
  rec_date date DEFAULT sysdate
);
select * from recommend;

select quotes.* from recommend , quotes where rec_id like 'a004' and recommend.board_no = quotes.seq;

select DISTINCT writer
from quotes;


SELECT *
FROM
    (SELECT rownum as rnum, a.*
     FROM 
            (SELECT
                    seq
                  , writer
                  , text
                  , substr(text, 0, 15) as title
             FROM
                   quotes x, recommend y
             WHERE x.seq = y.board_no
             AND y.rec_id = #{}
             ORDER by y.rec_date desc) a
     ) b
WHERE b.rnum BETWEEN 1 AND 20;   


SELECT
    count(*)
FROM quotes
WHERE length(text) < 50;

