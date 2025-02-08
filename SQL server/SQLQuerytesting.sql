use Ecomerce;

EXEC sp_configure 'clr enabled', 1;
RECONFIGURE;

select * from sys.schemas ;

alter database ecomerce set trustworthy on ;

----------- data warehouse -----------------
--factsales
exec tsqlt.newtestclass 'SalesFactTest';

-- test for null values for salesfact
create procedure SalesFactTest.test_check_null 
as
begin 
    declare @NullCount int;
    select @NullCount = count(*) from dbo.factsales where pksales is null;
    exec tSQLt.AssertEquals 0, @NullCount, 'test failed: pk in factsales has null value';
end;

-- test for duplicates for salesfact
create procedure SalesFactTest.test_check_duplicate
as
begin
  declare @duplicateCount int=0 ;
  select @duplicateCount = count(*) from dbo.factsales group by pksales having count(*)>1;
  exec tsqlt.assertequals 0, @duplicateCount ,'test fail duplicate in factsales table';
end;

-- test for fk relationship (orphaned rows) for salesfact

create procedure SalesFactTest.test_chack_orphaned_rows 
as
begin
   declare @orphanedRowsCount int ;
   select @orphanedRowsCount = count(*) from dbo.factsales fs left join dbo.dimproduct p on fs.product_id = p.product_id where p.product_id is null ;
   exec tsqlt.assertequals 0,@orphanedRowsCount,'test failed orphaned rows in factsales(product_id)';
end;

create procedure SalesFactTest.test_chack_orphaned_rows2
as
begin
   declare @orphanedRowsCount2 int ;
   select @orphanedRowsCount2 = count(*) from dbo.factsales fs left join dbo.dimDate d on fs.datekey = d.dateKey where d.dateKey is null ;
   exec tsqlt.assertequals 0,@orphanedRowsCount2,'test failed orphaned rows in factsales(datekey)';
end;

create procedure SalesFactTest.test_chack_orphaned_rows3
as
begin
   declare @orphanedRowsCount3 int ;
   select @orphanedRowsCount3 = count(*) from dbo.factsales fs left join dbo.dimshipper s on fs.keyShipper = s.keyShipper where s.keyShipper is null ;
   exec tsqlt.assertequals 0,@orphanedRowsCount3,'test failed orphaned rows in factsales(keyshipper)';
end;

create procedure SalesFactTest.test_chack_orphaned_rows4
as
begin
   declare @orphanedRowsCount4 int ;
   select @orphanedRowsCount4 = count(*) from dbo.factsales fs left join dbo.dimcustomer c on fs.keyCustomer = c.KeyCustomer where c.KeyCustomer is null ;
   exec tsqlt.assertequals 0,@orphanedRowsCount4,'test failed orphaned rows in factsales(keycustomr)';
end;


--productdim
--test for null values for productdim
exec tsqlt.newtestclass 'productDimtest';

create procedure productDimtest.test_check_null
as
begin
 declare @nullcount int ;
 select  @nullcount = count(*) from dbo.dimproduct where product_id is null ;
 exec tsqlt.assertequals 0,@nullcount,'test failed null values in dimproduct(product_id)';
end;
--test to check duplicate for product dim
create procedure productDimtest.test_check_duplicate
as
begin
 declare @duplicateCount int=0;
 select @duplicateCount = count(*) from dbo.dimproduct group by product_id having count(*)>1 ;
 exec tsqlt.assertequals 0,@duplicateCount,'test failed duplicates in dimproduct(product_id)';
end;

--datedim
exec tsqlt.newtestclass 'datedimtest';

create procedure datedimtest.test_check_null
as
begin
 declare @nullcount int ;
 select  @nullcount = count(*) from dbo.dimDate where dateKey is null ;
 exec tsqlt.assertequals 0,@nullcount,'test failed null values in dimdate(datekey)';
end;
--test to check duplicate for date dim
create procedure datedimtest.test_check_duplicate
as
begin
 declare @duplicateCount int=0 ;
 select @duplicateCount = count(*) from dbo.dimDate group by dateKey having count(*)>1 ;
 exec tsqlt.assertequals 0,@duplicateCount,'test failed duplicates in dimdate(datekey)';
end;

--dimCustomer
exec tsqlt.newtestclass 'customerdimtest';

create procedure customerdimtest.test_check_null
as
begin
 declare @nullcount int ;
 select  @nullcount = count(*) from dbo.dimcustomer where KeyCustomer is null ;
 exec tsqlt.assertequals 0,@nullcount,'test failed null values in dimcustomer(keycutomer)';
end;
--test to check duplicate for customer dim
create procedure customerdimtest.test_check_duplicate
as
begin
 declare @duplicateCount int=0 ;
 select @duplicateCount = count(*) from dbo.dimcustomer group by KeyCustomer having count(*)>1 ;
 exec tsqlt.assertequals 0,@duplicateCount,'test failed duplicates in dimcustomer(keycustomer)';
end;

--dimshipper
exec tsqlt.newtestclass 'shipperdimtest';

create procedure shipperdimtest.test_check_null
as
begin
 declare @nullcount int ;
 select  @nullcount = count(*) from dbo.dimshipper where keyShipper is null ;
 exec tsqlt.assertequals 0,@nullcount,'test failed null values in dimshipper(keyshipper)';
end;
--test to check duplicate for shipper dim
create procedure shipperdimtest.test_check_duplicate
as
begin
 declare @duplicateCount int=0 ;
 select @duplicateCount = count(*) from dbo.dimshipper group by keyShipper having count(*)>1 ;
 exec tsqlt.assertequals 0,@duplicateCount,'test failed duplicates in dimshipper(keyshipper)';
end;

--dimsupplier
exec tsqlt.newtestclass 'supplierdimtest';

create procedure supplierdimtest.test_check_null
as
begin
 declare @nullcount int ;
 select  @nullcount = count(*) from dbo.dimsupplier where keySupplier is null ;
 exec tsqlt.assertequals 0,@nullcount,'test failed null values in dimsupplier(keysupplier)';
end;
--test to check duplicate for supplier dim
create procedure supplierdimtest.test_check_duplicate
as
begin
 declare @duplicateCount int =0;
 select @duplicateCount = count(*) from dbo.dimsupplier group by keySupplier having count(*)>1 ;
 exec tsqlt.assertequals 0,@duplicateCount,'test failed duplicates in dimsupplier(keysupplier)';
end;

--factinventory
exec tsqlt.newtestclass 'inventoryFactTest';

-- test for null values for inventoryfact
create procedure inventoryFactTest.test_check_null 
as
begin 
    declare @NullCount int;
    select @NullCount = count(*) from dbo.factinventory where pkinventory is null;
    exec tSQLt.AssertEquals 0, @NullCount, 'test failed: pk in factinventory has null value';
end;

-- test for duplicates for factinventory
create procedure inventoryFactTest.test_check_duplicate
as
begin
  declare @duplicateCount int=0 ;
  select @duplicateCount = count(*) from dbo.factinventory group by pkinventory having count(*)>1;
  exec tsqlt.assertequals 0, @duplicateCount ,'test fail duplicate in factinventory table';
end;

-- test for fk relationship (orphaned rows) for factinventory

create procedure inventoryFactTest.test_chack_orphaned_rows 
as
begin
   declare @orphanedRowsCount int ;
   select @orphanedRowsCount = count(*) from dbo.factinventory fs left join dbo.dimproduct p on fs.product_id = p.product_id where p.product_id is null ;
   exec tsqlt.assertequals 0,@orphanedRowsCount,'test failed orphaned rows in factiventory(product_id)';
end;

create procedure inventoryFactTest.test_chack_orphaned_rows2
as
begin
   declare @orphanedRowsCount2 int ;
   select @orphanedRowsCount2 = count(*) from dbo.factinventory fs left join dbo.dimDate d on fs.datekey = d.dateKey where d.dateKey is null ;
   exec tsqlt.assertequals 0,@orphanedRowsCount2,'test failed orphaned rows in factinventory(datekey)';
end;

create procedure inventoryFactTest.test_chack_orphaned_rows3
as
begin
   declare @orphanedRowsCount3 int ;
   select @orphanedRowsCount3 = count(*) from dbo.factinventory fs left join dbo.dimsupplier s on fs.keySupplier = s.keySupplier where s.keySupplier is null ;
   exec tsqlt.assertequals 0,@orphanedRowsCount3,'test failed orphaned rows in factinventory(keysupplier)';
end;



-----------------datamart---------------------
--datamart sales
--top_p_salesamount
exec tsqlt.NewTestClass 'dm2salestest';
--orphaned rows
create procedure dm2salestest.test_check_orphaned_rows
as
begin
  declare @orphanedrowsCount int ;
  select @orphanedrowsCount = count(*) from datamart2.factsales fs left join datamart2.top_p_salesamount tps on fs.product_id = tps.product_id where tps.product_id is null ;
  exec tsqlt.AssertEquals 0,@orphanedrowsCount , 'test failed orphaned rows in data mart s fact table(top_p_salesamount.product_id)';
end;
-- duplicates & null values 
create procedure dm2salestest.test_check_null
as
begin
  declare @nullcount int ;
  select @nullcount = count(*) from datamart2.top_p_salesamount where product_id is null ;
  exec tsqlt.AssertEquals 0 , @nullcount,'test failed null value in pk of top_p_salesamount';
end;

create procedure dm2salestest.test_check_duplicate
as
begin
  declare @duplicateCount int=0 ;
  select @duplicateCount = count(*) from datamart2.top_p_salesamount group by product_id having count(*)>1;
  exec tsqlt.assertequals 0, @duplicateCount ,'test failed duplicate in top_p_salesamount table';
end;

--best_shipping_m
exec tsqlt.NewTestClass 'bstTtest';
--orphaned rows
create procedure bstTtest.test_check_orphaned_rows
as
begin
  declare @orphanedrowsCount int ;
  select @orphanedrowsCount = count(*) from datamart2.best_shipping_m bs right join datamart2.dimshipper s on bs.ShippingMethod = s.ShippingMethod where s.ShippingMethod is null ;
  exec tsqlt.AssertEquals 0,@orphanedrowsCount , 'test failed orphaned rows in data mart s fact table(best_shipping_m)';
end;

--datamart inventory
exec tsqlt.NewTestClass 'dminventorytest';
--orphaned rows
create procedure dminventorytest.test_check_orphaned_rows
as
begin
  declare @orphanedrowsCount int ;
  select @orphanedrowsCount = count(*) from datamart.factIventory fi left join datamart.T_A_stock_K tak on fi.keySupplier = tak.keySupplier where tak.keySupplier is null ;
  exec tsqlt.AssertEquals 0,@orphanedrowsCount , 'test failed orphaned rows in data mart s fact table(T_A_stock_K.keysupplier)';
end;


create procedure dminventorytest.test_check_orphaned_rows2
as
begin
  declare @orphanedrowsCount int ;
  select @orphanedrowsCount = count(*) from datamart.factIventory fi left join datamart.T_stocksold_Y tay on fi.year = tay.year where tay.year is null ;
  exec tsqlt.AssertEquals 0,@orphanedrowsCount , 'test failed orphaned rows in data mart s fact table(T_stocksold_Y.year)';
end;


--T_A_stock_K;
create procedure dminventorytest.test_check_null
as
begin
  declare @nullcount int ;
  select @nullcount = count(*) from datamart.T_A_stock_K where keySupplier is null ;
  exec tsqlt.AssertEquals 0 , @nullcount,'test failed null value in pk of T_A_stock_K';
end;

--to make shure
SELECT name 
FROM sys.procedures 
WHERE schema_id = SCHEMA_ID('dminventorytest');

select * from tsqlt.testclasses;

--exec tsqlt.run 'dminventorytest';
--exec tsqlt.RunAll;