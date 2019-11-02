
---------------------------------------------------------------------------------------------------
--SUBQUERY
---------------------------------------------------------------------------------------------------
use HastahaneDB

select 
	*                   --Ana Select
from Doktorlar


select
	d.DoktorAdi + space(1) + d.DoktorSoyadi,
	(select 
		du.UnvanAdi 
	from DoktorUnvanlari du
	where d.DoktorUnvanID=du.DoktorUnvanlariID )'Doktor Ünvaný'  --Ýç select (Sub-query)
from Doktorlar d

--iki tabloyu baðalrken orta kolonlarý where ile iç select içinde baðlamamýz gerekli
--iç select ile sadece bir kolon çaðýrabiliriz. birden falza kolon + operatörü ile yapabilriiz.
--ana select ile sadece ana selecte ait tablo kolonlarý çaðýrýlabilir.
--Birden fazla iç select kullanmak için 1. iç selectten sonra "," ile ikinci sub-query yazýlabilir

--hasta adý soyadý, randevu tarihi veren sub-query sorgusu(1-* iliþkisi olduðundan sonus iliþki ana sorgu olmalýdýr)

select
	(select h.HastaAdi + space(1) + h.HastaSoyadi
	 from Hastalar h
	 where r.HastaID = h.HastalarID)  'Hasta Adý-Soyadý',
	 r.RandevuTarihi
from Randevular r

-------------------------------------------------------------------------------
use OkulSabahDB

--Öðrenci adý,soyadý,sýnýf no ve þubesini veren sub-query sorugusu

select
	o.OgrenciAdi + ' ' + o.OgrenciSoyadi 'Öðrenci',
	(select	
		SýnýfNo + ' ' + s.SýnýfSubesi
	from Sýnýflar s 
	where s.SýnýflarID = o.SinifID) 'Sýnýfý'
from Ogrenciler o
where o.OgrenciAdi is not null or
	o.OgrenciSoyadi is not null

--iç select ile çaðýrýlan ana select ile ortak olan verileri getirir. ama ana select tablosunda bütün verileri getirir.
--Bu nedenle ana selecet tablosunun kolonlarýyla beraber çaðýrýlan iç select kolonu karþýsýnda null deðerler gelir.


-------------------------------------------------------------------------------------------------------------------------------

use Northwind

select
	*
from Products 
where UnitPrice > 20

--
select
	max(UnitPrice)
from Products
--
select
	avg(UnitPrice)
from Products

--ortalamanýn fiyatýn üzerinde olan ürünler
select
	*
from Products
where UnitPrice >(Select 
					avg(UnitPrice)
				  from Products)


--en son satolan ürün

select top 1
	--od.OrderID,
	(select
		o.OrderDate
	from Orders o 
	where od.OrderID = o.OrderID) 'Tarih',
	(select
		p.ProductName
	from Products p 
	where p.ProductID = od.ProductID) 'Ürün Adý'
from [Order Details] od
order by Tarih desc



select * from Orders order by OrderDate desc

select * from [Order Details] where OrderID = (select top 1 OrderID from Orders order by OrderDate desc)



------------------------------------------------------------------------------------------------------
use OkulSabahDB


select 
	o.OgrenciAdi + ' ' + o.OgrenciSoyadi 'Öðrenci Adý',
	count(ov.OgrenciVeliID) 'Veli Sayýsý'
from Ogrenciler o
	join OgrenciVeli ov on ov.OgrenciID = o.OgrencilerID
group by o.OgrenciAdi, o.OgrenciSoyadi
having count(ov.OgrenciVeliID) >1


--birden fazla verisli olan öðrencilerin veli listesi

select
	SanalTablo.[Öðrenci Adý],
	v.VeliAdi + ' ' + v.VeliSoyadi 'Veli Adý'
from (select
		O.OgrencilerID, 
		o.OgrenciAdi + ' ' + o.OgrenciSoyadi 'Öðrenci Adý',
		count(ov.OgrenciVeliID) 'Veli Sayýsý'
	from Ogrenciler o
		join OgrenciVeli ov on ov.OgrenciID = o.OgrencilerID
	group by o.OgrencilerID,o.OgrenciAdi, o.OgrenciSoyadi
	having count(ov.OgrenciVeliID) >1
	) as SanalTablo
	join OgrenciVeli ov on ov.OgrenciID = SanalTablo.OgrencilerID
	join Veliler v on v.VelilerID = ov.VeliID


--7 den fazla ders alan öðrencilerin adý, soyadý ve adaldýðý derslerin listesi

--1.yol
select
	o.OgrenciAdi + ' ' + o.OgrenciSoyadi,
	count(o.OgrencilerID)
from Ogrenciler o
	join OgrenciDers od on od.OgrenciID = o.OgrencilerID
group by o.OgrenciAdi,o.OgrenciSoyadi
having count(od.OgrenciDersID)>7


select
	[Sanal Tablo].[Öðrenci Adý-Soyadý],
	d.DersAdi
from (select
		o.OgrencilerID,
		o.OgrenciAdi + ' ' + o.OgrenciSoyadi'Öðrenci Adý-Soyadý',
		count(o.OgrencilerID) as 'Ders Sayýsý'
	from Ogrenciler o
		join OgrenciDers od on od.OgrenciID = o.OgrencilerID
	group by o.OgrenciAdi,o.OgrenciSoyadi,o.OgrencilerID
	having count(od.OgrenciDersID)>7) as [Sanal Tablo]
	join OgrenciDers od on [Sanal Tablo].OgrencilerID = od.OgrenciID
	join Dersler d on d.DerslerID = od.DersID

	

--15den fazla öðrenci kaydýnda görev yapan kullanýclarýn adý, gorev aldýðý ogrencinin adý soyadý listesi

--1.adým
select 
	k.KullanicilarID,
	k.KullaniciAdi,
	count(o.OgrencilerID) as 'Ogrenci Sayýsý'
from Kullanicilar k
	join Ogrenciler as o on o.KullaniciID = k.KullanicilarID
group by k.KullanicilarID,k.KullaniciAdi
having count(o.OgrencilerID)>15


--2.adým
select 
	[Sanal Tablo].KullaniciAdi,
	o.OgrenciAdi + ' ' + o.OgrenciSoyadi 'Öðrenci Adý-Soyadý'
from (select 
		k.KullanicilarID,
		k.KullaniciAdi,
		count(o.OgrencilerID) as 'Ogrenci Sayýsý'
	from Kullanicilar k
		join Ogrenciler as o on o.KullaniciID = k.KullanicilarID
	group by k.KullanicilarID,k.KullaniciAdi
	having count(o.OgrencilerID)>15) as [Sanal Tablo]
	join Ogrenciler as o on [Sanal Tablo].KullanicilarID = o.KullaniciID
group by [Sanal Tablo].KullaniciAdi,o.OgrenciAdi, o .OgrenciSoyadi


--------------------------------------------------------------------------------------------------------

use HastahaneDB

-- 5 -15 arasý randevusu olan doktorlarýn hasta listesi

select
	d.DoktorlarID,
	d.DoktorAdi + ' ' + d.DoktorSoyadi as 'Doktor Adý-Soyadý'
from Doktorlar d
	join Randevular r on d.DoktorlarID = r.DoktorID
group by d.DoktorlarID, d.DoktorAdi, d.DoktorSoyadi
having count(r.RandevularID) between 6 and 14


select
	[Sanal Tablo].[Doktor Adý-Soyadý],
	h.HastaAdi + ' ' + h.HastaSoyadi as 'Hasta Adý-Soyadý'
from (select
		d.DoktorlarID,
		d.DoktorAdi + ' ' + d.DoktorSoyadi as 'Doktor Adý-Soyadý'
	from Doktorlar d
		join Randevular r on d.DoktorlarID = r.DoktorID
	group by d.DoktorlarID, d.DoktorAdi, d.DoktorSoyadi
	having count(r.RandevularID) between 6 and 14) as [Sanal Tablo]
	join Randevular as r on [Sanal Tablo].DoktorlarID = r.DoktorID
	join Hastalar as h on r.HastaID = h.HastalarID
order by [Doktor Adý-Soyadý]

