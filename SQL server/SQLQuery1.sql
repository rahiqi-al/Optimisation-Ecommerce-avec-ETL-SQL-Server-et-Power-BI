use Ecomerce;

--------------------------stats------------------------------------

alter database ecomerce set auto_update_statistics on ;

------------------------------ this for  datamart inventory----------------------

select * from datamart.factIventory;
--create the filegroups
alter database ecomerce add filegroup fg1_I;
alter database ecomerce add filegroup fg2_I;
alter database ecomerce add filegroup fg3_I;
alter database ecomerce add filegroup fg4_I;
--add file
ALTER DATABASE ecomerce
ADD FILE
(
    NAME = 'fg1_I_file',
    FILENAME = 'C:\SQLData\fg1_I_file.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP fg1_I;

ALTER DATABASE ecomerce
ADD FILE
(
    NAME = 'fg2_I_file',
    FILENAME = 'C:\SQLData\fg2_I_file.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP fg2_I;

ALTER DATABASE ecomerce
ADD FILE
(
    NAME = 'fg3_I_file',
    FILENAME = 'C:\SQLData\fg3_I_file.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP fg3_I;

ALTER DATABASE ecomerce
ADD FILE
(
    NAME = 'fg4_I_file',
    FILENAME = 'C:\SQLData\fg4_I_file.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP fg4_I;


create partition function pf_inventory(int)
as range left for values (2021, 2022, 2023);

create partition SCHEME ps_inventory 
as partition pf_inventory 
to ([fg1_I],[fg2_i],[fg3_I],[fg4_I]);

create nonclustered index nc_inventory_year
on datamart.factIventory(year)
on  ps_inventory (year);


create nonclustered index nc_fk_inventory
on datamart.factIventory(keySupplier ,product_id ,datekey,year);

create nonclustered index nc_fk_inventory_supplier
on datamart.factIventory(keySupplier);
create nonclustered index nc_fk_inventory_product
on datamart.factIventory(product_id);
create nonclustered index nc_fk_inventory_date
on datamart.factIventory(datekey);


----------------------------- this for  datamart sales --------------------------

select * from datamart2.factsales;

--create the filegroups
alter database ecomerce add filegroup fg1_S;
alter database ecomerce add filegroup fg2_S;
alter database ecomerce add filegroup fg3_S;
alter database ecomerce add filegroup fg4_S;

--add file to the filegroup

ALTER DATABASE ecomerce
ADD FILE
(
    NAME = 'fg1_S_file',
    FILENAME = 'C:\SQLData\fg1_S_file.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP fg1_S;

ALTER DATABASE ecomerce
ADD FILE
(
    NAME = 'fg2_S_file',
    FILENAME = 'C:\SQLData\fg2_S_file.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP fg2_S;

ALTER DATABASE ecomerce
ADD FILE
(
    NAME = 'fg3_S_file',
    FILENAME = 'C:\SQLData\fg3_S_file.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP fg3_S;

ALTER DATABASE ecomerce
ADD FILE
(
    NAME = 'fg4_S_file',
    FILENAME = 'C:\SQLData\fg4_S_file.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP fg4_S;

create partition function pf_sales(int)
as range left for values (2021, 2022, 2023);

create partition SCHEME ps_sales 
as partition pf_sales 
to ([fg1_S],[fg2_S],[fg3_S],[fg4_S]);

create nonclustered index nc_sales_quantitySold
on datamart2.factsales(year)
on  ps_sales (year);


create nonclustered index nc_fk_sales 
on datamart2.factsales(keyShipper ,product_id ,datekey ,keyCustomer);

create nonclustered index nc_fk_sales_shipper
on datamart2.factsales(keyShipper);
create nonclustered index nc_fk_sales_product
on datamart2.factsales(product_id);
create nonclustered index nc_fk_sales_date
on datamart2.factsales(datekey);
create nonclustered index nc_fk_sales_customer
on datamart2.factsales(keyCustomer);
create nonclustered index  nc_fk_dimshippher_shippingmethod
on datamart2.dimshipper(ShippingMethod)

-- to make shure 

SELECT * 
FROM sys.partition_functions;
SELECT * 
FROM sys.partition_schemes;

-------------------------------this is for data warehouse------------------------
select * from dbo.factinventory;

--create the filegroups
alter database ecomerce add filegroup fg1_I_g;
alter database ecomerce add filegroup fg2_I_g;
alter database ecomerce add filegroup fg3_I_g;
alter database ecomerce add filegroup fg4_I_g;
--add file
ALTER DATABASE ecomerce
ADD FILE
(
    NAME = 'fg1_I_g_file',
    FILENAME = 'C:\SQLData\fg1_I_g_file.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP fg1_I_g;

ALTER DATABASE ecomerce
ADD FILE
(
    NAME = 'fg2_I_g_file',
    FILENAME = 'C:\SQLData\fg2_I_g_file.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP fg2_I_g;

ALTER DATABASE ecomerce
ADD FILE
(
    NAME = 'fg3_I_g_file',
    FILENAME = 'C:\SQLData\fg3_I_g_file.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP fg3_I_g;

ALTER DATABASE ecomerce
ADD FILE
(
    NAME = 'fg4_I_g_file',
    FILENAME = 'C:\SQLData\fg4_I_g_file.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP fg4_I_g;


create partition function pf_inventory_galaxy (int)
as range left for values (2021, 2022, 2023);

create partition SCHEME ps_inventory_galaxy
as partition pf_inventory_galaxy
to ([fg1_I_g],[fg2_I_g],[fg3_I_g],[fg4_I_g]);

create nonclustered index nc_inventory_year_galaxy
on dbo.factinventory(year)
on  ps_inventory_galaxy (year);

select * from dbo.factinventory;

create nonclustered index nc_fk_inventory_galaxy
on dbo.factinventory(keySupplier ,product_id ,datekey,year);

create nonclustered index nc_fk_inventory_supplier_galaxy
on dbo.factinventory(keySupplier);
create nonclustered index nc_fk_inventory_product_galaxy
on dbo.factinventory(product_id);
create nonclustered index nc_fk_inventory_date_galaxy
on dbo.factinventory(datekey);

------------------------------------------------------
select * from dbo.factsales;

alter database ecomerce add filegroup fg1_S_g;
alter database ecomerce add filegroup fg2_S_g;
alter database ecomerce add filegroup fg3_S_g;
alter database ecomerce add filegroup fg4_S_g;

--add file to the filegroup

ALTER DATABASE ecomerce
ADD FILE
(
    NAME = 'fg1_S_g_file',
    FILENAME = 'C:\SQLData\fg1_S_g_file.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP fg1_S_g;

ALTER DATABASE ecomerce
ADD FILE
(
    NAME = 'fg2_S_g_file',
    FILENAME = 'C:\SQLData\fg2_S_g_file.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP fg2_S_g;

ALTER DATABASE ecomerce
ADD FILE
(
    NAME = 'fg3_S_g_file',
    FILENAME = 'C:\SQLData\fg3_S_g_file.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP fg3_S_g;

ALTER DATABASE ecomerce
ADD FILE
(
    NAME = 'fg4_S_g_file',
    FILENAME = 'C:\SQLData\fg4_S_g_file.ndf',
    SIZE = 5MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 5MB
)
TO FILEGROUP fg4_S_g;

create partition function pf_sales_galaxy (int)
as range left for values (2021, 2022, 2023);

create partition SCHEME ps_sales_galaxy 
as partition pf_sales_galaxy 
to ([fg1_S_g],[fg2_S_g],[fg3_S_g],[fg4_S_g]);

create nonclustered index nc_sales_quantitySold_galaxy
on dbo.factsales(year)
on  ps_sales_galaxy (year);


create nonclustered index nc_fk_sales_galaxy 
on dbo.factsales(keyShipper ,product_id ,datekey ,keyCustomer);

create nonclustered index nc_fk_sales_shipper_galaxy
on dbo.factsales(keyShipper);
create nonclustered index nc_fk_sales_product_galaxy
on dbo.factsales(product_id);
create nonclustered index nc_fk_sales_date_galaxy
on dbo.factsales(datekey);
create nonclustered index nc_fk_sales_customer_galaxy
on dbo.factsales(keyCustomer);


----------------------------------- user & roles---------------------------------

create login l1 with password='123yc';
create user abderahim for login l1;
create role formateur ;
grant select on schema::dbo to formateur;
grant select on schema::datamart to formateur;
grant select on schema::datamart2 to formateur;
exec sp_addrolemember 'formateur','abderahim';




