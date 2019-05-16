/* By submitting this assignment for grading, I state or affirm that the work submitted is my own
work and I did not receive assistance nor provide assistance from another student (or external
agent). Febin Varghese*/


select  stno "Student ID",sname "Student Name",major "Major",course_name "Subject",sq.attempt "Attempts",sq2.cntsec "Num Sections"
from eb.student s,eb.grade_report gr,eb.section sec,eb.course c,(select student_number,course_num,count(*) attempt from eb.grade_Report gr,eb.section s
where gr.section_id=s.section_id group by student_number,course_num)sq,(select course_num,count(distinct section_id) cntsec from eb.section
group by course_num)sq2
where s.stno=gr.student_number and gr.section_id=sec.section_id and c.course_number=sec.course_num and sq.student_number=s.stno
and sq.course_num=sec.course_num and sq2.course_num=sec.course_num and
extract(year from bdate)<=1985
group by stno,sname,major,course_name,sq.attempt,sq2.cntsec
order by "Student ID","Subject";

/*
a)extract(year from date)<=1985 will filter students born after 1985.
c)Attempts taken by student for each course is found from the subquery sq where count(*)
grouped by student_number,course_num will give the no of attempts taken for that course number by the student.
d)Similarly no. of sections offered is also found from another subquery sq2 where the count of distinct section_id grouped by course_num will give the total no of sections offered for that course.
e)Sorting is done by studentID,coursename in ascending order
*/