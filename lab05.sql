--5.1. Napisz zapytanie w języku SQL wyświetlające informacje na temat:
--1. łącznej liczby czekoladek w bazie danych
SELECT count(idczekoladki) FROM czekoladki;

--2. łącznej liczby czekoladek z nadzieniem (na 2 sposoby)
-- podpowiedź: count(*), count(nazwaKolumny)
SELECT count(*) FROM czekoladki WHERE nadzienie IS NOT NULL;
SELECT count(idczekoladki) FROM czekoladki WHERE nadzienie IS NOT NULL;

--3. pudełka, w którym jest najwięcej czekoladek (uwaga: konieczne jest użycie LIMIT)
SELECT idpudelka, sum(sztuk) FROM zawartosc
GROUP BY idpudelka ORDER BY 2 DESC LIMIT 1;

--4. ★ łącznej liczby czekoladek w poszczególnych pudełkach
SELECT idpudelka, sum(sztuk) FROM zawartosc GROUP BY idpudelka;

--5. ★ łącznej liczby czekoladek bez orzechów w poszczególnych pudełkach
SELECT idpudelka, sum(sztuk) FROM zawartosc NATURAL JOIN czekoladki
WHERE orzechy IS NULL GROUP BY idpudelka;

--6. ★ łącznej liczby czekoladek w mlecznej czekoladzie w poszczególnych pudełkach
SELECT idpudelka, sum(sztuk) FROM zawartosc NATURAL JOIN czekoladki
WHERE czekolada='mleczna' GROUP BY idpudelka;


--5.2. Napisz zapytanie w języku SQL wyświetlające informacje na temat:
--1. masy poszczególnych pudełek
SELECT idpudelka, sum(sztuk * masa) FROM zawartosc NATURAL JOIN czekoladki
GROUP BY idpudelka;

--2. pudełka o największej masie
SELECT idpudelka, sum(sztuk * masa) FROM zawartosc NATURAL JOIN czekoladki
GROUP BY idpudelka ORDER BY 2 DESC LIMIT 1;

--3. ★ średniej masy pudełka w ofercie cukierni
SELECT avg(pudelka.masa) AS "srednia masa pudelka"
FROM (
   SELECT sum(sztuk * masa) AS masa FROM zawartosc NATURAL JOIN czekoladki
   GROUP BY idpudelka
) AS pudelka;

--4. ★ średniej wagi pojedynczej czekoladki w poszczególnych pudełkach
SELECT idpudelka, sum(sztuk * masa) / sum(sztuk) AS "srednia masa czekoladki"
FROM zawartosc NATURAL JOIN czekoladki GROUP BY idpudelka;


--5.3. Napisz zapytanie w języku SQL wyświetlające informacje na temat:
--1. liczby zamówień na poszczególne dni
SELECT datarealizacji, count(idzamowienia) FROM zamowienia
GROUP BY datarealizacji ORDER BY 1;

--2. łącznej liczby wszystkich zamówień
SELECT count(idzamowienia) FROM zamowienia;

--3. ★ łącznej wartości wszystkich zamówień
SELECT sum(sztuk * cena) FROM artykuly NATURAL JOIN pudelka;

--4. ★ klientów, liczby złożonych przez nich zamówień
--i łącznej wartości złożonych przez nich zamówień
SELECT klienci.nazwa, count(idzamowienia), sum(sztuk * cena)
FROM klienci NATURAL JOIN zamowienia NATURAL JOIN artykuly JOIN pudelka USING(idpudelka)
GROUP BY idklienta;


--5.4. Napisz zapytanie w języku SQL wyświetlające informacje na temat:
--1. czekoladki, która występuje w największej liczbie pudełek
SELECT idczekoladki, count(idczekoladki) FROM zawartosc
GROUP BY idczekoladki ORDER BY 2 DESC;

--2. pudełka, które zawiera najwięcej czekoladek bez orzechów
SELECT idpudelka, sum(sztuk) FROM zawartosc NATURAL JOIN czekoladki
WHERE orzechy IS NULL GROUP BY idpudelka ORDER BY 2 DESC;

--3. ★ czekoladki, która występuje w najmniejszej liczbie pudełek
SELECT idczekoladki, count(idpudelka)
FROM czekoladki LEFT OUTER JOIN zawartosc USING(idczekoladki)
GROUP BY idczekoladki ORDER BY 2;

--4. ★ pudełka, które jest najczęściej zamawiane przez klientów
SELECT idpudelka, count(idpudelka) FROM artykuly
GROUP BY idpudelka ORDER BY 2 DESC;


--5.5. Napisz zapytanie w języku SQL wyświetlające informacje na temat:
--1. liczby zamówień na poszczególne kwartały
SELECT extract(quarter FROM datarealizacji) AS kwartal, count(*)
FROM zamowienia GROUP BY extract(quarter FROM datarealizacji);

--2. liczby zamówień na poszczególne miesiące
SELECT extract(month FROM datarealizacji) AS miesiac, count(*)
FROM zamowienia GROUP BY extract(month FROM datarealizacji) ORDER BY 1;

--3. ★ liczby zamówień do realizacji w poszczególnych tygodniach
SELECT extract(week FROM datarealizacji) AS tydzien, count(*)
FROM zamowienia GROUP BY extract(week FROM datarealizacji) ORDER BY 1;

--4. ★ liczby zamówień do realizacji w poszczególnych miejscowościach
SELECT miejscowosc, count(idzamowienia)
FROM zamowienia NATURAL JOIN klienci GROUP BY miejscowosc ORDER BY 2 DESC;

--5.6. Napisz zapytanie w języku SQL wyświetlające informacje na temat:
--1. łącznej masy wszystkich pudełek znajdujących się w cukierni
WITH masy_pudelek AS
(
   SELECT idpudelka, sum(sztuk * masa) AS masa_pudelka
   FROM zawartosc NATURAL JOIN czekoladki GROUP BY idpudelka
)
SELECT sum(stan * masa_pudelka)
FROM masy_pudelek NATURAL JOIN pudelka;

--2. ★ łącznej wartości wszystkich pudełek znajdujących się w cukierni
SELECT sum(stan * cena) FROM pudelka;


--5.7. Zakładając, że koszt wytworzenia pudełka czekoladek jest równy kosztowi
--wytworzenia zawartych w nim czekoladek, napisz zapytanie wyznaczające:
--1. zysk ze sprzedaży jednej sztuki poszczególnych pudełek
--(różnica między ceną pudełka i kosztem jego wytworzenia),
WITH koszty_pudelek AS
(
   SELECT idpudelka, sum(sztuk * koszt) AS koszt_pudelka
   FROM zawartosc NATURAL JOIN czekoladki GROUP BY idpudelka
)
SELECT idpudelka, cena - koszt_pudelka AS zysk_z_pudelka
FROM pudelka NATURAL JOIN koszty_pudelek;

--2. zysk ze sprzedaży zamówionych pudełek
WITH koszty_wytworzenia AS (
   SELECT idpudelka, sum(sztuk * koszt) AS koszt
   FROM zawartosc NATURAL JOIN czekoladki GROUP BY idpudelka
), zyski_ze_sprzedazy AS (
   SELECT idpudelka, cena - koszt AS zysk
   FROM pudelka NATURAL JOIN koszty_wytworzenia
)

SELECT sum(sztuk * zysk)
FROM artykuly NATURAL JOIN zyski_ze_sprzedazy;

--3. ★ zysk ze sprzedaży wszystkich pudełek czekoladek w cukierni
WITH koszty_wytworzenia AS (
   SELECT idpudelka, sum(sztuk * koszt) AS koszt
   FROM zawartosc NATURAL JOIN czekoladki GROUP BY idpudelka
), zyski_ze_sprzedazy AS (
   SELECT idpudelka, cena - koszt AS zysk
   FROM pudelka NATURAL JOIN koszty_wytworzenia
)

SELECT sum(zysk * stan)
FROM pudelka NATURAL JOIN zyski_ze_sprzedazy;


--5.8. Napisz zapytanie wyświetlające: liczbę porządkową i identyfikator pudełka czekoladek
--(idpudelka). Identyfikatory pudełek mają być posortowane alfabetycznie, rosnąco.
--Liczba porządkowa jest z przedziału 1..N, gdzie N jest ilością pudełek.
