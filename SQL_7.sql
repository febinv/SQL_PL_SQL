/* 
QUESTION- 7
By submitting this assignment for grading, I state or affirm that the work submitted is my own
work and I did not receive assistance nor provide assistance from another student (or external
agent). Febin Varghese*/

with sq as (
select dm.dname,dm.dcode,sec.instructor,count(gr.student_number) cntstud,count(distinct sec.section_id) cntsec
from EB.DEPARTMENT_TO_MAJOR dm,eb.course c,eb.section sec,
eb.grade_report gr
where dm.dcode=c.offering_dept(+) and c.course_number=sec.course_num(+) and sec.section_id=gr.section_id(+)
and dcode not in ('UNKN')
group by dm.dname,dm.dcode,sec.instructor)
select dname "Dept Name",instructor "Instructor",ranking "Ranking","Rank Method"
from (select dname,instructor,case when instructor is null then null
else dense_rank() over(partition by dname order by cntstud desc) 
 end Ranking,case when instructor is not null then 'Enrolled' else null end "Rank Method"
from sq where dcode in ('ACCT','ARTS','CHEM','MGIS','POLY','ENGL') and instructor is not null
union 
select dname,instructor,
case when instructor is null
then null
else
dense_rank() over(partition by dname order by cntsec desc) end   Ranking,
case when instructor is not null then 'Sections' else null end "Rank Method"
from sq where dcode not in ('ACCT','ARTS','CHEM','MGIS','POLY','ENGL') and instructor is not null )  where ranking<=2
union 
select dname,instructor,null,null from sq where (dcode,0) in 
(select dcode,count(instructor)
from sq group by dcode having count(instructor)=0)
order by "Dept Name","Ranking";

/*
Total no of students taught and total no of sections taught are found from with clause,in which count of students and count of distinct
sections grouped by department name ,department code and instructor will give the respective counts per department,dcode,instructor combination.
for Deparments in ('ACCT','ARTS','CHEM','MGIS','POLY','ENGL') ranking is done seperately in which rank is calculated based on
no of students taught which is found with clause.
For other departments ranking is done seperately in which rank is calculated based on no of sections taught which is found from
with clause.
Department with dcode 'UNKN' is filtered out from calculations.
Also while calculating both rankings , sections and students with no instructor are filtered out.
To show only the top two instructors rank is limited to 2 using filter.
Finally to display department with no instructors count of instructors over deparment code where count(instructor)=0 will give
the deparments without any instructor and that is integrated to output using union.
Sorting is done on Department Name,Ranking in ascending order.
Rank Method is displayed using Case statement.
*/

