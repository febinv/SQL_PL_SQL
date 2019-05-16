Question- 1

/*By submitting this assignment for grading, I state or affirm that the work submitted is my own work and I did not in any way receive assistance nor provide assistance from another student (or external agent). I am aware and accept the consequences of unauthorized collaboration including a failing grade for both the homework and the course.

Febin Varghese*/

CREATE SEQUENCE vendor_seq
  MINVALUE 1000000
  MAXVALUE 9999999
  START WITH 1000001
  INCREMENT BY 1
  nocache
  nocycle;

  CREATE SEQUENCE po_seq
  MINVALUE 1000
  MAXVALUE 9999
  START WITH 1001
  INCREMENT BY 1
  cycle
  nocache;

  
CREATE OR REPLACE TRIGGER TRG_VENDOR
  BEFORE INSERT 
  ON VENDORS
  FOR EACH ROW
BEGIN
select 'V'||vendor_Seq.nextval into :new.vendorid from dual;
END;
/
-- Assuming that No update to be performed on primary key


  CREATE OR REPLACE TRIGGER TRG_PURCHASEORDERS
  BEFORE INSERT
  ON PURCHASEORDERS
  FOR EACH ROW
BEGIN
select 'PO'||to_char(sysdate,'MM')||to_char(sysdate,'DD')||to_char(sysdate,'YY')||po_seq.nextval into :new.pono from dual;
END;
/
-- Assuming that No update to be performed on primary key







