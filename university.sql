create database university;
use university;

create table courses
(
id int,
c_name varchar(20),
c_duration int(20),
fees int,
professor varchar(20),
seats int
);

create table department
(
  id int,
  c_name varchar(20),
  d_name varchar(10),
  staf int,
  hod varchar(4)
  );
  
create table staf
  (
    id int,
    s_name varchar(10),
    num int,
    s_courses varchar(10),
    hod int
    );

create table studants
(
  id int,
  f_name varchar(10),
  l_name varchar(10),
  address varchar(50),
  age int
  );
  
  create table class
  (
   id int,
   c_name varchar(10)
   );
   
 create table hod
 (
  department varchar(10),
  id int,
  salary int,
  address varchar(200)
  );
  
  
  
  


