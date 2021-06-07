create database GUCera

go

Use GUCera


create table Users (
id int primary key identity,
first_name varchar(20),
last_name varchar(20) ,
password varchar(20),
gender bit,
email varchar(50),
address varchar(10))


create table UserMobileNumber (
id int,mobile_number varchar(20),
primary key(id,mobile_number),
foreign key (id) references Users on delete cascade on update cascade
)

create table Student(id int primary key ,gpa decimal(3,2),
foreign key (id) references Users on delete cascade on update cascade
)

create table Instructor(id int primary key ,rate decimal(2,1),
foreign key (id) references Users on delete cascade on update cascade
)

create table Admin(id int primary key ,
foreign key (id) references Users on delete cascade on update cascade
)

create table Course (id int primary key identity ,
creditHours int ,
name varchar(10),
courseDescription varchar(20),
price decimal(6,2),
content varchar(20),
adminid int references Admin, 
instructorid int references Instructor,
accepted bit default '0' 
)



create table Assignment (cid int , number int, type varchar(10),
primary key (cid,number,type),
fullGrade int,
weight decimal(4,1),
deadline datetime,
content varchar (200),
foreign key (cid) references Course on delete cascade on update cascade)

create table Feedback(cid int , number int ,
primary key (cid,number),
comments varchar(100),
numberOfLikes int,
sid int references Student on delete cascade on update cascade,
foreign key (cid) references Course on delete cascade on update cascade)

create table Promocode(code varchar(6) primary key,
issueDate datetime ,
expiryDate datetime,
discount decimal(4,2),
adminId int references Admin on delete cascade on update cascade)

create table StudentHasPromocode(
sid int references Student,
code varchar(6) references Promocode on delete cascade on update cascade,
primary key (sid,code))

create table CreditCard(number varchar(15) PRIMARY KEY,
cardHolderName varchar(16),
expiryDate datetime,
cvv varchar(3)
);

create table StudentAddCreditCard(sid int references Student on delete cascade on update cascade,
creditCardNumber varchar(15) references CreditCard on delete cascade on update cascade,
PRIMARY KEY(sid, creditCardNumber)
);

create table StudentTakeCourse(sid int references Student on delete cascade on update cascade, 
cid int references Course on delete cascade on update cascade,
instId int references Instructor,
PRIMARY KEY(sid, cid, instId),
payedfor bit ,
grade decimal(5,2)
);

create table StudentTakeAssignment(sid int references Student ,
cid int  ,
assignmentNumber int ,
assignmentType varchar(10) ,
foreign key(cid,assignmentNumber,assignmentType) references Assignment on delete cascade on update cascade,
grade decimal(5,2),
PRIMARY KEY(sid,cid,assignmentNumber,assignmentType)
);


Create Table StudentRateInstructor(
    sid int,
    instId int,
    rate decimal(3,2),
    Primary key(sid,instId),
    Foreign Key(sid) references Student,
    Foreign Key(instId) references Instructor
)

Create Table StudentCertifyCourse(
    sid int,
    cid int,
    issueDate datetime,
    Primary Key(sid,cid),
    Foreign Key(sid) references Student,
    Foreign Key(cid) references Course ON DELETE CASCADE ON UPDATE CASCADE
)

Create Table CoursePrerequisiteCourse(
    cid int,
    prerequisiteId int,
    Primary Key(cid,prerequisiteId),
    Foreign Key(cid) references Course ON DELETE CASCADE ON UPDATE CASCADE,
    Foreign Key(prerequisiteId) references Course
)

Create Table InstructorTeachCourse(
    instId int,
    cid int,
    Primary Key(instId,cid),
    Foreign Key(instId) references Instructor,
    Foreign Key(cid) references Course ON DELETE CASCADE ON UPDATE CASCADE
)

