use PlayStoreDB;
DELIMITER //
CREATE PROCEDURE hello()
BEGIN 
	select 'Hello Welcome to Pl Sql' AS Intro;
END //
DELIMITER ;
CALL hello();



delimiter //
create procedure retrieve(in AID int)
begin
declare A_name varchar(20);
declare A_Rating decimal(2,1);
select AppName,Rating into A_name,A_Rating  from Apps where AppID=AID;

select A_name as 'Name;',A_Rating as 'Rating';
end//
delimiter ;
call retrieve(1004);


#level 0
delimiter \\
create procedure PriceBased(in aid int)
begin 
declare V_Price Decimal(3,1);
select Price*1.10 into V_Price from Apps where AppID=aid;
select V_Price as 'Tax';
end \\
delimiter ;
CALL PriceBased(1004);



delimiter \\
create procedure Details(in ApID int)
begin
declare AN Varchar(100);
declare Ra,Pr Decimal(2,1);
declare Dow int;
select AppName,Rating,Price,Downloads into AN,Ra,Pr,Dow from Apps where AppID=ApID;
select AN as 'Name',Ra as 'Rat', Pr as 'Price', Dow as 'Downloads';
end  \\
delimiter ;
call Details(1002);

delimiter //
create procedure Based_On_rating(in id int)
begin
declare AName varchar(200);
declare rat decimal(2,1);
declare stat varchar(300);
select AppName,Rating into AName,rat from Apps where AppID=id;
 
if rat>=5 Then
	set stat='Highly Rated';
elseif rat>=4 then
	set stat = 'Moderately Rated';
else 
	set stat='Low Rated';
end if;
select AName as 'AppName',stat as 'Status';
end //
delimiter ;
call Based_On_rating(1008);



delimiter //
create function PaidFree( APrice decimal(10,4))
returns varchar(200)
deterministic
begin 
declare ou varchar(200);
	if APrice>0 then 
		set ou='Paid Application';
	else
		set ou='Free Application';
	end if;
    return ou;
end //
delimiter ;
select PaidFree(0);

    
delimiter //
create procedure nums()
begin
declare a int default 1;
declare b int default 10;

count_loop:LOOP
	select a;
    set a=a+1;
    if a=b then 
		leave count_loop;
	end if;
end LOOP count_loop;
end //
delimiter ;

call nums();
drop procedure nums;