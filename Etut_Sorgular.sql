use HastahaneDB

select * from Randevular

--her branþtan kaç doktor var

select * from Doktorlar

select * from DoktorUnvanlari order by BransID

select
	b.BransAdi,
	count(d.DoktorlarID) 'Doktor Satýsý'
from DoktorUnvanlari du
	right join Doktorlar d on d.DoktorUnvanID = du.DoktorUnvanlariID
	left join Branslar b on du.BransID = b.BranslarID
group by b.BransAdi


--her bir doktorun kaç randevuda görev aldýðýný listeyeniiz

select 
	d.DoktorAdi + space(1) + d.DoktorSoyadi 'Doktor Adý-Soyadý',
	count(r.RandevularID) 'Randevu Sayýsý'
from Doktorlar d
	right join Randevular r on d.DoktorlarID = r.DoktorID
group by d.DoktorAdi,d.DoktorSoyadi
order by [Doktor Adý-Soyadý]


select 
	d.DoktorAdi + ' ' + d.DoktorSoyadi 'Doktor Adý-Soyadý',
	count(r.RandevularID) 'Randevu Sayýsý'
from Randevular r
	join Doktorlar d on r.DoktorID = d.DoktorlarID
group by d.DoktorAdi,d.DoktorSoyadi
ORDER BY [Doktor Adý-Soyadý]


--------------------------------------------------------------------------------------
--FULL OUTER JOÝN
--join yapýsýnýn saðýnda ve solunda kalan tablolarýn bütün verilerini listeler
--baðlantýlar yapýlamdýðýndan dolayý veri sayýlarý eþleþmiyor


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
where r.RandevuTarihi is not null --inner join gibi çalýþýr --224


--Hastasý olmayan randevular

select
	h.HastaAdi,
	r.RandevuTarihi
from Hastalar h
	full outer join Randevular r on h.HastalarID=r.HastaID
where h.HastaAdi is null --11


