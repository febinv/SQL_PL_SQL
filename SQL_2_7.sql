/* By submitting this assignment for grading, I state or affirm that the work submitted is my own
work and I did not receive assistance nor provide assistance from another student (or external
agent). Febin Varghese*/

--7

--d)

select au_id,"Author Name","Num Books",to_char(sumt,'$999,999.99') "Best Sales",title_id "The most Popular Book"
from (select m.*,rank() over(partition by au_id order by sumt desc) rnk from
(select authors.au_id,au_fname||' '||au_lname "Author Name" ,tot "Num Books",sq2.sumt,title_id
from pb.authors authors,(select ta.au_id,count(distinct titles.title_id) tot from pb.titles titles,pb.titleauthor ta,pb.authors a
where titles.title_id=ta.title_id and a.au_id=ta.au_id and a.country='USA'
group by ta.au_id having count(distinct type)>=2) sq,(select ta.au_id,titles.title_id,sum((sd.qty*price)*(1-(discount/100))) sumt
from pb.titles titles,pb.salesdetail sd,pb.titleauthor ta
where sd.title_id=titles.title_id and ta.title_id=titles.title_id
group by ta.au_id,titles.title_id) sq2
where authors.au_id=sq.au_id and sq2.au_id=authors.au_id)m)
where rnk=1;
 
/*
a)To find authors in usa with atleast 2 different types of book published we can achieve this by finding the count of different 
types of books per each author id and filter out using having clause. Also country=‘USA’ filter is applied
b)to find the number of books in total the author has published we need to count the distinct number of books 
per author(grouped by au_id)
c&d) We can find the sales revenue for each book by multiplying price with quantity(discount also applied) 
and summing up this value for each combination of au_id and title_id(done using group by). Now we will have the sales revenue 
per book for a author. We are now using rank function to generate rank=1 for the book with greatest revenue for each other.
By applying filter rank=1 in outer select, we will now have only books with greatest revenue per author.
*/
--e)

select au_id,"Author Name","Num Books",to_char(sumt,'$999,999.99') "Best Sales",
listagg(title_id,',') within group(order by title_id) "The most Popular Book"
from (select m.*,rank() over(partition by au_id order by sumt desc) rnk from
(select authors.au_id,au_fname||' '||au_lname "Author Name" ,tot "Num Books",sq2.sumt,title_id
from pb.authors authors,(select ta.au_id,count(distinct titles.title_id) tot from pb.titles titles,pb.titleauthor ta,pb.authors a
where titles.title_id=ta.title_id and a.au_id=ta.au_id and a.country='USA'
group by ta.au_id having count(distinct titles.title_id)>=2) sq,(select ta.au_id,titles.title_id,sum((sd.qty*price)*(1-(discount/100))) sumt
from pb.titles titles,pb.salesdetail sd,pb.titleauthor ta
where sd.title_id=titles.title_id and ta.title_id=titles.title_id
group by ta.au_id,titles.title_id) sq2
where authors.au_id=sq.au_id and sq2.au_id=authors.au_id)m)
where rnk=1
group by au_id,"Author Name","Num Books",sumt;

/*
e)Similar query as d, listagg function is used to display two or more most popular books, 
listagg will build a comma seperated list of all title_id with similar revenues per author id .
Also, Having filter is implemented for "At least two books" which is done using counting distinct titles.
Instead of "At least 2 different types of books" implemented in d.
*/