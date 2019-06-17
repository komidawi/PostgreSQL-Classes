--10.2. Napisz zapytanie wyświetlające informacje na temat zamówień (dataRealizacji, idzamowienia)
--używając odpowiedniego operatora in/not in/exists/any/all, które:
--1. zostały złożone przez klienta, który ma na imię Antoni
SELECT idzamowienia, dataRealizacji FROM zamowienia
WHERE idklienta IN (SELECT idklienta FROM klienci WHERE nazwa LIKE '%Antoni%');

--2. zostały złożone przez klientów z mieszkań (zwróć uwagę na pole ulica)
SELECT idzamowienia, dataRealizacji FROM zamowienia
WHERE idklienta IN (SELECT idklienta FROM klienci WHERE ulica LIKE '%/%');

--3. ★ zostały złożone przez klienta z Krakowa do realizacji w listopadzie 2013 roku
SELECT idzamowienia, dataRealizacji FROM zamowienia
WHERE idklienta IN (SELECT idklienta FROM klienci WHERE miejscowosc='Kraków')
AND idklienta IN (SELECT idklienta FROM zamowienia WHERE extract('month' FROM dataRealizacji)=11
   AND extract('year' FROM dataRealizacji)=2013);


--10.3. Napisz zapytanie wyświetlające informacje na temat klientów (nazwa, ulica, miejscowość),
--używając odpowiedniego operatora in/not in/exists/any/all, którzy:
--1. złożyli zamówienia z datą realizacji 12.11.2013
SELECT nazwa, ulica, miejscowosc FROM klienci WHERE idklienta
IN (SELECT idklienta FROM zamowienia WHERE dataRealizacji='2013-11-12');

--2. złożyli zamówienia z datą realizacji w listopadzie 2013
SELECT nazwa, ulica, miejscowosc FROM klienci WHERE idklienta
IN (SELECT idklienta FROM zamowienia
   WHERE extract('month' FROM dataRealizacji)=11 AND extract('year' FROM dataRealizacji)=2013);

--3. zamówili pudełko Kremowa fantazja lub Kolekcja jesienna
SELECT nazwa, ulica, miejscowosc FROM klienci WHERE idklienta
IN (SELECT idklienta FROM zamowienia WHERE idzamowienia
   IN (SELECT idzamowienia FROM artykuly WHERE idpudelka
      IN (SELECT idpudelka FROM pudelka WHERE nazwa
         IN ('Kremowa fantazja', 'Kolekcja jesienna'))));

--4. zamówili co najmniej 2 sztuki pudełek Kremowa fantazja lub Kolekcja jesienna w ramach jednego zamówienia
SELECT nazwa, ulica, miejscowosc FROM klienci WHERE idklienta
IN (SELECT idklienta FROM zamowienia WHERE idzamowienia
   IN (SELECT idzamowienia FROM artykuly WHERE sztuk >= 2 AND idpudelka
      IN (SELECT idpudelka FROM pudelka WHERE nazwa
         IN ('Kremowa fantazja', 'Kolekcja jesienna'))));

--5. zamówili pudełka, które zawierają czekoladki z migdałami
SELECT nazwa, ulica, miejscowosc FROM klienci WHERE idklienta
IN (SELECT idklienta FROM zamowienia WHERE idzamowienia
   IN (SELECT idzamowienia FROM artykuly WHERE idpudelka
      IN (SELECT idpudelka FROM zawartosc WHERE idczekoladki
         IN (SELECT idczekoladki FROM czekoladki WHERE orzechy='migdały'))));

--6. złożyli przynajmniej jedno zamówienie
SELECT nazwa, ulica, miejscowosc FROM klienci WHERE idklienta
IN (SELECT idklienta FROM zamowienia);

--7. nie złożyli żadnych zamówień
SELECT nazwa, ulica, miejscowosc FROM klienci WHERE idklienta
NOT IN (SELECT idklienta FROM zamowienia);


--10.4. Napisz zapytanie wyświetlające informacje na temat pudełek z czekoladkami
--(nazwa, opis, cena), żywając odpowiedniego operatora, np. in/not in/exists/any/all, które:
--1. ★ zawierają czekoladki o wartości klucza głównego D09
SELECT nazwa, opis, cena FROM pudelka WHERE idpudelka
IN (SELECT idpudelka FROM zawartosc WHERE idczekoladki
   IN (SELECT idczekoladki FROM czekoladki WHERE idczekoladki='d09'));

--2. ★ zawierają czekoladki Gorzka truskawkowa
SELECT nazwa, opis, cena FROM pudelka WHERE idpudelka
IN (SELECT idpudelka FROM zawartosc WHERE idczekoladki
   IN (SELECT idczekoladki FROM czekoladki WHERE nazwa='Gorzka truskawkowa'));

--3. ★ zawierają przynajmniej jedną czekoladkę, której nazwa zaczyna się na S
SELECT nazwa, opis, cena FROM pudelka WHERE idpudelka
IN (SELECT idpudelka FROM zawartosc WHERE idczekoladki
   IN (SELECT idczekoladki FROM czekoladki WHERE nazwa LIKE 'S%'));

--4. ★ zawierają przynajmniej 4 sztuki czekoladek jednego gatunku (o takim samym kluczu głównym)
SELECT nazwa, opis, cena FROM pudelka WHERE idpudelka
IN (SELECT idpudelka FROM zawartosc WHERE sztuk >= 4);

--5. ★ zawierają co najmniej 3 sztuki czekoladki Gorzka truskawkowa
SELECT nazwa, opis, cena FROM pudelka WHERE idpudelka
IN (SELECT idpudelka FROM zawartosc WHERE sztuk >= 3 AND idczekoladki
   IN (SELECT idczekoladki FROM czekoladki WHERE nazwa='Gorzka truskawkowa'));

--6. ★ zawierają czekoladki z nadzieniem truskawkowym
SELECT nazwa, opis, cena FROM pudelka WHERE idpudelka
IN (SELECT idpudelka FROM zawartosc WHERE idczekoladki
   IN (SELECT idczekoladki FROM czekoladki WHERE nadzienie='truskawki'));

--7. nie zawierają czekoladek w gorzkiej czekoladzie
SELECT nazwa, opis, cena FROM pudelka WHERE idpudelka
NOT IN (SELECT idpudelka FROM zawartosc WHERE idczekoladki
   IN (SELECT idczekoladki FROM czekoladki WHERE czekolada='gorzka'));

--8. nie zawierają czekoladek z orzechami
SELECT nazwa, opis, cena FROM pudelka WHERE idpudelka
NOT IN (SELECT idpudelka FROM zawartosc WHERE idczekoladki
   IN (SELECT idczekoladki FROM czekoladki WHERE orzechy IS NOT NULL));

--9. zawierają przynajmniej jedną czekoladkę bez nadzienia
SELECT nazwa, opis, cena FROM pudelka WHERE idpudelka
IN (SELECT idpudelka FROM zawartosc WHERE
   EXISTS (SELECT * FROM czekoladki WHERE nadzienie IS NULL
      AND zawartosc.idczekoladki = czekoladki.idczekoladki));
