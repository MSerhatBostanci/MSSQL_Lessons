
----------------------------------------------------------------------------------------
--WIEW	
------------------------------------------------------------------------------------------

--Sanal tabloalrd�r
--Ver�i tutmaz tablolardan veri g�r�nt�s� al�r
--parametre almaz, geriye de�er d�nmez
--bir script yap�s� her laz�m oldu�unda yeniden yazmak yerine view yapar�z ve onu kullan�r�z.
--db ile ta��nabilir
--Viewlar hantald�r yava� �al���r*
--bir tablo ile yap�lan her �eyi view'ler ilede yapabiliriz.(orderby kullan�rken baz� ozel drumlar� mevcut)

--view olu�turma
go
	create view NW_Name    
	as
	--script
	select * from Ogrenciler
go

--view �a��rma
go
	select * from NW_Name
go


--view g�ncelleme de�i�tirme
go
	alter view NW_Name
	as
	select OgrenciAdi,OgrenciSoyadi from Ogrenciler
go

select * from NW_Name

--matematik dersi alan ��rencilerin velilerine mesaj at�lacakt�r. matematik dersi alan
--��rencilerin velilerinin ad�,soyad� ve telefon numaras� listesi

go
	alter view NW_MatematikDersiOgrenciVelileri
	as
	select distinct
		v.VeliAdi + ' ' + v.VeliSoyadi 'Veli Ad�-Soyad�',
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
