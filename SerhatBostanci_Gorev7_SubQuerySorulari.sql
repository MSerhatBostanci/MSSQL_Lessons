------------------------------------SubQuery Örnekleri-------------------------
--1- Chai ürününden toplam 50 adetten fazla sipariþ vermiþ müþterilerimin listesi nedir.

--subquery'siz
select c.CustomerID, c.CompanyName, sum(od.Quantity) from Customers c 
	join Orders o on c.CustomerID=o.CustomerID 
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on od.ProductID=p.ProductID
where p.ProductName='Chai'
group by c.CustomerID, c.CompanyName
having sum(od.Quantity)>50

--subquery'li

select o.CustomerID,
	(select CompanyName from Customers where CustomerID=o.CustomerID) CompanyName,
	sum(od.Quantity) Quantity 
from Orders o 
	join (select 
			OrderID,Quantity 
			from [Order Details] 
			where ProductID=(select 
							ProductID 
							from Products 
							where ProductName='Chai')) od
	on o.OrderID=od.OrderID
group by o.CustomerID
having sum(od.Quantity)>50


--2- Sipariþler tablosunda 4 ten az kaydý olan firmalar

--Subquery'siz

select c.CompanyName  from Customers c
	join Orders o on c.CustomerID=o.CustomerID
group by c.CustomerID, c.CompanyName
having count(o.OrderID)<4

--subquery'li

select (select CompanyName from Customers c where c.CustomerID=o.CustomerID) [Company Name] from Orders o
group by CustomerID
having count(OrderID)<4

--3- Müþterilerin ilk gerçekleþtirdikleri sipariþ tarihleri

select 
	o.CustomerID,
	(Select c.CompanyName 
		from Customers c 
		where c.CustomerID=o.CustomerID ) [Company Name],
	OrderDate=min(o.OrderDate)
from Orders o
group by o.CustomerID

--4- 10249 Id li sipariþi hangi müþteri almýþtýr.

select
	c.CompanyName
from Customers c
where c.CustomerID = (select CustomerID from Orders where OrderID=10249)

--5- Ortalama satýþ miktarýnýn üzerine çýkan satýþlarým hangileridir

select
	OrderID
from [Order Details]
group by OrderID
having sum(Quantity)>(select avg(Quantity) from [Order Details])

select
	OrderID
from [Order Details]
group by OrderID
having sum(UnitPrice*Quantity*(1-Discount))>(select avg(UnitPrice*Quantity*(1-Discount)) from [Order Details])

--Hocanýn
select * from 
(select OrderID , sum(UnitPrice*Quantity*(1-Discount)) ToplamTutar from [Order Details] group by OrderID) t2
where ToplamTutar>
(select avg(ToplamTutar) from (select OrderID , sum(UnitPrice*Quantity*(1-Discount)) ToplamTutar from [Order Details] group by OrderID) t1)

--6- Çalýþanlarýmdan çalýþan yaþ ortalamasýnýn üzerinde olan çalýþanlarýmý listeleyiniz.

select * from Employees
where DATEDIFF(year,BirthDate,getdate()) > (select avg(DATEDIFF(year,BirthDate,getdate())) from Employees)

--Alternatif

declare @ortalama as int;
select @ortalama = avg(DATEDIFF(year,BirthDate,getdate())) from Employees

select * from Employees
where DATEDIFF(year,BirthDate,getdate()) > @ortalama

--7- En pahalý üründen daha yüksek kargo ücreti olan sipariþleri listeleyiniz.

select
	OrderID
from Orders o
where Freight>(select max(UnitPrice) from Products)

--8- Ortalama ürün fiyatý 40 tan büyük olan kategorileri listeleyiniz

select
	CategoryID,
	(select CategoryName from Categories where CategoryID=p.CategoryID) CategoryName
from Products p
group by CategoryID 
having avg(UnitPrice)>40

--9- 50 sipariþten fazla satýþ yapmýþ çalýþanlarýmý listeleyiniz

select
	EmployeeID,
	(select FirstName+' '+LastName from Employees e where e.EmployeeID=o.EmployeeID) Employee
from Orders o
group by EmployeeID
having count(EmployeeID)>50

--10- Kategori adýnýn ilk harfi B ile D arasýnda olan fiyatý 30 liradan fazla olan ürünler

select
	ProductName,
	UnitPrice
from Products p
where UnitPrice>30 and
	CategoryID in (select CategoryID from Categories where CategoryName like '[b-d]%')

--11- Hangi miþterilerimin verdiði sipariþ toplam tutarý 10000 den fazladýr.

select
	CustomerID,
	(select CompanyName from Customers c where c.CustomerID=o.CustomerID) [Customer]
from Orders o join (select OrderID, Quantity, UnitPrice from [Order Details]) od on o.OrderID=od.OrderID
group by CustomerID
having 	sum(od.Quantity*od.UnitPrice)>10000


--hocanýn
select
(select CompanyName from Customers where (CustomerID=o.CustomerID)) CompanyName
from Orders o
where OrderID in
				(select
					OrderID 
				from [Order Details]
				group by OrderID
				having sum(UnitPrice*Quantity*(1-Discount))>10000)

--12- 01.01.1996 -01.01.1997 tarihleri arasýnda en fazla hangü ürün satýlmýþtýr.

select top 1
	od.ProductID,
	(select ProductName from Products where ProductID=od.ProductID ) ProductName
from Products p join (select ProductID,OrderID from [Order Details]) od on p.ProductID=od.ProductID
				join (select OrderID, OrderDate from Orders where OrderDate between '1996-01-01' and '1997-01-01') o on od.OrderID=o.OrderID
group by od.ProductID
order by count(od.ProductID) desc

--Hocanýn

select top 1
	ProductID,
	(select ProductName from Products where ProductID=od.ProductID) ProductName,
	sum(Quantity) SatýþAdedi 
from [Order Details] od
where OrderID in (select OrderID 
				from Orders 
				where OrderDate between '1996' and '1997')
group by ProductID
order by SatýþAdedi desc

--13- Ürünlerin kendi fiyatlarýnýn tüm ürünlerin ortalama fiyatlarýna oranýný bulunuz.

select
	ProductName,
	(UnitPrice/(select avg(UnitPrice) from Products)) [Ratio]
from Products

--hocanýn


declare @ortalama2 as decimal (6,4)

select @ortalama2=avg(UnitPrice) from Products

select
	ProductName,
	@ortalama2 Ortalama,
	(UnitPrice/@ortalama2) [Ratio]
from Products
