use PlayStoreDB;
#LEVEL 0

UPDATE Apps
SET Rating=5
Where AppID=1002;
COMMIT;


select @@autocommit;
set autocommit=0;
START TRANSACTION;
update Apps
set Price=900
where AppID=1006;
select AppID,Price from Apps where AppID=1006;
ROLLBACK;
select AppID,Price from Apps where AppID=1006;

SELECT AppName,Price from Apps where AppName='BYJUS';

insert into Apps() values (1012,"YouTube",102,203,302,4.9,400000,900);
select * from Apps;
COMMIT;
select * from Apps;


insert into Developers() values (107,"Meta","USA",2007);
select * from Developers;
rollback;
select * from Developers;

update Apps
set Rating=9
where AppID=1001;
SAVEPOINT Ratingsavepoint;

#LEVEL 1
select  AppID,AppName,Rating from Apps where AppID in (1003,1004);

start transaction;
UPDATE Apps
SET Rating=8.5
WHERE AppID=1003;

SAVEPOINT Update_Rating1;

update Apps 
set Rating=8.9
where AppID=1004;

rollback to savepoint Update_Rating1;
select  AppID,AppName,Rating from Apps where AppID in (1003,1004);


start transaction;
insert into Apps() values (1014,"Whatsapp",103,204,302,7.6,20000,9800);
savepoint insertsavepoint;
update Apps
set Price=8000
where AppID=1014;

select * from Apps where AppID=1014;
rollback to savepoint insertsavepoint;
select * from Apps where AppID=1014;

GRANT SELECT 
ON Apps to 'Students';
grant select,insert on Apps to username;
revoke insert on Apps from username;


#LEVEL 2
start transaction;
savepoint updatesavepoint;
update Apps
set Price=120
where AppID=1006;

update Apps 
set price=110
where AppID=1007;

rollback to savepoint updatesavepoint;

select * from Apps where AppID in (1006,1007);

start transaction;
savepoint cateinsert;
insert into Categories() values (307,"Entertainment",19),(308,"Dance",19);
rollback to savepoint cateinsert;
select * from Categories;


start transaction;
savepoint point1;
insert into Publishers() values (205,"Vivo","Delhi","support@vivo.com");
update Apps
set Rating=9
where AppID=1009;
select * from Publishers;
rollback to savepoint point1;
select * from Publishers;

select * from Apps;
select * from Developers;


