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

alter table Apps
add constraint fk_developer
foreign key (DeveloperID)
references Developers(DeveloperID);

alter table Apps
add constraint fk_publisher
foreign key (PublisherID)
references Publishers(PublisherID);

alter table Apps
add constraint fk_category
foreign key(CategoryID)
references Categories(CategoryID);

select * from Apps where rating>4.5;
select * from Apps where Price=0;
select * from Apps where CategoryID=305;

select * from Apps where Downloads>500000000;
select * from Apps where Rating between 4.3 and 4.7;
select * from Apps where Price in (0,299);
select * from Apps where AppName like 'G%';
select * from Apps where AppName like 'Google%';
select * from Apps where Rating>4.0 and Downloads>500000000;
select * from Apps where CategoryID=301 or CategoryID=305;

select * from Apps where AppName not like 'G%';
select * from Apps where Rating<4.5 or Downloads>1000000000;
select * from Developers where DeveloperName like '%a%';
select * from Apps where Price between 0 and 300;
select * from Apps where PublisherID in (201,204);
insert into  Apps
values
(1010,'YouTube',108,201,301,4.7,1000000000,0.00);
select * from Apps;
select * from Apps where not CategoryID=305;



