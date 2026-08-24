drop database PlayStoreDB;
create database PlayStoreDB;
use PlayStoreDB;
create table Developers(
      DeveloperID int primary key,
      DeveloperName varchar(60) not null,
      Country varchar(30),
      FoundedYear int 
);
insert into Developers(DeveloperID,DeveloperName,Country,FoundedYear)
values
(101,'Google LLC','USA',1998),
(102,'Meta Platforms','USA',2004),
(103,'Spotify AB','Sweden',2006),
(104,'Canva Pty Ltd','Australia',2012),
(105,'BYJUS','India',2011);

create table Publishers(
		PublisherID int primary key,
		PublisherName varchar(60),
        HeadOffice varchar(40),
        SupportEmail varchar(60)
);
insert into Publishers(PublisherID,PublisherName,HeadOffice,SupportEmail)
values
(201,'Google Play','California','support@google.com'),
(202,'Samsung Galaxy Store','Seoul','support@samsung.com'),
(203,'Huawei AppGallery','Shenzen','support@huawei.com'),
(204,'Amazon Appstore','Seattle','support@amazon.com');

create table Categories(
		CategoryID int primary key,
        CategoryName varchar(40),
        MinimumAge int
);
insert into Categories(CategoryID,CategoryName,MinimumAge)
values
(301,'Education',3),
(302,'Productivity',3),
(303,'Music',12),
(304,'Social',13),
(305,'Gaming',16);

create table Apps(
		AppID int primary key,
        AppName varchar(60),
        DeveloperID int,
        PublisherID int,
        CategoryID int,
        Rating decimal(2,1),
        Downloads int,
        Price decimal(6,2)
);
insert into Apps(AppID,AppName,DeveloperID,PublisherID,CategoryID,Rating,Downloads,Price)
values
(1001,'Google Classroom',101,201,301,4.6,500000000,0),
(1002,'Google Keep',101,201,302,4.6,1000000000,0),
(1003,'Instagram',102,201,304,4.6,500000000,0),
(1004,'Spotify',103,201,303,4.6,1000000000,0),
(1005,'Canva',104,201,302,4.6,500000000,0),
(1006,'BYJUS Learning',105,201,301,4.6,500000000,299),
(1007,'Candy Crush',102,204,305,4.6,1000000000,0),
(1008,'Temple Run',104,203,305,4.6,500000000,0);

select * from Developers;
select * from Publishers;
select * from Categories;
select * from Apps;

insert into Developers
values(106,'OpenAI','USA',2015);

insert into Categories
values(306,'Artificial Intelligence',12);

insert into Apps
values(1000,'ChatGPT',106,201,306,4.9,500000000,0);

update Apps
set Rating=4.5
where AppID=1008;
																											
delete from Developers
where DeveloperID=105;

update Publishers
set SupportEmail="support@samsunggalaxy.com"
where PublisherID=202;

insert into Apps
values
(1010,'Whatsapp',102,201,304,4.7,700000000,0),
(1011,'Google Maps',101,201,302,4.8,100000000,0);

update Apps
set Price=199
where AppID=1006;

delete from Categories
where CategoryID=303;

select * from Developers;
select * from Publishers;
select * from Categories;
select * from Apps;

select upper(DeveloperName) from Developers;
select lower(DeveloperName) from Developers;
select length(AppName) from Apps;
select CategoryName,length(CategoryName) from Categories;
select current_date(),current_time();
select round(Rating,0) from Apps;

select AppName,substring(AppName,1,5) from Apps;
select concat(DeveloperName,',',Country) from Developers;
select round(Rating,0) from Apps;
select ceil(Price) from Apps;
select FoundedYear from Developers;
select cast(Downloads as char) from Apps;

select upper(AppName),Rating from Apps;
select substring(CategoryName,1,3) from Categories;
select abs(200-Price) from Apps;
select DeveloperName,length(DeveloperName) from Developers;
select current_date(),current_timestamp();
select cast(Downloads as char) from Apps;
select convert(Downloads,char) from Apps;








