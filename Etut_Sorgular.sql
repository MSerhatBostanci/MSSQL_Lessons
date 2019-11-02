use HastahaneDB

select * from Randevular

--her bran�tan ka� doktor var

select * from Doktorlar

select * from DoktorUnvanlari order by BransID

select
	b.BransAdi,
	count(d.DoktorlarID) 'Doktor Sat�s�'
from DoktorUnvanlari du
	right join Doktorlar d on d.DoktorUnvanID = du.DoktorUnvanlariID
	left join Branslar b on du.BransID = b.BranslarID
group by b.BransAdi


--her bir doktorun ka� randevuda g�rev ald���n� listeyeniiz

select 
	d.DoktorAdi + space(1) + d.DoktorSoyadi 'Doktor Ad�-Soyad�',
	count(r.RandevularID) 'Randevu Say�s�'
from Doktorlar d
	right join Randevular r on d.DoktorlarID = r.DoktorID
group by d.DoktorAdi,d.DoktorSoyadi
order by [Doktor Ad�-Soyad�]


select 
	d.DoktorAdi + ' ' + d.DoktorSoyadi 'Doktor Ad�-Soyad�',
	count(r.RandevularID) 'Randevu Say�s�'
from Randevular r
	join Doktorlar d on r.DoktorID = d.DoktorlarID
group by d.DoktorAdi,d.DoktorSoyadi
ORDER BY [Doktor Ad�-Soyad�]


--------------------------------------------------------------------------------------
--FULL OUTER JO�N
--join yap�s�n�n sa��nda ve solunda kalan tablolar�n b�t�n verilerini listeler
--ba�lant�lar yap�lamd���ndan dolay� veri say�lar� e�le�miyor


select 
	* 
from Hastalar h
	join Randevular r on r.HastaID = h.HastalarID --213


select 
	* 
from Hastalar h
	full outer join Randevular r on r.HastaID = h.HastalarID --247

--randevusu olmayan hastalar

select
	h.HastaAdi,
	r.RandevuTarihi
from Hastalar h
	full outer join Randevular r on h.HastalarID=r.HastaID
where r.RandevuTarihi is null --23

--randevusu olan hastalar

select
	h.HastaAdi,
	r.RandevuTarihi
from Hastalar h
	full outer join Randevular r on h.HastalarID=r.HastaID
where r.RandevuTarihi is not null --inner join gibi �al���r --224


--Hastas� olmayan randevular

select
	h.HastaAdi,
	r.RandevuTarihi
from Hastalar h
	full outer join Randevular r on h.HastalarID=r.HastaID
where h.HastaAdi is null --11


