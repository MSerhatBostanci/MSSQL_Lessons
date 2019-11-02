
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

--Dýþarýdan girilen kategori adý ve açýklamaya göre kategoriler
--tablosuna insert ilkemi gerçekletiren sp yazalým


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

exec sp_Add_Category Serhat,Bostancý


select * from Categories


--dýþarýdan girilen miktar kadar tüm ürünlere zam yapan sp yazalým

create proc sp_Ürünlere_Zam_Yap_Miktar_Ekle
(
	@miktar money
)
as
	update Products set UnitPrice = UnitPrice + @miktar

select * from Products

exec sp_Ürünlere_Zam_Yap_Fiyatla 2


-- Dýþarýdan girilen kategori adýna göre ürünleri lsiteleyen prosedürü yazalým

create proc sp_Kategoriyi_Getir
(
	@KategoriAdý nvarchar(20)
)
as
	select
		*
	from Products
	where CategoryID = (select	
							CategoryID
						from Categories
						where CategoryName like '%'+@KategoriAdý+'%' )

exec sp_Kategoriyi_Getir Dairy

select * from Categories


--Stok miktarý dýþarýdan girilen iki deðer arasýnda kalan fiyatý yine dýþarýdan girilen
-- iki deðer arasýnda olan ve toptancý isimlerini getiren sp yazalým


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
--Stored Procedure ==> Saklý Yordamlar

--Parametre alarak SQL ile bütün iþlemleri yapabiliriz.
--C#'taki metotlara benzerler(Parametre alan ve almayan metotlar)
--SQL'de yapýlan bütün CRUD(Create-Update-Delete) iþlemleri yapýlmaktadýr
--Bir SQL kodunu normal halde çalýþtýrmak yerine bir Store Procedure içerisine alýp çalýþtýrmak çok daha hýzlýdýr.
--Verþtabaný altýnda programmibility kalsörü altýnda stored procedure alt klasöründe tutulurlar
--Store Procedure'ün daha hýzlý olmasýnýn sebebi, normal query 6-7 adýmda oluþurken SP'ler 2 adýmda oluþur.




--exists ==> True yada False deðer döndürür

use HastahaneDB

select * from Klinikler

--**
go
	create proc sp_Klinik_Ekle
	(
		@adi nvarchar(50),
		@KullanýcýID int
	)
	as --Gövde baþladý
	begin
		insert into Klinikler (KlinikAdi,KullaniciID) 
		values
		(@adi ,
		@KullanýcýID
		)
	end
go



exec sp_Klinik_Ekle 'Psikiyatri', 19

select * from Klinikler



--SP(Stored Procedure) Güncelleme "Alter" ile Yapýlýr

go
	alter proc sp_Klinik_Ekle
	(
		@adi nvarchar(50),
		@KullanýcýID int
	)
	as --Gövde baþladý
	begin
		if(exists(select * from Klinikler
					where KlinikAdi = @adi))
			begin
				print 'Ayný Klinik Mevcut!'	
			end
		else
			begin
				insert into Klinikler (KlinikAdi,KullaniciID) 
				values
				(@adi ,
				@KullanýcýID
				)
			end
	end
go

exec sp_Klinik_Ekle 'Psikiyatri', 19


--SP ile kullanýcý ekleyin

select * from Kullanicilar




go
	create proc sp_Kullanýcý_Ekle
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
				print 'Kullanýcý kayýtlarda bulunmaktadýr!!'
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


exec sp_Kullanýcý_Ekle 123567952 , Serhat , 5678 , 1

select * from Kullanicilar


--Hasta TC'sine göre eðer kayýt varsa kaç randevusu olduðunu saat,tarih,gün,doktor adý ile birlikte listeleyiniz

select * from Hastalar 
select * from Randevular

go
	Alter proc sp_HastaTC_ile_Ranvedularý_Listele
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
					h.HastaAdi + space(1) + h.HastaSoyadi 'Hasta Adý-Soyadý',
					r.RandevuSaati,
					DATEPART(year,r.RandevuTarihi) 'Yýl',
					DATEPART(MONTH,r.RandevuTarihi) 'Ay',
					DATEPART(DAY,r.RandevuTarihi) 'Gün',
					d.DoktorAdi
				from Randevular r
					inner join Hastalar h on r.HastaID = h.HastalarID
					join Doktorlar d on d.DoktorlarID = r.DoktorID
				where h.HastaTC = @HastaTC
				end
		else
		begin
			print 'Hastanýn Kaydý Bulunamadý!!'
		end
	end
go

select * from Hastalar

exec sp_HastaTC_ile_Ranvedularý_Listele 2222

-----------------------------------------------------------------------
--db akademi youtube
-----------------------------------------------------------------------

use Northwind

--ürün fiyatlarýný girilen parametre fiyat deðerine göre fiyatýn altýnda yada üstünde sorgusu yapacak þekilde
--sp kodlayýnýz.


go
	create proc sp_Fiyatla_Filtrele_AltýYadaÜstü_Parametreli
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


exec sp_Fiyatla_Filtrele_AltýYadaÜstü_Parametreli 40,1



--sipariþe gidecek ürünün stok mikarý yeterli ise stoktan düþüþ yapýlacak, yeterli deðilse kullanýcýya stok yetersiz mesajý gösterilecek

go
	create proc sp_Stok_Drumuna_Göre_Güncelle
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
				Print 'Yeterli Stoðunuz Yok'
			end
	end
go

exec sp_Stok_Drumuna_Göre_Güncelle 10,1

select * from Products


--**********************************************************************************************
--Trigger ==> Tetikleyiciler
--**********************************************************************************************
--Bir iþlem olmadan önce, olduktan sonra ya da o esnada yapýlmasýný istediðniz iþlemleri trigger ile yaparýz


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
			from deleted --silinecek kayýtlarý tutan sanal tablodur

			insert into Silinen_Klinikler values (@Adi,@Aciklama,@Kulanici_ID)
		end
go


delete from Klinikler
	where KliniklerID = 15

select * from Silinen_Klinikler










