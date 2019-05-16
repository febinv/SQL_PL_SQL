/* By submitting this assignment for grading, I state or affirm that the work submitted is my own
work and I did not receive assistance nor provide assistance from another student (or external
agent). Febin Varghese*/

--4

select titles.title_id "Title ID",titles.title "Book Title",stores.stor_id "Store ID",
stores.stor_name "Store Name",sum(qty) "Num Book Sales",to_Char(sum(qty*price),'$999,999.99') "Expected Books Sales" 
from pb.titles titles,pb.salesdetail sd,pb.stores stores
where titles.title_id=sd.title_id and sd.stor_id=stores.stor_id and 
titles.type in ('business','psychology')
group by stores.stor_id,titles.title_id,titles.title,stores.stor_name
having sum(qty)>200
order by "Expected Books Sales" desc;

/*
In clause will filter the result set to include types in business and psychology only.
Qty will have the qty of a book sold for a particular order. Hence to find the total quantity of each book sold we need to 
find the sum of qty grouped by stor_id and title_id, which will sum up the values of qty for each combination of a store id and a title id. 
Similarly qty*price will give the gross sales value for a book for a particular order. Hence we need to sum(qty*price) group by store id and title id
to find the gross sales of a book per combination of store and title id.
Having sum(qty)>200 will filter out book and store combinations with less than 200 books sold.
Order by desc will sort in descending order. 
*/