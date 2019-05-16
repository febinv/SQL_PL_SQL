Question -3 

/*By submitting this assignment for grading, I state or affirm that the work submitted is my own work and I did not in any way receive assistance nor provide assistance from another student (or external agent). I am aware and accept the consequences of unauthorized collaboration including a failing grade for both the homework and the course.

Febin Varghese*/


create or replace TRIGGER TRG_INVENTORYREPORT
  AFTER INSERT or update
  ON SALESORDERDETAIL
  FOR EACH ROW
  DECLARE
  v_begininvlevel inventoryreport.beginninginventorylevel%type;   
  v_endinginvlevel inventoryreport.endinginventorylevel%type;   
  v_desiredinvlevel RAWMATERIALS.INVENTORYLEVEL%type;   
  v_reportdate salesorders.duedate%type;
  v_rmid FINISHEDGOODS.rmid%type;
  v_rawmatneeded FINISHEDGOODS.rmquantity%type;
  counter number;
  counter_1 number;
  v_ordersameday inventoryreport.ordersameday%type;
  v_ordernextday inventoryreport.ordernextday%type;
BEGIN
select duedate into v_reportdate from salesorders where sono=:new.sono ;
select rmid into v_rmid from FINISHEDGOODS where itemid=:new.itemid;
select count(*) into counter from inventoryreport where itemid=v_rmid;

IF counter=0 then
select inventorylevel into v_begininvlevel from rawmaterials where itemid=v_rmid;
else 
select ENDINGINVENTORYLEVEL into v_begininvlevel from 
(select ENDINGINVENTORYLEVEL from inventoryreport where reportdate<v_reportdate and itemid=v_rmid
order by reportdate desc) where rownum=1;
end if;

select rmquantity*:new.soquantity into v_rawmatneeded from FINISHEDGOODS where itemid=:new.itemid;

select inventorylevel into v_desiredinvlevel from rawmaterials where itemid=v_rmid;
if v_rawmatneeded <= v_begininvlevel then
v_ordersameday:=0;
v_ordernextday:=v_desiredinvlevel-(v_begininvlevel+v_ordersameday-v_rawmatneeded);
v_endinginvlevel:=v_begininvlevel+v_ordersameday+v_ordernextday-v_rawmatneeded;
else
v_ordersameday:=v_rawmatneeded-v_begininvlevel;
v_ordernextday:=v_desiredinvlevel;
v_endinginvlevel:=v_begininvlevel+v_ordersameday+v_ordernextday-v_rawmatneeded;
end if;

select count(*) into counter_1 from inventoryreport where itemid=v_rmid and reportdate=v_reportdate;


if counter_1=0 then 
insert into inventoryreport values(v_rmid,v_reportdate,v_begininvlevel,v_rawmatneeded,v_ordernextday,v_ordersameday,v_endinginvlevel);
else
update inventoryreport set consumptionquantity=v_rawmatneeded,endinginventorylevel=v_endinginvlevel,ordersameday=v_ordersameday,
ordernextday=v_ordernextday
where itemid=v_rmid and reportdate=v_reportdate ;
end if;

END TRG_INVENTORYREPORT;
/