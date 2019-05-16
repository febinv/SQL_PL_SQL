/* By submitting this assignment for grading, I state or affirm that the work submitted is my own
work and I did not receive assistance nor provide assistance from another student (or external
agent). Febin Varghese*/

with sq as (select stno,grade,sum(credit_hours) tot from (select s.stno,grade,course_num,credit_hours
from  eb.student s,eb.section sec,eb.grade_report gr,eb.course c
where sec.course_num=c.course_number(+) and gr.section_id=sec.section_id(+) and s.stno=gr.student_number(+) 
and grade is not null
group by s.stno,grade,course_num,credit_hours)
group by stno,grade)
select s1.stno "Student ID",s1."Student Name",s1."Class",round(sum(gradepoints)/sum(tot),3) "GPA" from 
(select s.stno,s.sname "Student Name",case when Class is null then 'N/A'
else to_Char(class) end "Class",grade,tot,
case when grade='A'
then tot*4
when grade='B'
then tot*3
when grade='C'
then tot*2
when grade='D'
then tot*1
when grade='F'
then tot*0
end Gradepoints from eb.student s,sq
where s.stno=sq.stno(+) )s1
group by s1.stno,s1."Student Name",s1."Class"
order by "Class","GPA" desc nulls last;

/*
To calculate the GPA,first the sum of credit units for each grade per student no is calculated in the with clause.
Which is done by summing the credit hours grouping it on student no and grade.
Next the total points "Gradepoints" per grade achieved is calculated using case statement inside subquery s1.Also, Class with value null is displayed as 'N/A' using case statement.
Finally, GPA is calculated by dividing the summed up value of "Gradepoints" calculated above along with the sum total of credit units
taken by the student(grouping by on student no,student name and class). This value is then rounded off to 3 decimal places using round
function. Finally sorting is done on class and GPA, any null GPA result is displayed at the end of the class using the "desc null last"
keyword in order by clause.Left outer joins is used to display all the students.
*/