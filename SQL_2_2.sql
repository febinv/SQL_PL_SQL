/* By submitting this assignment for grading, I state or affirm that the work submitted is my own
work and I did not receive assistance nor provide assistance from another student (or external
agent). Febin Varghese*/

--2

select titles.TITLE_ID "Title ID",titles.TITLE "Title",titles.PUB_ID "Publisher ID",pub.PUB_Name "Publisher Name",
pub.City "Publisher City",titles.Total_Sales "Sales"
from pb.titles titles,pb.publishers pub
where titles.pub_id=pub.PUB_ID and titles.total_Sales <=5000 and titles.total_Sales>=2000 and pub.city like 'B%'
order by "Publisher Name";

/* pub.city like 'B%' is used to filter cities whose first letter doesnt start from "B" . 
total_sales <=5000 and total_sales>=2000  will filter out rows where sales doesnt fall under these ranges.
Order by sorts rows by default in ascending order.
/*