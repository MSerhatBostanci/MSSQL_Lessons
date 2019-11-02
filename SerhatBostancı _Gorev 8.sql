insert into Region values(5,'Middle')
insert into Territories values(98500 ,'Kastamonu', 5)
insert into Employees(LastName,FirstName,Title,TitleOfCourtesy,Address,City,Region,PostalCode,Country,HomePhone,Extension,Notes) values ('Bostancý','Serhat','Kral','Mr.', 'Seni Alakadar Etmez', 'Kastamonu', 'KA','00000','Turkey', '(222)222-2222',0001,'Best of Best' )
insert into EmployeeTerritories values ((select EmployeeID from Employees where Title like 'Kral'),(select TerritoryID from Territories where TerritoryDescription like 'Kastamonu'))
insert into Customers values ('MBOST','Bostancý Company', 'Muharrem Bostancý', 'Lord', 'Kime sorsan gösterir','Istanbul',Null,'00000','Turkey','(9) 331-6954','(9) 331-7256')
insert into Shippers(CompanyName,Phone) values ('Bostancý Shipping', '57423547')
insert into Orders values ('MBOST', 18, '1996-07-04 00:00:00.000', '1996-08-01 00:00:00.000','1996-07-16 00:00:00.000',6,2000.01 , 'GreatBostancý', 'Nal', 'Kastamonu',null,'000000','Turkey' )
insert into Suppliers values('Bostancý Supplies', 'Muharrem Serhat', 'Spiritual Leader', 'No one knows', null, null, 'Nal', 'BostancýLand','(03) 3555-5011',null,null )
insert into Categories values ('SerhatMade', 'Anything Serhat Makes', null)
insert into Products values ('Serhats', (select SupplierID from Suppliers where Country='BostancýLand'), (select CategoryID from Categories where CategoryName = 'SerhatMade'), 'Milyonlar', '9999', 150,50,40,0)
insert into [Order Details] values ((select top 1 OrderID from Orders where CustomerID = 'MBOST' ), (select ProductID from Products where ProductName='Serhats'), 999.10, 500, 0.99)
insert into Products(ProductName) values ('MasterBostancý')
insert into Shippers(CompanyName) values ('Super Fast')
insert into Orders(OrderDate) values (1992-02-01)
insert into Suppliers(CompanyName,Phone) values ('kompani neym','(259)674123')
insert into Categories values ('Nallar', 'Nallar içerir','Vesikalýk' )
insert into Customers values ('RNDCO', 'RANDOM COMPANY', 'RANDOM CONTACT', null,null,null,null,null,null,null,null)
insert into Territories values (9999, 'Heryer', 5)
insert into Region values (6,'Up')
insert into Shippers values ('SerhatExpress', '8889852')


delete from Region where RegionID=5
delete from Territories where TerritoryID=98500
delete from Employees where Title like 'Kral'
delete from EmployeeTerritories where TerritoryID=17
delete from Customers where CustomerID='MBOST'
delete from Shippers where CompanyName like '%Bostancý%'
delete from Orders where OrderID like 'MBOST'
delete from Suppliers where Country='BostancýLand'
delete from Categories where CategoryName = 'SerhatMade'
delete from Products where ProductName = 'Serhats'
delete from [Order Details] where OrderID=(select top 1 OrderID from Orders where CustomerID = 'MBOST') and ProductID=(select ProductID from Products where ProductName='Serhats')
delete from Products where ProductName like 'Master%'
delete from Shippers where CompanyName like 'Super%'
delete from Orders where OrderDate like '%1992%'
delete from Suppliers where CompanyName like 'kompani%'
delete from Categories where Description like '%Nallar%'
delete from Customers where CustomerID='RNDCO'
delete from Territories where TerritoryDescription='Heryer'
delete from Region where RegionDescription = 'Up'
delete from Shippers where CompanyName like '%Serhat%'

update Region set RegionDescription=05 where RegionID=5
update Territories set TerritoryDescription='Kastamonulu' where TerritoryID=98500
update Employees set FirstName='Muharrem Serhat' where Title like 'Kral'
update EmployeeTerritories set EmployeeID= (select top 1 EmployeeID from Employees) where TerritoryID=17
update Customers set CompanyName='Super Company' where CustomerID='MBOST'
update Shippers set Phone= '56886451'  where CompanyName like '%Bostancý%'
update Orders set ShipCountry='Turkey' where OrderID like 'MBOST'
update Suppliers set Country='London' where Country='BostancýLand'
update Categories set Description='Serhats products' where CategoryName = 'SerhatMade'
update Products set UnitPrice=998.90 where ProductName = 'Serhats'
update Products set Discontinued=1 where ProductName like 'mas%'
update Shippers set Phone = '9852478' where CompanyName like 'Super%'
update Orders set ShipCity='Gastamonu' where OrderDate like '%1992%'
update Suppliers set ContactTitle='Superman' where CompanyName like 'kompani%'
update Categories set Picture='Biyometrik' where Description like '%Nallar%'
update Customers set PostalCode= 45678 where CustomerID='RNDCO'
update Territories set RegionID=5 where TerritoryDescription='Heryer'
update Region set RegionDescription='Up ' where RegionDescription = 'Up'
update Shippers set Phone=null where CompanyName like '%Serhat%'
update Orders set ShipPostalCode='54212' where ShipCountry='Turkey'


select * from Region 
--------------------------------------------------------------------------------------------
begin tran
commit tran
rollback
