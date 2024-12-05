create database ins;
use ins;

create table users(
user_id int primary key auto_increment,
username varchar(100) unique key,
dob date,
full_name varchar(100) not null,
pwd varchar(100) not null,
email varchar(50) not null,
gender enum("male","female","prefer not to say"),
joined_at timestamp default current_timestamp);

select * from users;

insert into users 
(username, full_name, pwd, email, dob)
value
("a1", "jenil", "jenil@1","jeni@gmail.com", "2003-12-25"),
("a2", "swami", "swami","swami@gmail.com", "2003-12-18"),
("a3", "meet", "meet","meet@gmail.com", "2003-02-06"),
("a4", "shruti", "shruti","shruti@gmail.com", "2003-03-14"),
("a5", "mihir", "mihir","mihir@gmail.com", "2003-07-12")
;


create table posts(
post_id int primary key auto_increment,
author int not null,
caption text not null,
image varchar(100) not null,
posted_at timestamp default current_timestamp,
foreign key(author) references users(user_id));


insert into posts
(post_id, author, caption,image)
value
("p1","")



create table likes(
like_id int primary key,
post_id int,
user_id int,
foreign key(user_id) references users(user_id),
foreign key(post_id) references posts(post_id));

create table followers (
follower_id int not null,
following_id int not null,
followed_at timestamp default current_timestamp,
primary key (follower_id, following_id),
foreign key(follower_id) references users(user_id),
foreign key(following_id) references users(user_id));

insert into followers 
(follower_id, following_id)
value
("1","2"),
("2","3"),
("5","1"),
("3","4"),
("4","5");

select * from followers;

drop table users;


create table comments(
comment_id int primary key,
post_id int,
user_id int,
text_comment varchar(100),
replay_to varchar(100),
foreign key(user_id) references users(user_id),
foreign key(post_id) references posts(post_id));

desc users;
desc followers;
desc comments;
drop table posts;
desc comments;








