/* By submitting this assignment for grading, I state or affirm that the work submitted is my own
work and I did not receive assistance nor provide assistance from another student (or external
agent). Febin Varghese*/
--5

select pub.PUB_ID "Publisher ID",pub.Pub_Name "Publisher Name",State "Publisher State",
count(distinct titles.title_id) "Number of Different Books sold",to_Char(sum(qty*titles.price*(1-(discount/100))),'$9,999,999.99')
as "Book Sales Revenue"
from pb.publishers pub,pb.titles titles,pb.salesdetail sd,pb.sales
where pub.pub_id=titles.pub_id 
and sales.stor_id=sd.stor_id and sales.ord_num=sd.ord_num and sd.title_id=titles.title_id 
and pub.pub_id in (select pub_id from pb.sales sales,pb.salesdetail sd,
pb.titles titles where 
sales.stor_id=sd.stor_id and sales.ord_num=sd.ord_num and sd.title_id=titles.title_id and
extract(year from sdate)=2006 and extract(month from sdate)=10) 
group by pub.PUB_ID,Pub_Name,State
having count(distinct titles.title_id)<=5
order by state,pub.Pub_id;

/*
to find the number  of different books sold for each publisher we need to group by publisher id 
and count the number of distint books(identified by title_id) . By using having clause along with the count (distinct title_id)
we can filter out pulbishers who has publisher more than 5 books.
If we directly filter for the for publishers having at least one book ordered in 2006 october , this will make our count calculated
above incorrect, since the count will work on the filtered out dataset. Hence we need to use a subquery which will give us pub_id
having a book ordered in 2006 october and then filter on pub_id using IN clause.
To find the net book sales revenue for a publisher we need to sum up salesrevenue for all book published by publisher.
This can be done by summing by grouping by on pub_id and summing up qty*price.Also, 
we will multiply this with the discount percentage to find the net book sales revenue considering discounts.
To char is used to format to the required format.
*/