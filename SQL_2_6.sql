/* By submitting this assignment for grading, I state or affirm that the work submitted is my own
work and I did not receive assistance nor provide assistance from another student (or external
agent). Febin Varghese*/

--6

select stores.stor_id "Store ID",stores.stor_name "Store Name",count(distinct sales.ord_num) "Number of Orders",
count(distinct sd.title_id) "Number of Different Books sold",sq1.totq "Number of Books sold",
sum(round((sd.qty*price)*(1-(discount/100)),-3)/1000)||'K' "Revenue (thousands)",sq2.sumq "Number of Books sold 2008"
from pb.stores stores,pb.sales sales,pb.salesdetail sd,(select stor_id,sum(qty) as totq from pb.salesdetail sd
group by stor_id) sq1,pb.titles titles,(select sd.stor_id,sum(sd.qty)  as sumq from pb.salesdetail sd,pb.sales sales
where sd.stor_id=sales.stor_id and sd.ord_num=sales.ord_num and extract(year from sdate)=2008
group by sd.stor_id)sq2
where stores.stor_id=sales.stor_id and sd.stor_id=stores.stor_id and sq1.stor_id=stores.stor_id
and sd.title_id=titles.title_id and sd.stor_id=sales.stor_id and sd.ord_num=sales.ord_num 
and stores.payterms='Net 60' and stores.stor_id=sq2.stor_id(+)
group by stores.stor_id,stores.stor_name,sq1.totq,sq2.sumq
having count(distinct sales.ord_num)<=(select trunc(avg(no)) from (select stor_id,count(distinct ord_num) as no from pb.salesdetail
group by stor_id)) and nvl(sq2.sumq,0)>0;

/*
a)To find the number of orders placed by a store we need to count the number of distinct order numbers grouped by stor_id.
b)To find the number of different books sold to store, we need to count the number of distinct books(identified by title_id)
grouped by stor_id.
c)To find the total quantity of books sold to each store we need to sum up all the qty of books sold grouped by stor_id.
To find the netbook sales revenue for the stores, we need to sum up all the revenue for each book sold to the store.
e)This is done by summing up qty*price*(1-discount/100) grouped over stor_id. Round(column,-3) will round of the column value
to 3 places to the left of decimal point. Dividing by 1000 and concatenating with K to have the required format.
f)To filter out stores whos number of orders are less than or equal to avg number of orders for all stores, we will first count the
distinct orders grouped by stor id and then apply average function on it. Trunc function is used to remove the decimal part if exists.
This avg value is then compared with distinct order numbers for each store ids and the stores with  orders greater than the avg number 
of orders for all the stores will be filtered out.
g) To display the quantity of books sold to each of the store during 2008, this is calculated seperately using a subquery wherein
store ids and their corresponding quantity of books sold in 2008 is found out. We are using subquery since implementing in main queries
will make the previous count values calculated incorrect(since count would now work on books sold in 2008 only).
Also, the above result is joined to the main query using left outer join , since there are some stores which do not have any books
sold in 2008 and if we use equi join, those stores will be filtered out from the result set which is incorrect.
h) Since we used left outer join above there is a store which has null value for number of books sold in 2008. We are filtering this 
out since we require positive values only by converting null to 0 using nvl and then applying filter >0.
*/