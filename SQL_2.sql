/* By submitting this assignment for grading, I state or affirm that the work submitted is my own
work and I did not receive assistance nor provide assistance from another student (or external
agent). Febin Varghese*/

select sec.section_id "Section ID",course_num "Course Number",semester||' '||to_char(to_Date(year,'RR'),'YYYY') "Academic Year"
,capacity "Capacity",sq2.tot "Total No. of Students Enrolled",
case when capacity<sq2.tot then 'Room Change Required'
 when capacity>sq2.tot then 'Within Capacity'
 else 'Error' end "Room Analysis"
from eb.section sec,(select course_number,count(distinct prereq) from eb.prereq
group by course_number
having count(distinct prereq)>1)sq,eb.room r,(select s.section_id,count(distinct student_number) as tot from eb.section s,eb.grade_report gr
where s.section_id=gr.section_id
group by s.section_id)sq2
where sec.course_num=sq.course_number and sec.bldg=r.bldg and sec.room=r.room and sq2.section_id=sec.section_id
order by "Course Number","Section ID";


/*
b)Academic year is found out by concatenating semester with year which is formatted using to char and to_date ('RR') function which will automatically 
convert for eg. 00 to 2000 and 98 to 1998
c)Courses which has more than one prereq is found in subquery sq where count(distinc prereq) 
group by course_number will give the no of prereq for each course
and using having clause count(distinct prereq)>1 will filter out all courses which has less than  2 prereq.
d)tot no of students enrolled for the section is calculated from subquery sq2 where count(distinct student_number)
grouped by section id will give the no of students enrolled for each section.
e)Room analysis is performed using the case statement wherein for each section room capacity is compared with total no of students
enrolled in the section(found from stepd) and if students is more than capacity case assigns the string 'Room Change Required'
else it assigns 'Within Capacity'
f)sorting is done by course number,section id in ascending order.

*/