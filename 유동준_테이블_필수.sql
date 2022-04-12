CREATE TABLE ORDERS (
     ORDER_ID number(12,0)
    ,ORDER_DATE date
    ,ORDER_MODE varchar2(8)
    ,CUSTOMER_ID number(6,0)
    ,ORDER_STATUS number(2,0)
    ,ORDER_TOTAL number(8,2) default 0
    ,SALES_REP_ID number(6,0)
    ,PROMOTION_ID number(6,0)
    ,constraint PK_ORDER primary key (ORDER_ID)
    ,constraint CK_ORDER_MODE check(ORDER_MODE in ('direct', 'online'))
    
);
CREATE TABLE ORDER_ITEMS (
     ORDER_ID     number(12,0)
    ,LINE_ITEM_ID number(3,0)
    ,PRODUCT_ID   number(3,0)
    ,UNIT_PRICE   number(8,2) default 0
    ,QUANTITY     number(8,0) default 0
    ,CRATE_DT    date default sysdate
    ,constraint PK_ORDER_ITEMS primary key (ORDER_ID, LINE_ITEM_ID)
  
);