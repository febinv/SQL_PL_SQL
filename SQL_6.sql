/* 
QUESTION- 6
By submitting this assignment for grading, I state or affirm that the work submitted is my own
work and I did not receive assistance nor provide assistance from another student (or external
agent). Febin Varghese*/

select dname "Dept Name",course_number "Course Num",
course_name "Course Name",A,B,C,D,F,cntenrl "TotalEnroll" 
from (select dm.dname,c.COURSE_NUMBER,c.course_name,sq.cntenrl,sq1.grade from eb.course c,
(select course_num,count(distinct student_number) cntenrl from eb.course c,eb.section sec,eb.grade_report gr where
c.course_number=sec.course_num(+) and sec.section_id=gr.section_id
group by course_num)sq,(select course_num,grade from eb.course c,eb.section sec,eb.grade_report gr where
c.course_number=sec.course_num(+) and sec.section_id=gr.section_id and grade is not null)sq1,EB.DEPARTMENT_TO_MAJOR dm
where c.course_number=sq.course_num(+) and c.COURSE_NUMBER=sq1.course_num and c.offering_Dept=dm.dcode(+))
pivot
(count (grade) for grade in ('A' A,'B' B,'C' C,'D' D,'F' F))
where not (D>C or F>C) 
order by "Dept Name",
a desc,b desc,c desc,d desc,f desc,"Course Num";

/*
TotalEnroll is calculated from subquery sq wherein count of distinct student numbers grouped by course number will give the 
totalnoofstudents enrolled for each courses.
Filtering out grades which are null from calculation in subquery sq1.
Pivoting is done on for each Grades received for a course, and count of each grade received is calculated in respective columns.
Filter is done to exclude courses which no of D's or no of F's exceed the no of C's.
Sorting is done for based on Department Name Asc, no of A's received descending,B's received descending...F's received descending
and finally on Course Num ascending.
*/

/*Assumption
Calculating TotalEnroll on distinct number of students.
*/