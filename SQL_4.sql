/* 
QUESTION- 4
By submitting this assignment for grading, I state or affirm that the work submitted is my own
work and I did not receive assistance nor provide assistance from another student (or external
agent). Febin Varghese*/

select * from (select dcode "Dept Code",dname "Dept Name",sq.cnt "Courses Offered",sq1.cntstud "Num Students",sq1.cntenrl "Num enrollments",
nvl(sq2.cntnscred,0) "NS Credit Enrolled",dense_rank() over(order by sq1.cntstud desc nulls last) "Dept Rank"
from eb.department_to_major dm,
(select offering_dept,count(distinct course_number) cnt from eb.course
group by offering_Dept)sq,(select offering_Dept,count(distinct student_number) cntstud,count(student_number) cntenrl from eb.course c,eb.section sec,eb.grade_report gr
where c.course_number=sec.course_num and sec.section_id=gr.section_id
group by offering_Dept)sq1,(select offering_Dept, count(student_number) cntnscred from eb.course c,eb.section sec,eb.grade_report gr
where c.course_number=sec.course_num and sec.section_id=gr.section_id and c.credit_hours<>'3'
group by offering_Dept)sq2
where dm.dcode=sq.offering_Dept(+) and 
dm.dcode=sq1.offering_Dept(+) and dm.dcode=sq2.offering_Dept(+))
where "Dept Rank"<=5;

/*
"Courses Offered" is found from subquery sq where count of distinct course number grouped by offering dept will give the
count of courses offered for each department.
"Num Students" and "Num enrollments" is found from subquery sq1 where count of distinct student number grouped by
offering dept will give the no of students enrolled in coures for each department, similarly count of student number
grouped by offering dept will give the total number of enrollment done in each offering department.
"NS Credit Enrolled" is found from subquery sq2 where count of student number grouped by offering department done on dataset
where credit hours not equal to 3 credit units will give the count of students enrolled in non standard hour credit courses.
"Dept Rank" is calculated by ranking overing "Num Students" in descending order i.e department with maximum number of Num Students
enrolled will have rank 1 and so on. Dense rank is used to ensure if there is a tie the next department gets the next rank sequentially
and that no rank is skipped.
Only top 5 department are shown by filtering on ranks <=5.
*/

