/* By submitting this assignment for grading, I state or affirm that the work submitted is my own
work and I did not receive assistance nor provide assistance from another student (or external
agent). Febin Varghese*/

--1
select TITLE_ID "Title ID",PUBDATE "Published Date",PUB_ID "Publisher ID",TYPE "Book Type",PRICE "Unit Price" from pb.titles
where extract(year from pubdate)>=2010 and PRICE>=30 and total_Sales is not null
order by "Unit Price";

/*
Extract function will extract the year from each pubdate value. 
This is then compared to 2010 and only those books which have values >= 2010 will be displayed ,
rest all will be filtered out.  
Similarly rows where price >=30 and with a non-null total_Sales value will only be displayed rest all will be filtered out.
Order by sorts by default in ascending order
/*