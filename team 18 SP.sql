

go
create proc studentRegister
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@email varchar(50),
@gender bit,
@address varchar(10)
As

insert into Users 
values (@first_name,@last_name,@password,@gender,@email,@address)
declare @sid int
select @sid = max(id)
from Users
insert into Student (id) values (@sid)




go
create proc InstructorRegister
@first_name varchar(20),
@last_name varchar(20),
@password varchar(20),
@email varchar(50),
@gender bit,
@address varchar(10)
As
insert into Users 
values (@first_name,@last_name,@password,@gender,@email,@address)
declare @instID int
select @instID = max(id)
from Users
insert into Instructor (id)values(@instID)






go 
create proc userLogin
@id int ,
@password varchar(20),
@success bit output,
@type int output
as
IF (exists(select* from Users where @id = id and @password = password))
BEGIN
set @success = 1
if(exists(select* from Student where @id = id))
set @type = 2
else if (exists(select* from Admin where @id = id))
set @type = 1
else if (exists(select* from Instructor where @id = id))
set @type = 0
END

else
set @success = 0

declare @res bit 
declare @t int
exec userLogin 1 ,145,@res output, @t output
print @res
print @t



go 
create proc addMobile
@id int , @mobile_number varchar(20)
as
insert into UserMobileNumber values (@id,@mobile_number)



--admin
---1-AdminListInstr
go 
create proc AdminListInstr
as
select u.first_name,u.last_name
from Instructor i inner join Users u on i.id = u.id



---2-AdminViewInstructorProfile
go 
create proc AdminViewInstructorProfile
@instrId int
as
select u.first_name,u.last_name,u.gender,u.email,u.address,i.rate
from Users u inner join Instructor i on u.id = i.id
where u.id = @instrId




---3-AdminViewAllCourses
go 
create proc AdminViewAllCourses
as
select name,creditHours,price,content,accepted
from Course



---4- AdminViewNonAcceptedCourses
go 
create proc AdminViewNonAcceptedCourses
as
select name,creditHours,price,content
from Course 
where accepted = '0'



---5-AdminViewCourseDetails
go 
create proc AdminViewCourseDetails
@courseId int
as
select name,creditHours,price,content,accepted
from Course
where id = @courseId




--6-AdminAcceptRejectCourse
go 
create proc AdminAcceptRejectCourse
@adminId int,@courseId int
as
update Course
set accepted = '1', adminId = @adminId
where id = @courseId
 


---7- AdminCreatePromocode
go 
create proc AdminCreatePromocode
@code varchar(6),
@issueDate datetime,
@expiryDate datetime,
@discount decimal(4,2),
@adminId int
as
insert into Promocode values(@code,@issueDate,@expiryDate,@discount,@adminId)



--8-AdminListAllStudents
go
create proc AdminListAllStudents
as
select u.first_name,u.last_name
from Student s inner join Users u on s.id = u.id



--9-AdminViewStudentProfile
go 
create proc AdminViewStudentProfile
@sid int
as
select u.first_name,u.last_name,u.gender,u.email,u.address,s.gpa
from Users u inner join Student s on u.id = s.id
where u.id = @sid



--10-AdminIssuePromocodeToStudent
go
create proc AdminIssuePromocodeToStudent
@sid int ,@pid varchar(6)
as
insert into StudentHasPromocode values(@sid,@pid)



--- nb4
--a)
Go 
Create Proc InstAddCourse
@creditHours int,
@name varchar(10), 
@price DECIMAL(6,2),   
@instructorId int
AS
Insert Into Course(creditHours, name, price, instructorid) Values(@creditHours, @name, @price, @instructorId)

declare @cid int
select @cid = max(id)
from Course 
insert into InstructorTeachCourse values (@instructorId,@cid)



---b)
Go 
Create Proc UpdateCourseContent
@instrId int, 
@courseId int, 
@content varchar(20)
AS
Update Course
Set content = @content
Where id = @courseId AND instructorid = @instrId  



Go 
Create Proc UpdateCourseDescription
@instrId int, 
@courseId int, 
@courseDescription varchar(200)
AS
Update Course
Set courseDescription = @courseDescription
Where id = @courseId AND instructorid = @instrId 


---c)
Go 
Create Proc AddAnotherInstructorToCourse
@insid int, 
@cid int, 
@adderIns int
AS
if (exists(Select * from Course Where id = @cid AND instructorid = @adderIns AND accepted = '1'))
Insert Into InstructorTeachCourse Values (@insid,@cid)


---d)
Go 
Create Proc InstructorViewAcceptedCoursesByAdmin
@instrId int
AS 
select *
from Course
Where accepted = '1' AND instructorid = @instrId

---e)
Go
Create Proc DefineCoursePrerequisites
@cid int, 
@prerequsiteId int
AS
Insert Into CoursePrerequisiteCourse Values(@cid,@prerequsiteId) 

---f)
Go 
Create Proc DefineAssignmentOfCourseOfCertianType
@instId int, 
@cid int, 
@number int, 
@type varchar(10), 
@fullGrade int, 
@weight decimal(4,1), 
@deadline datetime, 
@content varchar(200)
AS
if (exists(Select * from Course Where id = @cid AND instructorid = @instId AND accepted = '1'))
Insert Into Assignment Values(@cid, @number, @type, @fullGrade, @weight, @deadline, @content)


---g
Go 
Create Proc updateInstructorRate
@insid int
AS
DECLARE @avgRate decimal(3,2)
select @avgRate = AVG(rate)
from StudentRateInstructor
Where instId = @insid
Update Instructor 
Set rate = @avgRate
Where id = @insid


---g)
Go 
Create Proc ViewInstructorProfile
@instrId int
AS
Select u.first_name,u.last_name,u.gender,u.email,u.address,i.rate,um.mobile_number
from Instructor i inner join Users u on i.id = u.id left outer join UserMobileNumber um on um.id = i.id
Where u.id = @instrid




---h)
Go 
Create Proc InstructorViewAssignmentsStudents
@instrId int, 
@cid int
AS
if (exists(Select * from Course Where id = @cid AND instructorid = @instrId))
Select *
from StudentTakeAssignment
where cid = @cid


---i)
Go 
Create Proc InstructorgradeAssignmentOfAStudent
@instrId int, 
@sid int, 
@cid int, 
@assignmentNumber int, 
@type varchar(10), 
@grade decimal(5,2)
AS
if (exists(Select * from Course Where id = @cid AND instructorid = @instrId))
begin
Update StudentTakeAssignment
Set grade = @grade
where sid = @sid AND cid = @cid AND assignmentNumber = @assignmentNumber AND assignmentType = @type
end


---j)
Go 
Create Proc ViewFeedbacksAddedByStudentsOnMyCourse
@instrId int, 
@cid int
AS
if (exists(Select * from Course Where id = @cid AND instructorid = @instrId))
begin
select *
from Feedback
Where cid = @cid
end


---k)
Go 
Create Proc calculateFinalGrade
@cid int, 
@sid int, 
@insId int
AS
if (exists(Select * from Course Where id = @cid AND instructorid = @insId))
begin
DECLARE @final_grade decimal(5,2)
select @final_grade = sum(weight*grade/final_grade)
from Assignment INNER JOIN StudentTakeAssignment ON Assignment.cid = StudentTakeAssignment.cid
where StudentTakeAssignment.sid = @sid AND Assignment.cid = @cid

update StudentTakeCourse
set grade = @final_grade
where sid = @sid and instId = @insId and cid = @cid
end



Go 
Create Proc InstructorIssueCertificateToStudent
@cid int, 
@sid int, 
@insId int, 
@issueDate datetime
AS
if (exists(Select * from StudentTakeCourse Where cid = @cid AND instId = @insId and sid = @sid and grade>=50))
begin
Insert Into StudentCertifyCourse Values(@sid, @cid, @issueDate)
delete 
from StudentTakeCourse 
where cid = @cid and sid = @sid 
ends




--nb5
--a)
go
create proc viewMyProfile
@id int
AS
select* 
from Student s
     inner join Users u ON s.id=u.id
where s.id = @id




--b)
go
create proc editMyProfile
@id int,
@firstName varchar(10),
@lastName varchar(10),
@password varchar(10),
@gender bit,
@email varchar(10),
@address varchar(10)
AS

if @firstName is not null
update Users
set first_name = @firstName
where id = @id

if @lastName is not null
update Users
set last_name= @lastName
where id = @id

if @password is not null
update Users
set password = @password
where id = @id

if @gender is not null
update Users
set gender = @gender
where id = @id

if @email is not null
update Users
set email = @email 
where id = @id

if @address is not null
update Users
set address= @address
where id = @id





--c)
go
create proc availableCourses
AS 
select name
from Course
where accepted = '1'


--d
go
create proc courseInformation
@id int
AS 
select c.*, u.first_name,u.last_name
from Course  c inner join Users u ON c.instructorid = u.id
where c.id = @id







--e)
go
create proc enrollInCourse
@sid int,
@cid int,
@instr int
AS
if(exists(select * from Course where id = @cid and accepted = '1'))
insert into StudentTakeCourse (sid, cid, instId)
values(@sid, @cid, @instr)


--f)
go
create proc addCreditCard
@sid int, 
@number varchar(15), 
@cardHolderName varchar(16),
@expiryDate datetime, 
@cvv varchar(3)
AS 
insert into CreditCard 
values (@number, @cardHolderName, @expiryDate, @cvv)
insert into StudentAddCreditCard 
values (@sid, @number)


--g)
go
create proc viewPromocode
@sid int
AS 
select p.*
from Promocode inner join StudentHasPromocode S ON p.code = S.code
where sid = @sid


--h)
go 
create proc payCourse
@cid int,
@sid int
AS 
update StudentTakeCourse
set payedfor = '1'
where cid = @cid and sid = @sid

--i)
go
create proc enrollInCourseViewContent
@id int,
@cid int
AS 
select c.id, c.creditHours, c.name, c.courseDescription, c.price, c.content
from Course c
     inner join StudentTakeCourse S on c.id = S.cid 
 where S.sid = @id and c.id = @cid

 --j)
 go
 create proc viewAssign
 @courseId int,
 @sid int
 AS
 select A.*
 from Assignment A 
      inner join StudentTakeAssignment S ON A.number = S.assignmentNumber
where A.cid = @courseId and S.cid = @courseId and S.sid = @sid


 --k)
 go
 create proc submitAssign
 @assignType VARCHAR(10), 
 @assignnumber int, 
 @sid INT, 
 @cid INT
 AS
 if(exists(select* from StudentTakeCourse where sid = @sid and cid = @cid))
 insert into StudentTakeAssignment (sid, cid, assignmentNumber, assignmentType)values (@sid, @cid, @assignnumber, @assignType)

 --l)
 go
 create proc viewAssignGrades
 @assignnumber int, 
 @assignType VARCHAR(10), 
 @cid INT, 
 @sid INT,
 @assignGrade int output
 AS 
 select @assignGrade = grade
 from StudentTakeAssignment
 where sid = @sid and cid = @cid and assignmentNumber = @assignnumber and assignmentType = @assignType

 --m)
 go
 create proc viewFinalGrade
 @cid int,
 @sid int,
 @finalgrade decimal(10,2) output
 AS
 select @finalgrade = grade
 from StudentTakeCourse
 where cid = @cid and sid = @sid 

 --n)
 go
 create proc addFeedback
 @comment VARCHAR(100), 
 @cid INT, 
 @sid INT
 AS 
 declare @number int
 select @number = number 
 from Feedback 
 where cid = @cid  
 if @number is not null
 set @number = @number +1
 else 
 set @number = 1
 insert into Feedback (cid,number, comments, sid) 
 values(@cid,@number, @comment, @sid)
 


 --o)
 go
 create proc rateInstructor
 @rate DECIMAL (2,1), 
 @sid INT, 
 @insid INT
 AS 
 insert into StudentRateInstructor values(@sid, @insid, @rate)

 --p)
go
create proc viewCertificate
 @cid INT, 
 @sid INT
 AS
 select*
 from StudentCertifyCourse
 where cid = @cid and sid = @sid