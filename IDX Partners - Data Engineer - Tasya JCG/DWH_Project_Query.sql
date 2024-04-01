create table DimCustomer (CustomerID int primary key not null,
first_name varchar(50) not null,
last_name varchar(50) not null,
age int not null,
gender varchar(50) not null,
city varchar(50) not null,
no_hp varchar(50) not null);

create table DimProduct (ProductID int primary key not null,
product_name varchar(255) not null,
product_category varchar(255) not null,
product_unit_price int null);

create table DimStatusOrder (StatusID int primary key not null,
status_order varchar(50) not null,
status_order_desc varchar(50) not null);

create table FactSalesOrder (OrderID int not null,
CustomerID int not null,
ProductID int not null,
quantity int not null,
amount int not null,
StatusID int not null,
order_date date not null,
primary key (OrderID),
foreign key (CustomerID) references DimCustomer(CustomerID),
foreign key (ProductID) references DimProduct(ProductID),
foreign key (StatusID) references DimStatusOrder(StatusID));

-- Melihat apakah data yang dipindahkan dari Database Staging sudah terinput atau belum
select * from DimCustomer
select * from DimProduct
select * from DimStatusOrder
select * from FactSalesOrder

CREATE PROCEDURE dbo.summary_order_status 
(
@StatusID int
)
AS
BEGIN
  SELECT ft.OrderID, CONCAT(UPPER(dc.first_name),' ',UPPER(dc.last_name)) AS CustomerName, 
  dp.product_name, ft.quantity, ds.status_order
  from FactSalesOrder ft
  INNER JOIN DimCustomer dc ON ft.CustomerID = dc.CustomerID
  INNER JOIN DimProduct dp ON ft.ProductID = dp.ProductID
  INNER JOIN DimStatusOrder ds ON ft.StatusID = ds.StatusID
  WHERE ft.StatusID = @StatusID
END;

EXEC dbo.summary_order_status @StatusID = 1
EXEC dbo.summary_order_status @StatusID = 2
EXEC dbo.summary_order_status @StatusID = 3
EXEC dbo.summary_order_status @StatusID = 4
EXEC dbo.summary_order_status @StatusID = 5

DROP PROCEDURE [summary_order_status];
GO
