
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
	where d.DoktorUnvanID=du.DoktorUnvanlariID )'Doktor �nvan�'  --�� select (Sub-query)
from Doktorlar d

--iki tabloyu ba�alrken orta kolonlar� where ile i� select i�inde ba�lamam�z gerekli
--i� select ile sadece bir kolon �a��rabiliriz. birden falza kolon + operat�r� ile yapabilriiz.
--ana select ile sadece ana selecte ait tablo kolonlar� �a��r�labilir.
--Birden fazla i� select kullanmak i�in 1. i� selectten sonra "," ile ikinci sub-query yaz�labilir

--hasta ad� soyad�, randevu tarihi veren sub-query sorgusu(1-* ili�kisi oldu�undan sonus ili�ki ana sorgu olmal�d�r)

select
	(select h.HastaAdi + space(1) + h.HastaSoyadi
	 from Hastalar h
	 where r.HastaID = h.HastalarID)  'Hasta Ad�-Soyad�',
	 r.RandevuTarihi
from Randevular r

-------------------------------------------------------------------------------
use OkulSabahDB

--��renci ad�,soyad�,s�n�f no ve �ubesini veren sub-query sorugusu

select
	o.OgrenciAdi + ' ' + o.OgrenciSoyadi '��renci',
	(select	
		S�n�fNo + ' ' + s.S�n�fSubesi
	from S�n�flar s 
	where s.S�n�flarID = o.SinifID) 'S�n�f�'
from Ogrenciler o
where o.OgrenciAdi is not null or
	o.OgrenciSoyadi is not null

--i� select ile �a��r�lan ana select ile ortak olan verileri getirir. ama ana select tablosunda b�t�n verileri getirir.
--Bu nedenle ana selecet tablosunun kolonlar�yla beraber �a��r�lan i� select kolonu kar��s�nda null de�erler gelir.


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

--ortalaman�n fiyat�n �zerinde olan �r�nler
select
	*
from Products
where UnitPrice >(Select 
					avg(UnitPrice)
				  from Products)


--en son satolan �r�n

select top 1
	--od.OrderID,
	(select
		o.OrderDate
	from Orders o 
	where od.OrderID = o.OrderID) 'Tarih',
	(select
		p.ProductName
	from Products p 
	where p.ProductID = od.ProductID) '�r�n Ad�'
from [Order Details] od
order by Tarih desc



select * from Orders order by OrderDate desc

select * from [Order Details] where OrderID = (select top 1 OrderID from Orders order by OrderDate desc)



------------------------------------------------------------------------------------------------------
use OkulSabahDB


select 
	o.OgrenciAdi + ' ' + o.OgrenciSoyadi '��renci Ad�',
	count(ov.OgrenciVeliID) 'Veli Say�s�'
from Ogrenciler o
	join OgrenciVeli ov on ov.OgrenciID = o.OgrencilerID
group by o.OgrenciAdi, o.OgrenciSoyadi
having count(ov.OgrenciVeliID) >1


--birden fazla verisli olan ��rencilerin veli listesi

select
	SanalTablo.[��renci Ad�],
	v.VeliAdi + ' ' + v.VeliSoyadi 'Veli Ad�'
from (select
		O.OgrencilerID, 
		o.OgrenciAdi + ' ' + o.OgrenciSoyadi '��renci Ad�',
		count(ov.OgrenciVeliID) 'Veli Say�s�'
	from Ogrenciler o
		join OgrenciVeli ov on ov.OgrenciID = o.OgrencilerID
	group by o.OgrencilerID,o.OgrenciAdi, o.OgrenciSoyadi
	having count(ov.OgrenciVeliID) >1
	) as SanalTablo
	join OgrenciVeli ov on ov.OgrenciID = SanalTablo.OgrencilerID
	join Veliler v on v.VelilerID = ov.VeliID


--7 den fazla ders alan ��rencilerin ad�, soyad� ve adald��� derslerin listesi

--1.yol
select
	o.OgrenciAdi + ' ' + o.OgrenciSoyadi,
	count(o.OgrencilerID)
from Ogrenciler o
	join OgrenciDers od on od.OgrenciID = o.OgrencilerID
group by o.OgrenciAdi,o.OgrenciSoyadi
having count(od.OgrenciDersID)>7


select
	[Sanal Tablo].[��renci Ad�-Soyad�],
	d.DersAdi
from (select
		o.OgrencilerID,
		o.OgrenciAdi + ' ' + o.OgrenciSoyadi'��renci Ad�-Soyad�',
		count(o.OgrencilerID) as 'Ders Say�s�'
	from Ogrenciler o
		join OgrenciDers od on od.OgrenciID = o.OgrencilerID
	group by o.OgrenciAdi,o.OgrenciSoyadi,o.OgrencilerID
	having count(od.OgrenciDersID)>7) as [Sanal Tablo]
	join OgrenciDers od on [Sanal Tablo].OgrencilerID = od.OgrenciID
	join Dersler d on d.DerslerID = od.DersID

	

--15den fazla ��renci kayd�nda g�rev yapan kullan�clar�n ad�, gorev ald��� ogrencinin ad� soyad� listesi

--1.ad�m
select 
	k.KullanicilarID,
	k.KullaniciAdi,
	count(o.OgrencilerID) as 'Ogrenci Say�s�'
from Kullanicilar k
	join Ogrenciler as o on o.KullaniciID = k.KullanicilarID
group by k.KullanicilarID,k.KullaniciAdi
having count(o.OgrencilerID)>15


--2.ad�m
select 
	[Sanal Tablo].KullaniciAdi,
	o.OgrenciAdi + ' ' + o.OgrenciSoyadi '��renci Ad�-Soyad�'
from (select 
		k.KullanicilarID,
		k.KullaniciAdi,
		count(o.OgrencilerID) as 'Ogrenci Say�s�'
	from Kullanicilar k
		join Ogrenciler as o on o.KullaniciID = k.KullanicilarID
	group by k.KullanicilarID,k.KullaniciAdi
	having count(o.OgrencilerID)>15) as [Sanal Tablo]
	join Ogrenciler as o on [Sanal Tablo].KullanicilarID = o.KullaniciID
group by [Sanal Tablo].KullaniciAdi,o.OgrenciAdi, o .OgrenciSoyadi


--------------------------------------------------------------------------------------------------------

use HastahaneDB

-- 5 -15 aras� randevusu olan doktorlar�n hasta listesi

select
	d.DoktorlarID,
	d.DoktorAdi + ' ' + d.DoktorSoyadi as 'Doktor Ad�-Soyad�'
from Doktorlar d
	join Randevular r on d.DoktorlarID = r.DoktorID
group by d.DoktorlarID, d.DoktorAdi, d.DoktorSoyadi
having count(r.RandevularID) between 6 and 14


select
	[Sanal Tablo].[Doktor Ad�-Soyad�],
	h.HastaAdi + ' ' + h.HastaSoyadi as 'Hasta Ad�-Soyad�'
from (select
		d.DoktorlarID,
		d.DoktorAdi + ' ' + d.DoktorSoyadi as 'Doktor Ad�-Soyad�'
	from Doktorlar d
		join Randevular r on d.DoktorlarID = r.DoktorID
	group by d.DoktorlarID, d.DoktorAdi, d.DoktorSoyadi
	having count(r.RandevularID) between 6 and 14) as [Sanal Tablo]
	join Randevular as r on [Sanal Tablo].DoktorlarID = r.DoktorID
	join Hastalar as h on r.HastaID = h.HastalarID
order by [Doktor Ad�-Soyad�]

