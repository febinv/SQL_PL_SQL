/* By submitting this assignment for grading, I state or affirm that the work submitted is my own
work and I did not receive assistance nor provide assistance from another student (or external
agent). Febin Varghese*/


--3

select titles.title_id "Title ID",titles.type "Book Type",authors.AU_ID "Author ID",
authors.AU_FNAME||' '||authors.AU_LNAME "Author Name",State "Author State" ,
to_Char(titles.total_Sales*titles.PRICE,'$9,999,999.99') as "Expected Revenue"
from pb.titles titles, pb.titleauthor ta,pb.authors authors
where titles.title_id=ta.title_id and authors.au_id=ta.au_id and ta.au_ord=1 and titles.contract=1
order by "Title ID";

/*
Total_sales*price will display the expected revenue for each book.
Books without any total sales value will have null value displayed in Expected Revenue.
First author is displayed by appying filter au_ord=1
By applying filter contract=1 all books without a contract will be filtered out from result set.
Order by sorts by default in ascending order.
/*