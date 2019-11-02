
--STORED PROCEDURE

/*

create Procedure <ProsedurAdi>
(
@Degiskenadi <Degiskentipi>
@Degiskenadi <Degiskentipi>
as
<Sorgu>
)

*/

--D��ar�dan girilen kategori ad� ve a��klamaya g�re kategoriler
--tablosuna insert ilkemi ger�ekletiren sp yazal�m


Create proc sp_Add_Category
(
	@katadi nvarchar(50),
	@aciklamasi nvarchar (max)
)
as
	insert into Categories
	(CategoryName, Description)
	values
	(@katadi,@aciklamasi)

exec sp_Add_Category Serhat,Bostanc�


select * from Categories


--d��ar�dan girilen miktar kadar t�m �r�nlere zam yapan sp yazal�m

create proc sp_�r�nlere_Zam_Yap_Miktar_Ekle
(
	@miktar money
)
as
	update Products set UnitPrice = UnitPrice + @miktar

select * from Products

exec sp_�r�nlere_Zam_Yap_Fiyatla 2


-- D��ar�dan girilen kategori ad�na g�re �r�nleri lsiteleyen prosed�r� yazal�m

create proc sp_Kategoriyi_Getir
(
	@KategoriAd� nvarchar(20)
)
as
	select
		*
	from Products
	where CategoryID = (select	
							CategoryID
						from Categories
						where CategoryName like '%'+@KategoriAd�+'%' )

exec sp_Kategoriyi_Getir Dairy

select * from Categories


--Stok miktar� d��ar�dan girilen iki de�er aras�nda kalan fiyat� yine d��ar�dan girilen
-- iki de�er aras�nda olan ve toptanc� isimlerini getiren sp yazal�m


create proc sp_Tedarikci_Getir_Fiyat_Stok_Filtreli
(
	@MinStok as int,
	@MaxStok as int,
	@MinFiyat as money,
	@MaxFiyat as money,
	@TedarikciAdi as nvarchar(20)
)
as
	select
		*
	from Products p
	where (UnitPrice between @MinFiyat and @MaxFiyat)
		and (UnitsInStock between @MinStok and @MaxStok)
		and p.SupplierID = (select
								SupplierID
							from Suppliers s
							where s.CompanyName like '%'+@TedarikciAdi+'%')
select * from Suppliers
select * from Products

exec sp_Tedarikci_Getir_Fiyat_Stok_Filtreli 0, 100 ,0 ,200 , 'Tokyo'



create proc sp_Tedarikci_Getir_Fiyat_Stok_Filtreli_Hoca
(
	@MinStok as int,
	@MaxStok as int,
	@MinFiyat as money,
	@MaxFiyat as money,
	@TedarikciAdi as nvarchar(20)
)
as
	select
		p.ProductName,
		p.UnitPrice,
		p.UnitsInStock,
		s.CompanyName
	from Products p
	inner join Suppliers s on s.SupplierID = p.SupplierID
	where p.UnitPrice between @MinFiyat and @MaxFiyat
		and
		p.UnitsInStock between @MinStok and @MaxStok
		and
		s.CompanyName like '%'+@TedarikciAdi+'%' 

exec sp_Tedarikci_Getir_Fiyat_Stok_Filtreli_Hoca 0,100,0,200, 'Ex'


--***********************************************************
--Stored Procedure ==> Sakl� Yordamlar

--Parametre alarak SQL ile b�t�n i�lemleri yapabiliriz.
--C#'taki metotlara benzerler(Parametre alan ve almayan metotlar)
--SQL'de yap�lan b�t�n CRUD(Create-Update-Delete) i�lemleri yap�lmaktad�r
--Bir SQL kodunu normal halde �al��t�rmak yerine bir Store Procedure i�erisine al�p �al��t�rmak �ok daha h�zl�d�r.
--Ver�taban� alt�nda programmibility kals�r� alt�nda stored procedure alt klas�r�nde tutulurlar
--Store Procedure'�n daha h�zl� olmas�n�n sebebi, normal query 6-7 ad�mda olu�urken SP'ler 2 ad�mda olu�ur.




--exists ==> True yada False de�er d�nd�r�r

use HastahaneDB

select * from Klinikler

--**
go
	create proc sp_Klinik_Ekle
	(
		@adi nvarchar(50),
		@Kullan�c�ID int
	)
	as --G�vde ba�lad�
	begin
		insert into Klinikler (KlinikAdi,KullaniciID) 
		values
		(@adi ,
		@Kullan�c�ID
		)
	end
go



exec sp_Klinik_Ekle 'Psikiyatri', 19

select * from Klinikler



--SP(Stored Procedure) G�ncelleme "Alter" ile Yap�l�r

go
	alter proc sp_Klinik_Ekle
	(
		@adi nvarchar(50),
		@Kullan�c�ID int
	)
	as --G�vde ba�lad�
	begin
		if(exists(select * from Klinikler
					where KlinikAdi = @adi))
			begin
				print 'Ayn� Klinik Mevcut!'	
			end
		else
			begin
				insert into Klinikler (KlinikAdi,KullaniciID) 
				values
				(@adi ,
				@Kullan�c�ID
				)
			end
	end
go

exec sp_Klinik_Ekle 'Psikiyatri', 19


--SP ile kullan�c� ekleyin

select * from Kullanicilar




go
	create proc sp_Kullan�c�_Ekle
	(
	@KullaniciTC nvarchar(11),
	@KullaniciAdi nvarchar(50),
	@KullaniciSifre nvarchar(50),
	@yetkiID int
	)
	as
	begin
		if(exists(select * from Kullanicilar
					where KullaniciTC = @KullaniciTC))
			begin
				print 'Kullan�c� kay�tlarda bulunmaktad�r!!'
			end
		else
			begin
				insert into Kullanicilar
					(
					KullaniciTC,
					KullaniciAdi,
					KullaniciSifre,
					YetkiID
					)
				values
					(
					@KullaniciTC,
					@KullaniciAdi,
					@KullaniciSifre,
					@yetkiID
					)
			end

	end
go


exec sp_Kullan�c�_Ekle 123567952 , Serhat , 5678 , 1

select * from Kullanicilar


--Hasta TC'sine g�re e�er kay�t varsa ka� randevusu oldu�unu saat,tarih,g�n,doktor ad� ile birlikte listeleyiniz

select * from Hastalar 
select * from Randevular

go
	Alter proc sp_HastaTC_ile_Ranvedular�_Listele
	(
		@HastaTC as int
	)
	as
	begin
		if(exists(select * from Hastalar
					where HastaTC = @HastaTC))
			begin
				select 
					@HastaTC 'HastaTC',
					h.HastaAdi + space(1) + h.HastaSoyadi 'Hasta Ad�-Soyad�',
					r.RandevuSaati,
					DATEPART(year,r.RandevuTarihi) 'Y�l',
					DATEPART(MONTH,r.RandevuTarihi) 'Ay',
					DATEPART(DAY,r.RandevuTarihi) 'G�n',
					d.DoktorAdi
				from Randevular r
					inner join Hastalar h on r.HastaID = h.HastalarID
					join Doktorlar d on d.DoktorlarID = r.DoktorID
				where h.HastaTC = @HastaTC
				end
		else
		begin
			print 'Hastan�n Kayd� Bulunamad�!!'
		end
	end
go

select * from Hastalar

exec sp_HastaTC_ile_Ranvedular�_Listele 2222

-----------------------------------------------------------------------
--db akademi youtube
-----------------------------------------------------------------------

use Northwind

--�r�n fiyatlar�n� girilen parametre fiyat de�erine g�re fiyat�n alt�nda yada �st�nde sorgusu yapacak �ekilde
--sp kodlay�n�z.


go
	create proc sp_Fiyatla_Filtrele_Alt�Yada�st�_Parametreli
	(
		@GirilenFiyat as money,
		@Parametre as bit
	)
	as
	begin
		if(@Parametre = 0)
			begin
				select
					*
				from Products as p
				where p.UnitPrice>@GirilenFiyat
			end
		else
			begin
				select
					*
				from Products as p
				where p.UnitPrice<@GirilenFiyat
			end
	end
go


exec sp_Fiyatla_Filtrele_Alt�Yada�st�_Parametreli 40,1



--sipari�e gidecek �r�n�n stok mikar� yeterli ise stoktan d���� yap�lacak, yeterli de�ilse kullan�c�ya stok yetersiz mesaj� g�sterilecek

go
	create proc sp_Stok_Drumuna_G�re_G�ncelle
	(
		@Stok as smallint,
		@ID as int
	)
	as
	begin
		if((select UnitsInStock from Products as p where ProductID = @ID) >= @Stok)
			begin
				update Products set UnitsInStock = UnitsInStock - @Stok where ProductID=@ID
			end
		else
			begin
				Print 'Yeterli Sto�unuz Yok'
			end
	end
go

exec sp_Stok_Drumuna_G�re_G�ncelle 10,1

select * from Products


--**********************************************************************************************
--Trigger ==> Tetikleyiciler
--**********************************************************************************************
--Bir i�lem olmadan �nce, olduktan sonra ya da o esnada yap�lmas�n� istedi�niz i�lemleri trigger ile yapar�z


--go
--	create trigger
--	on Table_Name
--	{for|after|insteadof}{insert|update|delete}
--	as
--	begin

--	end
--go


--*********************************************

use HastahaneDB

select * from Klinikler

delete from Klinikler
	where KliniklerID = 15

go
	create trigger T_Klinik_Sil
	on Klinikler
	after delete
	as
		begin
			declare @Adi nvarchar(50)
			declare @Aciklama nvarchar(50)
			declare @Kulanici_ID int
			select @Adi=KlinikAdi,
					@Aciklama=Aciklama,
					@Kulanici_ID=KullaniciID
			from deleted --silinecek kay�tlar� tutan sanal tablodur

			insert into Silinen_Klinikler values (@Adi,@Aciklama,@Kulanici_ID)
		end
go


delete from Klinikler
	where KliniklerID = 15

select * from Silinen_Klinikler










