--------------------------------------------------------
--  Constraints for Table QUOTES
--------------------------------------------------------

  ALTER TABLE "JSP"."QUOTES" MODIFY ("IMG2" NOT NULL ENABLE);
  ALTER TABLE "JSP"."QUOTES" MODIFY ("IMG1" NOT NULL ENABLE);
  ALTER TABLE "JSP"."QUOTES" ADD PRIMARY KEY ("SEQ")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "MYTS"  ENABLE;
