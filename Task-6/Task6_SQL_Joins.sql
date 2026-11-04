use PlayStoreDB;
select A.DeveloperID,A.AppName,D.DeveloperName from Apps A inner join Developers D on A.DeveloperID=D.DeveloperID;
select A.PublisherID,A.AppName,P.PublisherName from Apps A inner join Publishers P on A.PublisherID=P.PublisherID;
select A.CategoryID,A.AppName,C.CategoryName from Apps A inner join Categories C on A.CategoryID=C.CategoryID;
select A.AppName,D.DeveloperName,P.PublisherName from Apps A inner join Developers D on A.DeveloperID=D.DeveloperID inner join Publishers P on A.PublisherID=P.PublisherID;
select A.AppName,D.DeveloperName,C.CategoryName from Apps A inner join Developers D on A.DeveloperID=D.DeveloperID inner join Categories C on A.CategoryID=C.CategoryID;
select P.PublisherID,P.PublisherName,A.AppName from Publishers P left join Apps A on P.PublisherID=A.PublisherID;
select C.CategoryID,C.CategoryName,A.AppName from Categories C left join Apps A on C.CategoryID=A.CategoryID;

select P.PublisherID,A.AppName from Publishers P left join Apps A on P.PublisherID=A.PublisherID;
select P.PublisherID,P.PublisherName,A.AppName from Publishers P right join Apps A on P.PublisherID=A.PublisherID;
select C.CategoryID,C.CategoryName,A.AppName from Apps A right join Categories C on A.CategoryID=C.CategoryID;
select A.AppName,D.DeveloperName,D.Country from Apps A join Developers D on A.DeveloperID=D.DeveloperID;
select A.AppName,D.DeveloperName,P.PublisherName,C.CategoryName from Apps A join Developers D on A.DeveloperID=D.DeveloperID join Publishers P on A.PublisherID=P.PublisherID join Categories C on A.CategoryID=C.CategoryID;
select A.AppName,D.DeveloperName,D.Country from Apps A join Developers D on D.DeveloperID=A.DeveloperID where Country='USA';
select A.AppName,P.PublisherID,C.CategoryID from Apps A join Publishers P on P.PublisherID=A.PublisherID join Categories C on C.CategoryID=A.CategoryID where C.CategoryName="Gaming";
select A.AppName,D.DeveloperName from Apps A join Developers D on D.DeveloperID=A.DeveloperID where A.Rating>4.5;

select P.PublisherName,A.AppName from Publishers P left join Apps A on A.PublisherID=P.PublisherID;
select P.PublisherName ,A.AppName from Publishers P left join Apps A on A.PublisherID=P.PublisherID where A.AppName is NULL;
select A.AppName,C.CategoryName from Apps A join Categories C on A.CategoryID=C.CategoryID order by CategoryName;
select A.AppName,D.DeveloperName,P.PublisherName,C.CategoryName,A.Rating from Apps A join Developers D on A.DeveloperID=D.DeveloperID join Publishers P on A.PublisherID=P.PublisherID join Categories C on A.CategoryID=C.CategoryID;
select A.AppName,D.DeveloperName,P.PublisherName from Apps A join Developers D on A.DeveloperID=D.DeveloperID join Publishers P on A.PublisherID=P.PublisherID where D.Country='USA' and P.PublisherName='Google Play';
select D.DeveloperName,A.AppName from Developers D left join Apps A on D.DeveloperID=A.DeveloperID;
select D1.DeveloperName,D1.Country from Developers D1 join Developers D2 on D1.Country=D2.Country;
select P.PublisherName,C.CategoryName from Publishers P cross join Categories C;
select P.PublisherID, P.PublisherName, A.AppName from Publishers P left join Apps A on P.PublisherID = A.PublisherID 
union 
select P.PublisherID, P.PublisherName, A.AppName from Publishers P right join Apps A on P.PublisherID = A.PublisherID;
select D.DeveloperName,P.PublisherName,C.CategoryName,A.AppName from Apps A join Developers D on D.DeveloperID=A.DeveloperID join Publishers P on P.PublisherID=A.PublisherID join Categories C on C.CategoryID=A.CategoryID where C.CategoryName="Gaming" or C.CategoryName="Social";
select A.AppName,D.DeveloperName,C.CategoryName from Apps A join Developers D on A.DeveloperID=D.DeveloperID join Categories C on A.CategoryID=C.CategoryID where A.Rating between 4.3 and 4.7;
select D.DeveloperName,A.AppName from Apps A join Developers D on A.DeveloperID=D.DeveloperID where D.Country<>'India';
