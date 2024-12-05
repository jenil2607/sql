-- Entities
  -- Broker (id, first_name, last_name, age, phno, joined);
  -- Plots (id, cost_price, broker_id, survey_no, type);
  -- Customer (id, first_name, last_name, age, gender, referral_id, pwd);
  -- Sales (id, price, plot_id, customer_id, broker_id, price, date);
  
  create database realstate;
  use realstate;
  
  Create table broker(
  id int primary key,
  first_name varchar(100) not null,
  last_name varchar(100) not null,
  age int,
  phno varchar(100) not null,
  joined timestamp default current_timestamp);
  
  
  create table plots(
  id int primary key auto_increment,
  cost_price double not null,
  broker_id int,
  area float,
  survey_no int not null,
  plot_type varchar(100),
  foreign key(broker_id) references broker(id));
  drop table plots;
  
  create table customer(
  username varchar(100) primary key,
  first_nmae varchar(100) not null,
  last_name varchar(100) not null,
  email varchar(100) not null,
  phno varchar(100) not null,
  pwd varchar(100) not null,
  age int,
  gender enum('male','female','others'),
  referral_id varchar(100),
  foreign key(referral_id) references customer(username));
  
  
  create table sales(
  id int primary key auto_increment,
  plot_id int not null,
  customer_id varchar(100) not null,
  broker_id int,
  price_ float not null,
  sold_at timestamp default current_timestamp,
  foreign key (plot_id) references plots(id),
  foreign key (customer_id) references customer(username),
  foreign key (broker_id) references broker(id));
  
desc sales;
  