use Northwind
-- 1) �r�nler tablosundaki ilk 10 kayd� listeleyin
select top 10 * from Products
-- 2) Bug�n�n tarihini kolon isimleri Y�l, Ay ve G�n olacak �ekilde listeleyiniz.
select datepart(year,getdate()) Y�l ,datepart(month,getdate()) Ay ,datepart(DAY,getdate()) G�n
-- 3) Kendi ya��n�z� ��kartan sorguyu yaz�n�z.
select DATEDIFF(year,'1993-05-26',GETDATE()) Yas
-- 4) Birebir firma sahibi ile temas kurulan tedarik�ileri listeleyin
select * from Suppliers where ContactTitle like 'Owner'
-- 5) Stokta mevcut olan ve fiyat� en b�y�k olan 3 �r�n� listeleyin
select top 3* from Products  where UnitsInStock!=0 order by UnitPrice desc 
-- 6) Hangi �al��anlar�m Almanca biliyor?
select * from Employees where Notes like '%GERMAN%'
-- 7) Stokta 40 tan fazla olan �r�nlerimin adlar� ve categoriIdleri?
select ProductName ProductName , CategoryID CategoryID from Products where UnitsInStock>40
-- 8) �smi 'chai' olanlar�n ya da kategorisi 3 olan ve 29 dan fazla sto�u olan �r�nleri listeleyin
select * from Products where ProductName like 'Chai' or (CategoryID = 3 and UnitsInStock>29)
-- 9) Sto�u 42 ile 100 aras�nda olan �r�nleri listeleyin
select * from Products where UnitsInStock between 42 and 100
-- 10) Do�um tarihleri 1961-01-01 ve 2010-10-10 tarihleri aras�nda ve kad�n �al��anlar�m� listeleyin
select * from Employees where (TitleOfCourtesy like '%Ms%' or TitleOfCourtesy like '%Mrs%') and (BirthDate between '1961-01-01' and '2010-10-10')
-- 11) Ya�ad��� �ehir London ve Seattle olmayan �al��anlar�m�z kimlerdir?
select * from Employees where City not like 'London' and City not like 'Seattle'
-- 12) Ad�nda ve soyad�nda 'e' harfi ge�meyen �al��anlar�m�z kimlerdir?
select * from Employees where LastName not like '%e%' and FirstName not like '%e%'
-- 13) T�m m��terilerim olan �irketlerin isimlerini ve isimlerinin ilk ve son karakterlerini aralar�nda 1 bo�luk olacak �ekilde listeleyin.
select CompanyName, left (CompanyName,1) + ' ' + right (CompanyName,1) FirstLastLetter from Customers 
-- 14) Stok miktar� kritik seviyeye veya alt�na d��mesine ra�men hala sipari�ini vermedi�im �r�nler hangileridir?
select * from Products where UnitsInStock+UnitsOnOrder<ReorderLevel
-- 15) �i�ede satt���m �r�nler nelerdir?
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
-- 21) Fiyat� k�s�ratl� �r�nleri bulun.
select * from Products where UnitPrice not like '%.00%'
-- 22) Hepsini satt���mda en �ok ciro yapaca��m aktif �r�nlerden ilk 5 tanesi hangisidir?
select top 5 * from Products where Discontinued = 0 order by UnitPrice*UnitsInStock desc 
-- 23) Art�k sat��ta olmayan en pahal� �r�n�m hangisidir?
select top 1 * from Products where Discontinued=1 order by UnitPrice desc  
-- 24) Sto�u olmas�na ra�men art�k sat���n� yapmad���m �r�nler hangisidir?
select * from Products where Discontinued=1 and UnitsInStock>0
-- 25) �smi birden fazla kelimeden olu�an �r�nler hangileridir?
select * from Products where ProductName like '% %'
-- 26) Fax �ekemeyece�im tedarik�ilerim hangileridir?
select * from Suppliers where Fax is null
-- 27) Tedarik�ilerim hangi �lkelerden?
select CompanyName , Country from Suppliers
-- 28) Bolge bilgisi olmayan sirketlerin listesini raporlayiniz...
select * from Customers where Region is null
-- 29) Region bilgisi olan personellerimi gosteriniz...
select *from Employees where Region is not null
-- 30) CategoryID'si 5 olan, urun bedeli 20'den buyuk 300'den kucuk olan, stok durumu null olmayan urunlerimin adlarini ve id'lerini gosteriniz...
select ProductName , ProductID from Products where CategoryID=5 and (UnitPrice<300 and UnitPrice>20) and UnitsInStock>0
-- 31) 'Dumon' ya da 'Alfki' idlerine sahip olan musterilerden alinmis, 1 nolu personelin onayladigi, 3 nolu kargo firmasi tarafindan gonderilmis ve ShipRegion'u null olan siparisleri gosteriniz...
select * from Orders where (CustomerID like 'DUMON' or CustomerID like 'ALFKI') and EmployeeID=1 and ShipVia=3 and ShipRegion is null
-- 32) Teslimat� Amerika'ya ge� kalan sipari�ler hangileridir?
select * from Orders where RequiredDate<ShippedDate and ShipCountry='USA'
-- 33) En ya�l� �al��an�m�n ad� ve ileti�im bilgileri nelerdir?
select top 1 FirstName,LastName,HomePhone from Employees order by BirthDate desc
-- 34) Do�um tarihi bu y�l i�in hen�z ge�memi� �al��anlar�mdan do�um tarihi en yak�n olan �al��an�m� bulun
select top 1* from Employees where datepart(DAYOFYEAR,BirthDate)>DATEPART(DAYOFYEAR,GETDATE()) order by DATEPART(DAYOFYEAR,BirthDate)
-- 35) Londra'da ya�ayan erkek �al��anlar�n �irketteki pozisyonlar� nelerdir?
select LastName,FirstName,Title from Employees where City='London' and TitleOfCourtesy='Mr.'
-- 36) �irketin sahibi kimdir?
select * from Employees where ReportsTo is null
-- 37) Patron d���nda hangi �al��anlar Frans�zca biliyor?
select *from Employees where Notes like '%French%' and ReportsTo is null
-- 38) Teslimat� Almanya'ya ge� kalan sipari�ler hangileridir?
select * from Orders where ShipCountry like '%Germany%' and (ShippedDate>RequiredDate)
-- 39) Hen�z teslimat� ger�ekle�memi� sipari�ler hangileridir?
select * from Orders where ShippedDate is null	
-- 40) Son teslim edilen 10 siparisi gosteriniz...
select top 10 *from Orders order by ShippedDate desc
-- 41) 1 dolar�n alt�nda kargo �creti olan sipari�ler hangileridir?
select * from Orders where Freight<1
-- 42) Kargo �creti ucuz diye hala teslim etmedi�im sipari�ler hangileridir? (1 dolar�n alt�ndaki kargo �creti)
select * from Orders where Freight<1 and ShippedDate is null
-- 43) En pahal� �ekilde kargolanan sipari� hangisidir?
select top 1 * from Orders where ShippedDate is not null order by Freight desc  
-- 44) Son g�n�nde teslim edilen sipari�ler hangileridir?
select * from Orders where RequiredDate=ShippedDate
-- 45) 01.11.1997 - 06.06.1998 tarihleri arasindaki siparisleri gosteriniz...
select * from Orders where OrderDate between '1997-11-01'and '1998-06-06'
-- 46) Bas harfi A olan, stoklarda bulunan, 10-250 dolar arasi ucreti olan urunleri alfabetik olarak siralay�n�z..
select * from Products where (ProductName like 'A%') and (UnitsInStock>0) and (UnitPrice between 10 and 250)
-- 47) Carsamba gunu alinan, kargo ucreti 20-75$ arasi olan, shipdate'i null olmayan siparislerin ID'lerini buyukten kucuge siralayiniz...
select OrderID from Orders where (DATENAME(WEEKDAY,ShippedDate)='Wednesday') and (Freight between 20 and 75) and (ShipAddress is not null) order by OrderID desc 
-- 48) Sto�umda hi� bulunmay�p tedarik�ilerime sipari� verdi�im �r�nler hangileridir?
select * from Products where UnitsInStock=0 and UnitsOnOrder>0
-- 49) Sto�umda bulunup sat��� durdurdu�um �r�nler hangileridir? 
select * from Products where UnitsInStock>0 and Discontinued=1
-- 50) Y�ksek lisans yapan �al��anlar�m hangileridir?
select * from Employees where Notes like '%Mba%' or Notes like '%ma %' or TitleOfCourtesy = 'Dr.'