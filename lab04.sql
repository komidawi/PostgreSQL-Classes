--4.1. Porównaj wyniki poniższych zapytań:
1) SELECT k.nazwa FROM klienci k;
2) SELECT k.nazwa, z.idzamowienia FROM klienci k, zamowienia z;
3) SELECT k.nazwa, z.idzamowienia FROM klienci k, zamowienia z
WHERE z.idklienta = k.idklienta;
4) SELECT k.nazwa, z.idzamowienia FROM klienci k NATURAL JOIN zamowienia z;
5) SELECT k.nazwa, z.idzamowienia FROM klienci k JOIN zamowienia z
ON z.idklienta=k.idklienta;
6) SELECT k.nazwa, z.idzamowienia FROM klienci k JOIN zamowienia z
USING (idklienta);

--1. W którym zapytaniu występuje iloczyn kartezjański?
2

--2. Które zapytanie dostarcza bezwartościowych danych?
1 - może nie tyle bezwartościowych, ale występują duplikaty (można się ich pozbyć używając DISTINCT)
2 - mnożenie każdego z klientów z każdym ID nie ma żadnego sensu


--4.2. Napisz zapytanie w języku SQL wyświetlające informacje na temat zamówień
--(data realizacji, idzamowienia), które:
--1. zostały złożone przez klienta, który ma na imię Antoni
SELECT nazwa, idzamowienia, datarealizacji FROM klienci NATURAL JOIN zamowienia
WHERE nazwa LIKE '% Antoni';

--2. zostały złożone przez klientów z mieszkań (zwróć uwagę na pole ulica)
SELECT ulica, idzamowienia, datarealizacji FROM klienci NATURAL JOIN zamowienia
WHERE ulica LIKE '%/%';

--3. ★ zostały złożone przez klienta z Krakowa do realizacji w listopadzie 2013 roku
SELECT nazwa, miejscowosc, idzamowienia, datarealizacji FROM klienci NATURAL JOIN zamowienia
WHERE miejscowosc='Kraków'
AND extract(month FROM datarealizacji)=11 AND extract(year FROM datarealizacji)=2013;


--4.3. Napisz zapytanie w języku SQL wyświetlające informacje na temat klientów
--(nazwa, ulica, miejscowość), którzy:
--1. złożyli zamówienia z datą realizacji nie starszą niż sprzed pięciu lat
SELECT DISTINCT idklienta, nazwa, ulica, miejscowosc FROM klienci NATURAL JOIN zamowienia
WHERE age(current_date, datarealizacji) < interval '5 years' ORDER BY idklienta;

--2. zamówili pudełko Kremowa fantazja lub Kolekcja jesienna
SELECT DISTINCT idklienta, klienci.nazwa, ulica, miejscowosc
FROM klienci NATURAL JOIN zamowienia NATURAL JOIN artykuly JOIN pudelka USING(idpudelka)
WHERE pudelka.nazwa IN ('Kremowa fantazja', 'Kolekcja jesienna') ORDER BY idklienta;

--3. złożyli przynajmniej jedno zamówienie
SELECT DISTINCT idklienta, nazwa, ulica, miejscowosc
FROM klienci NATURAL JOIN zamowienia ORDER BY idklienta;

--4. nie złożyli żadnych zamówień
SELECT DISTINCT idklienta, nazwa, ulica, miejscowosc, idzamowienia
FROM zamowienia RIGHT JOIN klienci USING(idklienta)
WHERE idzamowienia IS NULL;

--5. ★ złożyli zamówienia z datą realizacji w listopadzie 2013
SELECT DISTINCT idklienta, nazwa, ulica, miejscowosc
FROM klienci NATURAL JOIN zamowienia
WHERE extract(month FROM datarealizacji)=11 AND extract(year FROM datarealizacji)=2013
ORDER BY idklienta;

--6. ★ zamówili co najmniej 2 sztuki pudełek Kremowa fantazja lub Kolekcja jesienna
--w ramach jednego zamówienia
SELECT DISTINCT idklienta, klienci.nazwa, ulica, miejscowosc
FROM klienci NATURAL JOIN zamowienia NATURAL JOIN artykuly JOIN pudelka USING(idpudelka)
WHERE pudelka.nazwa IN('Kremowa fantazja', 'Kolekcja jesienna')
AND sztuk >= 2;

--7. ★ zamówili pudełka, które zawierają czekoladki z migdałami
SELECT DISTINCT idklienta, klienci.nazwa, ulica, miejscowosc
FROM klienci NATURAL JOIN zamowienia NATURAL JOIN artykuly
JOIN zawartosc USING(idpudelka) JOIN czekoladki USING(idczekoladki)
WHERE orzechy = 'migdały';


--4. Napisz zapytanie w języku SQL wyświetlające informacje na temat pudełek
--i ich zawartości (nazwa, opis, nazwa czekoladki, opis czekoladki):
--1. wszystkich pudełek
SELECT pudelka.nazwa, pudelka.opis, czekoladki.nazwa, czekoladki.opis
FROM pudelka NATURAL JOIN zawartosc JOIN czekoladki USING(idczekoladki);

--2. pudełka o wartości klucza głównego heav
SELECT pudelka.nazwa, pudelka.opis, czekoladki.nazwa, czekoladki.opis
FROM pudelka NATURAL JOIN zawartosc JOIN czekoladki USING(idczekoladki)
WHERE idpudelka='heav';

--3. ★ pudełek, których nazwa zawiera słowo Kolekcja
SELECT pudelka.nazwa, pudelka.opis, czekoladki.nazwa, czekoladki.opis
FROM pudelka NATURAL JOIN zawartosc JOIN czekoladki USING(idczekoladki)
WHERE pudelka.nazwa LIKE '%Kolekcja%';


--4.5. Napisz zapytanie w języku SQL wyświetlające informacje na temat pudełek
--z czekoladkami (nazwa, opis, cena), które (uwaga: może być konieczne użycie konstrukcji
--z poprzednich laboratoriów):
--1. zawierają czekoladki o wartości klucza głównego d09
SELECT DISTINCT nazwa, opis, cena FROM pudelka NATURAL JOIN zawartosc
WHERE idczekoladki='d09';

--2. zawierają przynajmniej jedną czekoladkę, której nazwa zaczyna się na S
SELECT DISTINCT pudelka.nazwa, pudelka.opis, cena
FROM pudelka NATURAL JOIN zawartosc JOIN czekoladki USING(idczekoladki)
WHERE czekoladki.nazwa LIKE 'S%';

--3. zawierają przynajmniej 4 sztuki czekoladek jednego gatunku (o takim samym kluczu głównym)
SELECT DISTINCT pudelka.nazwa, pudelka.opis, cena
FROM pudelka NATURAL JOIN zawartosc
WHERE sztuk >= 4;

--4. zawierają czekoladki z nadzieniem truskawkowym
SELECT DISTINCT pudelka.nazwa, pudelka.opis, cena
FROM pudelka NATURAL JOIN zawartosc JOIN czekoladki USING(idczekoladki)
WHERE nadzienie='truskawki';

--5. nie zawierają czekoladek w gorzkiej czekoladzie
(SELECT DISTINCT pudelka.nazwa, pudelka.opis, cena
FROM pudelka)
EXCEPT
(SELECT DISTINCT pudelka.nazwa, pudelka.opis, cena
FROM pudelka NATURAL JOIN zawartosc JOIN czekoladki USING(idczekoladki)
WHERE czekolada='gorzka');

--6. ★ zawierają co najmniej 3 sztuki czekoladki Gorzka truskawkowa
SELECT DISTINCT pudelka.nazwa, pudelka.opis, cena
FROM pudelka NATURAL JOIN zawartosc JOIN czekoladki USING(idczekoladki)
WHERE sztuk >= 3 AND czekoladki.nazwa='Gorzka truskawkowa';

--7. ★ nie zawierają czekoladek z orzechami
(SELECT DISTINCT pudelka.nazwa, pudelka.opis, cena
FROM pudelka NATURAL JOIN zawartosc JOIN czekoladki USING(idczekoladki))
EXCEPT
(SELECT DISTINCT pudelka.nazwa, pudelka.opis, cena
FROM pudelka NATURAL JOIN zawartosc JOIN czekoladki USING(idczekoladki)
WHERE orzechy IS NOT NULL);

--8. ★ zawierają czekoladki Gorzka truskawkowa
SELECT DISTINCT pudelka.nazwa, pudelka.opis, cena
FROM pudelka NATURAL JOIN zawartosc JOIN czekoladki USING(idczekoladki)
WHERE czekoladki.nazwa='Gorzka truskawkowa';

--9. ★ zawierają przynajmniej jedną czekoladkę bez nadzienia
SELECT DISTINCT pudelka.nazwa, pudelka.opis, cena
FROM pudelka NATURAL JOIN zawartosc JOIN czekoladki USING(idczekoladki)
WHERE sztuk >= 1 AND nadzienie IS NULL;


--4.6. Napisz poniższe zapytania w języku SQL (użyj samozłączeń):
--1. Wyświetl wartości kluczy głównych oraz nazwy czekoladek,
--których koszt jest większy od kosztu czekoladki o wartości klucza głównego równej d08.



--2. Kto (nazwa klienta) złożył zamówienia na takie same czekoladki (pudełka) jak zamawiała Górka Alicja
-- wersja dla przypadku: "przynajmniej jedno pudełko tego samego rodzaju, co Alicja"
WITH pudelka_alicji AS (
   SELECT DISTINCT idpudelka FROM klienci NATURAL JOIN zamowienia NATURAL JOIN artykuly
   WHERE nazwa='Górka Alicja'
)
SELECT DISTINCT nazwa FROM klienci NATURAL JOIN zamowienia NATURAL JOIN artykuly
WHERE idpudelka IN (SELECT idpudelka FROM pudelka_alicji);

-- wersja dla przypadku: "dokładnie takie same pudełka, co Alicja"
WITH pudelka_alicji AS (
   SELECT DISTINCT idpudelka FROM klienci NATURAL JOIN zamowienia NATURAL JOIN artykuly
   WHERE nazwa='Górka Alicja'
)
...
