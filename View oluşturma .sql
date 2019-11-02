
----------------------------------------------------------------------------------------
--WIEW	
------------------------------------------------------------------------------------------

--Sanal tabloalrdýr
--Verþi tutmaz tablolardan veri görüntüsü alýr
--parametre almaz, geriye deðer dönmez
--bir script yapýsý her lazým olduðunda yeniden yazmak yerine view yaparýz ve onu kullanýrýz.
--db ile taþýnabilir
--Viewlar hantaldýr yavaþ çalýþýr*
--bir tablo ile yapýlan her þeyi view'ler ilede yapabiliriz.(orderby kullanýrken bazý ozel drumlarý mevcut)

--view oluþturma
go
	create view NW_Name    
	as
	--script
	select * from Ogrenciler
go

--view çaðýrma
go
	select * from NW_Name
go


--view güncelleme deðiþtirme
go
	alter view NW_Name
	as
	select OgrenciAdi,OgrenciSoyadi from Ogrenciler
go

select * from NW_Name

--matematik dersi alan öðrencilerin velilerine mesaj atýlacaktýr. matematik dersi alan
--öðrencilerin velilerinin adý,soyadý ve telefon numarasý listesi

go
	alter view NW_MatematikDersiOgrenciVelileri
	as
	select distinct
		v.VeliAdi + ' ' + v.VeliSoyadi 'Veli Adý-Soyadý',
		v.Telefon 'Velinin Telefonu'
	from (select 
			od.OgrenciID
		from Dersler d
			join OgrenciDers od on d.DerslerID = od.DersID
		where DersAdi like '%Matematik%'
		) as TBL1
		join OgrenciVeli ov on TBL1.OgrenciID = ov.OgrenciID
		join veliler v on v.VelilerID = ov.VeliID
go

select * from NW_MatematikDersiOgrenciVelileri


select distinct
	*
from OgrenciDers od
join OgrenciVeli ov on ov.OgrenciID = od.OgrenciID
join Veliler v on v.VelilerID = ov.VeliID
where od.DersID in (select DerslerID from Dersler where DersAdi like '%Matematik%')
