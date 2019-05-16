Question -4

/*By submitting this assignment for grading, I state or affirm that the work submitted is my own work and I did not in any way receive assistance nor provide assistance from another student (or external agent). I am aware and accept the consequences of unauthorized collaboration including a failing grade for both the homework and the course.

Febin Varghese*/


create or replace PROCEDURE update_inventory ( v_numdays number,v_sdc number,v_per float,v_venrev vendors.vendorid%type )
AS
CURSOR C1 IS SELECT distinct inventoryreport.itemid itemid FROM rawmaterials,inventoryreport  where rawmaterials.vendorid=v_venrev
and rawmaterials.itemid=inventoryreport.itemid and reportdate>=to_Date((sysdate - v_numdays),'DD-MM-YY')  
and reportdate<to_Date(sysdate,'DD-MM-YY');
v_rmid rawmaterials.itemid%type;
v_rmname rawmaterials.itemname%type;
counter number;
v_count number;
v_Sameday inventoryreport.ordersameday%type;
v_ordernextday inventoryreport.ordersameday%type;
v_orderlowline number;
v_orderhighline number;
v_avgtotorders float;
v_totalorders inventoryreport.ordersameday%type;
v_Desiredinvlevel rawmaterials.inventorylevel%type;

BEGIN
if not (v_numdays >=1 and v_numdays <=60)  then
raise_application_error (-20100,'Incorrect parameter value for numdays, value should be between 1 and 60');
elsif not (v_sdc >=1 and v_sdc<= v_numdays) then 
raise_application_error (-20101,'Incorrect parameter value for sdc, value should be between 1 and '||v_numdays);
end if;

for temp_rec in C1 loop
select count(*) into counter from inventoryreport where itemid=temp_rec.itemid
and reportdate>=to_Date((sysdate - v_numdays),'DD-MM-YY')  
and reportdate<to_Date(sysdate,'DD-MM-YY')
group by itemid
having count(*)>=v_sdc;

select count(*) into v_count from inventoryreport where itemid=temp_rec.itemid
and reportdate>=to_Date((sysdate - v_numdays),'DD-MM-YY')  
and reportdate<to_Date(sysdate,'DD-MM-YY')
and ordersameday>0;

if (counter !=0) then

select sum(ordersameday) into v_Sameday from inventoryreport where reportdate>=to_Date((sysdate - v_numdays),'DD-MM-YY')  
and reportdate<to_Date(sysdate,'DD-MM-YY')
and itemid=temp_rec.itemid;

select sum(ordernextday) into v_ordernextday from inventoryreport where reportdate>=to_Date((sysdate - v_numdays),'DD-MM-YY')  
and reportdate<to_Date(sysdate,'DD-MM-YY')
and itemid=temp_rec.itemid;

v_totalorders:=v_Sameday+v_ordernextday;

select (v_totalorders/v_numdays) into v_avgtotorders from dual;

select round((1-v_per)*v_avgtotorders) into v_orderlowline from dual;
select round((1+v_per)*v_avgtotorders) into v_orderhighline from dual;

end if;

select inventorylevel,itemname into v_Desiredinvlevel,v_rmname from rawmaterials where itemid=temp_rec.itemid;


if(v_count>v_Sdc) and (v_orderlowline>v_Desiredinvlevel) then

update rawmaterials set inventorylevel=v_orderlowline where itemid=temp_rec.itemid;
dbms_output.put_line(v_rmname ||' Inventory Increased from '||v_Desiredinvlevel ||' to '||v_orderlowline);

elsif (v_orderhighline<v_Desiredinvlevel) then
update rawmaterials set inventorylevel=v_orderhighline where itemid=temp_rec.itemid;
dbms_output.put_line(v_rmname ||' Inventory Decreased from '||v_Desiredinvlevel ||' to '||v_orderhighline);
else
dbms_output.put_line(v_rmname ||' no change');
end if;
end loop;
END update_inventory;
/