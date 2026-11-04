use PlayStoreDB;
create view view1 as select * from Apps;
create view view2 as select AppID,AppName,Rating,Price from Apps;
create view view3 as select * from Apps where Rating>=4.5;
create view view4 as select * from Apps where Price=0;
select * from view3;
show full tables where Table_type='VIEW';

create view view6 as select A.AppName,D.DeveloperName from Apps A join Developers D on A.DeveloperID=D.DeveloperID;
create view view7 as select A.AppName,P.PublisherName from Apps A join Publishers P on A.PublisherID=P.PublisherID;
create view view8 as select A.AppName,C.CategoryName from Apps A join Categories C on A.CategoryID=C.CategoryID;
create view view9 as select A.AppID,A.AppName,D.DeveloperID,D.Country from Apps A join Developers D on A.DeveloperID=D.DeveloperID;
create view view10 as select count(*) from Apps A group by CategoryID;
create view view11 as select count(*) from Apps A group by DeveloperID;
create view view12 as select avg(Rating) from Apps A group by CategoryID;
create view view13 as select A.AppName,D.DeveloperName from Apps A join Developers D where A.Rating>4.3;
select AppName,DeveloperName from view13;
show create view view13;

create view view14 as select C.CategoryName,count(A.AppID) from Apps A right join Categories C on A.CategoryID=C.CategoryID group by C.CategoryID;
create view view15 as select D.DeveloperName,count(A.AppID) from Developers D join Apps A on A.DeveloperID=D.DeveloperID group by D.DeveloeprID having count(A.AppID)>1;
create view view16 as select C.CategoryID,C.CategoryName,max(A.Rating),min(A.Rating) from Categories C left join Apps A on A.CategoryID=C.CategoryID group by C.CategoryID;
create view view17 as select D.DeveloperName,count(A.AppID) from Developers D left join Apps A on D.DeveloperID=A.DeveloperID group by D.DeveloperID;
create view view18 as select A.AppID,D.DeveloperID,C.CategoryID,P.PublisherID from Apps A join Developers D on A.DeveloperID=D.DeveloperID join Categories C on A.CategoryID=C.CategoryID join Publishers P on A.PublisherID=P.PublisherID;
create view view19 as select A.AppID,D.DeveloperName,C.CategoryName from Apps A join Developers D on A.DeveloperID=D.DeveloperID join Categories C on A.CategoryID=C.CategoryID where A.Rating>4.3;
create view view20 as select P.PublisherName,count(A.AppID),coalesce(sum(A.Downloads),0) from Publishers P left join Apps A on P.PublisherID=A.PublisherID group by P.PublisherID;
create view view21 as select AppName,DeveloperName,PublisherName,CategoryName,Rating from view18 where Rating>4.3 order by Rating desc;
create view view22 as select AppID,AppName,Rating from Apps;
update view22 set Rating=4.8 where AppID=1008;
select * from Apps where AppID=1008;

create view viewtodrop as select * from Apps;
drop view viewtodrop;
show full tables where Table_type='VIEW';
  