use Northwind
-- 1) Ürünler tablosundaki ilk 10 kaydý listeleyin
select top 10 * from Products
-- 2) Bugünün tarihini kolon isimleri Yýl, Ay ve Gün olacak þekilde listeleyiniz.
select datepart(year,getdate()) Yýl ,datepart(month,getdate()) Ay ,datepart(DAY,getdate()) Gün
-- 3) Kendi yaþýnýzý çýkartan sorguyu yazýnýz.
select DATEDIFF(year,'1993-05-26',GETDATE()) Yas
-- 4) Birebir firma sahibi ile temas kurulan tedarikçileri listeleyin
select * from Suppliers where ContactTitle like 'Owner'
-- 5) Stokta mevcut olan ve fiyatý en büyük olan 3 ürünü listeleyin
select top 3* from Products  where UnitsInStock!=0 order by UnitPrice desc 
-- 6) Hangi çalýþanlarým Almanca biliyor?
select * from Employees where Notes like '%GERMAN%'
-- 7) Stokta 40 tan fazla olan ürünlerimin adlarý ve categoriIdleri?
select ProductName ProductName , CategoryID CategoryID from Products where UnitsInStock>40
-- 8) Ýsmi 'chai' olanlarýn ya da kategorisi 3 olan ve 29 dan fazla stoðu olan ürünleri listeleyin
select * from Products where ProductName like 'Chai' or (CategoryID = 3 and UnitsInStock>29)
-- 9) Stoðu 42 ile 100 arasýnda olan ürünleri listeleyin
select * from Products where UnitsInStock between 42 and 100
-- 10) Doðum tarihleri 1961-01-01 ve 2010-10-10 tarihleri arasýnda ve kadýn çalýþanlarýmý listeleyin
select * from Employees where (TitleOfCourtesy like '%Ms%' or TitleOfCourtesy like '%Mrs%') and (BirthDate between '1961-01-01' and '2010-10-10')
-- 11) Yaþadýðý þehir London ve Seattle olmayan çalýþanlarýmýz kimlerdir?
select * from Employees where City not like 'London' and City not like 'Seattle'
-- 12) Adýnda ve soyadýnda 'e' harfi geçmeyen çalýþanlarýmýz kimlerdir?
select * from Employees where LastName not like '%e%' and FirstName not like '%e%'
-- 13) Tüm müþterilerim olan þirketlerin isimlerini ve isimlerinin ilk ve son karakterlerini aralarýnda 1 boþluk olacak þekilde listeleyin.
select CompanyName, left (CompanyName,1) + ' ' + right (CompanyName,1) FirstLastLetter from Customers 
-- 14) Stok miktarý kritik seviyeye veya altýna düþmesine raðmen hala sipariþini vermediðim ürünler hangileridir?
select * from Products where UnitsInStock+UnitsOnOrder<ReorderLevel
-- 15) Þiþede sattýðým ürünler nelerdir?
select * from Products where QuantityPerUnit like '%bottles%'
-- 16) 30 dolardan fazla ucretli urunlerimi getir..
select * from Products where UnitPrice>30
-- 17) Londra'da yasayan personellerimn adini soyadini gosteriniz...
select FirstName,LastName from Employees where City like 'London'
-- 18) CategoryID'si 5 olmayan urunleri listeleyiniz..
select * from Products where CategoryID not like 5
-- 19) 01.01.1993'ten sonra ise giren personelleri listeleyiniz...
select * from Employees where HireDate > '01.01.1993'
-- 20) Mart ayinda alinmis olan siparislerin SiparisID'sini ve SiparisTarihini gosteriniz..
select OrderID , OrderDate from Orders where DATEPART(month,OrderDate) = 03
-- 21) Fiyatý küsüratlý ürünleri bulun.
select * from Products where UnitPrice not like '%.00%'
-- 22) Hepsini sattýðýmda en çok ciro yapacaðým aktif ürünlerden ilk 5 tanesi hangisidir?
select top 5 * from Products where Discontinued = 0 order by UnitPrice*UnitsInStock desc 
-- 23) Artýk satýþta olmayan en pahalý ürünüm hangisidir?
select top 1 * from Products where Discontinued=1 order by UnitPrice desc  
-- 24) Stoðu olmasýna raðmen artýk satýþýný yapmadýðým ürünler hangisidir?
select * from Products where Discontinued=1 and UnitsInStock>0
-- 25) Ýsmi birden fazla kelimeden oluþan ürünler hangileridir?
select * from Products where ProductName like '% %'
-- 26) Fax çekemeyeceðim tedarikçilerim hangileridir?
select * from Suppliers where Fax is null
-- 27) Tedarikçilerim hangi ülkelerden?
select CompanyName , Country from Suppliers
-- 28) Bolge bilgisi olmayan sirketlerin listesini raporlayiniz...
select * from Customers where Region is null
-- 29) Region bilgisi olan personellerimi gosteriniz...
select *from Employees where Region is not null
-- 30) CategoryID'si 5 olan, urun bedeli 20'den buyuk 300'den kucuk olan, stok durumu null olmayan urunlerimin adlarini ve id'lerini gosteriniz...
select ProductName , ProductID from Products where CategoryID=5 and (UnitPrice<300 and UnitPrice>20) and UnitsInStock>0
-- 31) 'Dumon' ya da 'Alfki' idlerine sahip olan musterilerden alinmis, 1 nolu personelin onayladigi, 3 nolu kargo firmasi tarafindan gonderilmis ve ShipRegion'u null olan siparisleri gosteriniz...
select * from Orders where (CustomerID like 'DUMON' or CustomerID like 'ALFKI') and EmployeeID=1 and ShipVia=3 and ShipRegion is null
-- 32) Teslimatý Amerika'ya geç kalan sipariþler hangileridir?
select * from Orders where RequiredDate<ShippedDate and ShipCountry='USA'
-- 33) En yaþlý çalýþanýmýn adý ve iletiþim bilgileri nelerdir?
select top 1 FirstName,LastName,HomePhone from Employees order by BirthDate desc
-- 34) Doðum tarihi bu yýl için henüz geçmemiþ çalýþanlarýmdan doðum tarihi en yakýn olan çalýþanýmý bulun
select top 1* from Employees where datepart(DAYOFYEAR,BirthDate)>DATEPART(DAYOFYEAR,GETDATE()) order by DATEPART(DAYOFYEAR,BirthDate)
-- 35) Londra'da yaþayan erkek çalýþanlarýn þirketteki pozisyonlarý nelerdir?
select LastName,FirstName,Title from Employees where City='London' and TitleOfCourtesy='Mr.'
-- 36) Þirketin sahibi kimdir?
select * from Employees where ReportsTo is null
-- 37) Patron dýþýnda hangi çalýþanlar Fransýzca biliyor?
select *from Employees where Notes like '%French%' and ReportsTo is null
-- 38) Teslimatý Almanya'ya geç kalan sipariþler hangileridir?
select * from Orders where ShipCountry like '%Germany%' and (ShippedDate>RequiredDate)
-- 39) Henüz teslimatý gerçekleþmemiþ sipariþler hangileridir?
select * from Orders where ShippedDate is null	
-- 40) Son teslim edilen 10 siparisi gosteriniz...
select top 10 *from Orders order by ShippedDate desc
-- 41) 1 dolarýn altýnda kargo ücreti olan sipariþler hangileridir?
select * from Orders where Freight<1
-- 42) Kargo ücreti ucuz diye hala teslim etmediðim sipariþler hangileridir? (1 dolarýn altýndaki kargo ücreti)
select * from Orders where Freight<1 and ShippedDate is null
-- 43) En pahalý þekilde kargolanan sipariþ hangisidir?
select top 1 * from Orders where ShippedDate is not null order by Freight desc  
-- 44) Son gününde teslim edilen sipariþler hangileridir?
select * from Orders where RequiredDate=ShippedDate
-- 45) 01.11.1997 - 06.06.1998 tarihleri arasindaki siparisleri gosteriniz...
select * from Orders where OrderDate between '1997-11-01'and '1998-06-06'
-- 46) Bas harfi A olan, stoklarda bulunan, 10-250 dolar arasi ucreti olan urunleri alfabetik olarak siralayýnýz..
select * from Products where (ProductName like 'A%') and (UnitsInStock>0) and (UnitPrice between 10 and 250)
-- 47) Carsamba gunu alinan, kargo ucreti 20-75$ arasi olan, shipdate'i null olmayan siparislerin ID'lerini buyukten kucuge siralayiniz...
select OrderID from Orders where (DATENAME(WEEKDAY,ShippedDate)='Wednesday') and (Freight between 20 and 75) and (ShipAddress is not null) order by OrderID desc 
-- 48) Stoðumda hiç bulunmayýp tedarikçilerime sipariþ verdiðim ürünler hangileridir?
select * from Products where UnitsInStock=0 and UnitsOnOrder>0
-- 49) Stoðumda bulunup satýþý durdurduðum ürünler hangileridir? 
select * from Products where UnitsInStock>0 and Discontinued=1
-- 50) Yüksek lisans yapan çalýþanlarým hangileridir?
select * from Employees where Notes like '%Mba%' or Notes like '%ma %' or TitleOfCourtesy = 'Dr.'