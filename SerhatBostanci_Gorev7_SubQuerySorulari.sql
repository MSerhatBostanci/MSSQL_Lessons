------------------------------------SubQuery �rnekleri-------------------------
--1- Chai �r�n�nden toplam 50 adetten fazla sipari� vermi� m��terilerimin listesi nedir.

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


--2- Sipari�ler tablosunda 4 ten az kayd� olan firmalar

--Subquery'siz

select c.CompanyName  from Customers c
	join Orders o on c.CustomerID=o.CustomerID
group by c.CustomerID, c.CompanyName
having count(o.OrderID)<4

--subquery'li

select (select CompanyName from Customers c where c.CustomerID=o.CustomerID) [Company Name] from Orders o
group by CustomerID
having count(OrderID)<4

--3- M��terilerin ilk ger�ekle�tirdikleri sipari� tarihleri

select 
	o.CustomerID,
	(Select c.CompanyName 
		from Customers c 
		where c.CustomerID=o.CustomerID ) [Company Name],
	OrderDate=min(o.OrderDate)
from Orders o
group by o.CustomerID

--4- 10249 Id li sipari�i hangi m��teri alm��t�r.

select
	c.CompanyName
from Customers c
where c.CustomerID = (select CustomerID from Orders where OrderID=10249)

--5- Ortalama sat�� miktar�n�n �zerine ��kan sat��lar�m hangileridir

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

--Hocan�n
select * from 
(select OrderID , sum(UnitPrice*Quantity*(1-Discount)) ToplamTutar from [Order Details] group by OrderID) t2
where ToplamTutar>
(select avg(ToplamTutar) from (select OrderID , sum(UnitPrice*Quantity*(1-Discount)) ToplamTutar from [Order Details] group by OrderID) t1)

--6- �al��anlar�mdan �al��an ya� ortalamas�n�n �zerinde olan �al��anlar�m� listeleyiniz.

select * from Employees
where DATEDIFF(year,BirthDate,getdate()) > (select avg(DATEDIFF(year,BirthDate,getdate())) from Employees)

--Alternatif

declare @ortalama as int;
select @ortalama = avg(DATEDIFF(year,BirthDate,getdate())) from Employees

select * from Employees
where DATEDIFF(year,BirthDate,getdate()) > @ortalama

--7- En pahal� �r�nden daha y�ksek kargo �creti olan sipari�leri listeleyiniz.

select
	OrderID
from Orders o
where Freight>(select max(UnitPrice) from Products)

--8- Ortalama �r�n fiyat� 40 tan b�y�k olan kategorileri listeleyiniz

select
	CategoryID,
	(select CategoryName from Categories where CategoryID=p.CategoryID) CategoryName
from Products p
group by CategoryID 
having avg(UnitPrice)>40

--9- 50 sipari�ten fazla sat�� yapm�� �al��anlar�m� listeleyiniz

select
	EmployeeID,
	(select FirstName+' '+LastName from Employees e where e.EmployeeID=o.EmployeeID) Employee
from Orders o
group by EmployeeID
having count(EmployeeID)>50

--10- Kategori ad�n�n ilk harfi B ile D aras�nda olan fiyat� 30 liradan fazla olan �r�nler

select
	ProductName,
	UnitPrice
from Products p
where UnitPrice>30 and
	CategoryID in (select CategoryID from Categories where CategoryName like '[b-d]%')

--11- Hangi mi�terilerimin verdi�i sipari� toplam tutar� 10000 den fazlad�r.

select
	CustomerID,
	(select CompanyName from Customers c where c.CustomerID=o.CustomerID) [Customer]
from Orders o join (select OrderID, Quantity, UnitPrice from [Order Details]) od on o.OrderID=od.OrderID
group by CustomerID
having 	sum(od.Quantity*od.UnitPrice)>10000


--hocan�n
select
(select CompanyName from Customers where (CustomerID=o.CustomerID)) CompanyName
from Orders o
where OrderID in
				(select
					OrderID 
				from [Order Details]
				group by OrderID
				having sum(UnitPrice*Quantity*(1-Discount))>10000)

--12- 01.01.1996 -01.01.1997 tarihleri aras�nda en fazla hang� �r�n sat�lm��t�r.

select top 1
	od.ProductID,
	(select ProductName from Products where ProductID=od.ProductID ) ProductName
from Products p join (select ProductID,OrderID from [Order Details]) od on p.ProductID=od.ProductID
				join (select OrderID, OrderDate from Orders where OrderDate between '1996-01-01' and '1997-01-01') o on od.OrderID=o.OrderID
group by od.ProductID
order by count(od.ProductID) desc

--Hocan�n

select top 1
	ProductID,
	(select ProductName from Products where ProductID=od.ProductID) ProductName,
	sum(Quantity) Sat��Adedi 
from [Order Details] od
where OrderID in (select OrderID 
				from Orders 
				where OrderDate between '1996' and '1997')
group by ProductID
order by Sat��Adedi desc

--13- �r�nlerin kendi fiyatlar�n�n t�m �r�nlerin ortalama fiyatlar�na oran�n� bulunuz.

select
	ProductName,
	(UnitPrice/(select avg(UnitPrice) from Products)) [Ratio]
from Products

--hocan�n


declare @ortalama2 as decimal (6,4)

select @ortalama2=avg(UnitPrice) from Products

select
	ProductName,
	@ortalama2 Ortalama,
	(UnitPrice/@ortalama2) [Ratio]
from Products
