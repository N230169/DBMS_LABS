use PlayStoreDB;
delimiter //
create procedure calculate_discount(in p_app_id int)
begin
   declare v_price decimal(6,2);
   declare v_discount decimal(6,2);
   select Price into v_price from Apps where AppID=p_app_id;
   set v_dscont=v_rice*0.10;
   select p_ as AppID

