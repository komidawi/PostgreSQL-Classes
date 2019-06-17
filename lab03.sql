--3.1. Napisz zapytanie w języku SQL wyświetlające informacje na temat zamówień
--(idZamowienia, dataRealizacji), które mają być zrealizowane:
--1. między 12 i 20 listopada 2013
SELECT idZamowienia, dataRealizacji FROM zamowienia
WHERE dataRealizacji BETWEEN '2013-11-12' AND '2013-11-20';

--2. między 1 i 6 grudnia lub między 15 i 20 grudnia 2013
SELECT idZamowienia, dataRealizacji FROM zamowienia
WHERE (dataRealizacji BETWEEN '2013-12-01' AND '2013-12-06')
OR (dataRealizacji BETWEEN '2013-12-15' AND '2013-12-20');

--3. w grudniu 2013 (nie używaj funkcji date_part ani extract)
SELECT idZamowienia, dataRealizacji FROM zamowienia
WHERE dataRealizacji::text LIKE '2013-12-%';

--4. w listopadzie 2013 (w tym i kolejnych zapytaniach użyj funkcji date_part lub extract)
SELECT idZamowienia, dataRealizacji FROM zamowienia WHERE
(extract('month' FROM dataRealizacji) = 11) AND (extract('year' FROM dataRealizacji) = 2013);

--5. ★ w listopadzie lub grudniu 2013
SELECT idZamowienia, dataRealizacji FROM zamowienia WHERE
(extract('month' FROM dataRealizacji) IN (11, 12)) AND (extract('year' FROM dataRealizacji) = 2013);

--6. ★ 17, 18 lub 19 dnia miesiąca
SELECT idZamowienia, dataRealizacji FROM zamowienia
WHERE extract('day' FROM dataRealizacji) IN (17, 18, 19);

--7. ★ 46 lub 47 tygodniu roku
SELECT idZamowienia, dataRealizacji FROM zamowienia
WHERE extract('week' FROM dataRealizacji) IN (46, 47);


--3.2. Napisz zapytanie w języku SQL wyświetlające informacje na temat czekoladek
--(idCzekoladki, nazwa, czekolada, orzechy, nadzienie), których nazwa:
--1. rozpoczyna się na literę 'S'
SELECT idCzekoladki, nazwa, czekolada, orzechy, nadzienie FROM czekoladki
WHERE nazwa LIKE 'S%';

--2. rozpoczyna się na literę 'S' i kończy się na literę 'i'
SELECT idCzekoladki, nazwa, czekolada, orzechy, nadzienie FROM czekoladki
WHERE nazwa LIKE 'S%i';

--3. rozpoczyna się na literę 'S' i zawiera słowo rozpoczynające się na literę 'm'
SELECT idCzekoladki, nazwa, czekolada, orzechy, nadzienie FROM czekoladki
WHERE nazwa LIKE 'S% m%';

--4. rozpoczyna się na literę 'A', 'B' lub 'C'
SELECT idCzekoladki, nazwa, czekolada, orzechy, nadzienie FROM czekoladki
WHERE nazwa SIMILAR TO '(A|B|C)%';

--5. zawiera rdzeń 'orzech' (może on wystąpić na początku i wówczas
--będzie pisany z wielkiej litery)
SELECT idCzekoladki, nazwa, czekolada, orzechy, nadzienie FROM czekoladki
WHERE nazwa ILIKE '%orzech%';

--6. ★ rozpoczyna się na literę 'S' i zawiera w środku literę 'm'
SELECT idCzekoladki, nazwa, czekolada, orzechy, nadzienie FROM czekoladki
WHERE nazwa LIKE 'S%m%';

--7. ★ zawiera słowo 'maliny' lub 'truskawki'
SELECT idCzekoladki, nazwa, czekolada, orzechy, nadzienie FROM czekoladki
WHERE nazwa SIMILAR TO '%(maliny|truskawki)%';

--8. ★ nie rozpoczyna się żadną z liter: 'D'-'K', 'S' i 'T'
SELECT idCzekoladki, nazwa, czekolada, orzechy, nadzienie FROM czekoladki
WHERE nazwa NOT SIMILAR TO '([D-K]|S|T)%';

--9. ★ rozpoczyna się od 'Slod' ('Słod')
SELECT idCzekoladki, nazwa, czekolada, orzechy, nadzienie FROM czekoladki
WHERE nazwa SIMILAR TO 'S(l|ł)od%';

--10. ★ składa się dokładnie z jednego słowa
SELECT idCzekoladki, nazwa, czekolada, orzechy, nadzienie FROM czekoladki
WHERE nazwa NOT LIKE '_% _%';


--3.3 Napisz zapytanie w języku SQL oparte na tabeli Klienci, które:
--1. wyświetla nazwy miast, z których pochodzą klienci cukierni i
--które składają się z więcej niż jednego słowa
SELECT DISTINCT miejscowosc FROM klienci WHERE miejscowosc LIKE '_% _%';

--2. wyświetla nazwy klientów, którzy podali numer stacjonarny telefonu
SELECT nazwa, telefon FROM klienci WHERE telefon LIKE '___ ___ __ __';

--3. ★ wyświetla nazwy klientów, którzy podali numer komórkowy telefonu
SELECT nazwa, telefon FROM klienci WHERE telefon LIKE '___ ___ ___';


--3.4. Korzystając z zapytań z zadania 2.4 oraz operatorów UNION, INTERSECT, EXCEPT
--napisz zapytanie w języku SQL wyświetlające informacje na temat czekoladek
--(idCzekoladki, nazwa, masa, koszt), których:
--1. masa mieści się w przedziale od 15 do 24 g lub koszt produkcji mieści się w przedziale od 15 do 24 gr
SELECT idCzekoladki, nazwa, masa, koszt FROM czekoladki
WHERE masa BETWEEN 15 AND 24
UNION
SELECT idCzekoladki, nazwa, masa, koszt FROM czekoladki
WHERE koszt BETWEEN 0.15 AND 0.24;

--2. masa mieści się w przedziale od 25 do 35 g, ale koszt produkcji nie mieści się w przedziale od 25 do 35 gr
SELECT idCzekoladki, nazwa, masa, koszt FROM czekoladki
WHERE masa BETWEEN 25 AND 35
EXCEPT
SELECT idCzekoladki, nazwa, masa, koszt FROM czekoladki
WHERE koszt BETWEEN 0.25 AND 0.35;

--3. masa mieści się w przedziale od 15 do 24 g i koszt produkcji mieści się w przedziale od 15 do 24 gr
--lub masa mieści się w przedziale od 25 do 35 g i koszt produkcji mieści się w przedziale od 25 do 35 gr
(SELECT idCzekoladki, nazwa, masa, koszt FROM czekoladki
WHERE masa BETWEEN 15 AND 24
INTERSECT
SELECT idCzekoladki, nazwa, masa, koszt FROM czekoladki
WHERE koszt BETWEEN 0.15 AND 0.24)
UNION
(SELECT idCzekoladki, nazwa, masa, koszt FROM czekoladki
WHERE masa BETWEEN 25 AND 35
INTERSECT
SELECT idCzekoladki, nazwa, masa, koszt FROM czekoladki
WHERE koszt BETWEEN 0.25 AND 0.35);

--4. ★ masa mieści się w przedziale od 15 do 24 g i koszt produkcji mieści się w przedziale od 15 do 24 gr
SELECT idCzekoladki, nazwa, masa, koszt FROM czekoladki
WHERE masa BETWEEN 15 AND 24
INTERSECT
SELECT idCzekoladki, nazwa, masa, koszt FROM czekoladki
WHERE koszt BETWEEN 0.15 AND 0.24;

--5. ★ masa mieści się w przedziale od 25 do 35 g, ale koszt produkcji nie mieści się
--ani w przedziale od 15 do 24 gr, ani w przedziale od 29 do 35 gr.
(SELECT idCzekoladki, nazwa, masa, koszt FROM czekoladki
WHERE masa BETWEEN 25 AND 35)
EXCEPT
(SELECT idCzekoladki, nazwa, masa, koszt FROM czekoladki
WHERE koszt BETWEEN 0.15 AND 0.24
UNION
SELECT idCzekoladki, nazwa, masa, koszt FROM czekoladki
WHERE koszt BETWEEN 0.29 AND 0.35);

--3.5. Korzystając z operatorów UNION, INTERSECT, EXCEPT napisz zapytanie w języku SQL wyświetlające:
--1. identyfikatory klientów, którzy nigdy nie złożyli żadnego zamówienia
SELECT idklienta FROM klienci
EXCEPT
SELECT idklienta FROM zamowienia;

--2. identyfikatory pudełek, które nigdy nie zostały zamówione
SELECT idpudelka FROM pudelka
EXCEPT
SELECT idpudelka FROM artykuly;

--3. ★ nazwy klientów, czekoladek i pudełek, które zawierają rz (lub Rz)
SELECT nazwa FROM klienci WHERE nazwa SIMILAR TO '%(R|r)z%'
UNION
SELECT nazwa FROM czekoladki WHERE nazwa SIMILAR TO '%(R|r)z%'
UNION
SELECT nazwa FROM pudelka WHERE nazwa SIMILAR TO '%(R|r)z%';

--4. ★ identyfikatory czekoladek, które nie występują w żadnym pudełku
SELECT idCzekoladki FROM czekoladki
EXCEPT
SELECT idCzekoladki FROM zawartosc;


--3.6. Napisz zapytanie w języku SQL wyświetlające:
--1. identyfikator meczu, sumę punktów zdobytych przez gospodarzy i sumę punktów zdobytych przez gości
SELECT idmeczu,
(SELECT sum(gospodarze_punkty) FROM unnest(gospodarze) AS gospodarze_punkty) AS "punkty gospodarzy",
(SELECT sum(goscie_punkty) FROM unnest(goscie) AS goscie_punkty) AS "punkty gosci"
FROM statystyki;

--2. identyfikator meczu, sumę punktów zdobytych przez gospodarzy i sumę punktów zdobytych przez gości,
--dla meczów, które skończyły się po 5 setach i zwycięzca ostatniego seta zdobył ponad 15 punktów
SELECT idmeczu,
(SELECT sum(gospodarze_punkty) FROM unnest(gospodarze) AS gospodarze_punkty) AS "punkty gospodarzy",
(SELECT sum(goscie_punkty) FROM unnest(goscie) AS goscie_punkty) AS "punkty gosci"
FROM statystyki
WHERE (array_length(gospodarze, 1) = 5 AND array_length(goscie, 1) = 5)
AND (gospodarze[5] > 15 OR goscie[5] > 15);

--3. identyfikator i wynik meczu w formacie x:y, np. 3:1 (wynik jest pojedynczą kolumną – napisem)
SELECT idmeczu,
(
   (
      CASE WHEN gospodarze[1] > goscie[1] THEN 1 ELSE 0 END +
      CASE WHEN gospodarze[2] > goscie[2] THEN 1 ELSE 0 END +
      CASE WHEN gospodarze[3] > goscie[3] THEN 1 ELSE 0 END +
      CASE WHEN gospodarze[4] > goscie[4] THEN 1 ELSE 0 END +
      CASE WHEN gospodarze[5] > goscie[5] THEN 1 ELSE 0 END
   )
   || ':' ||
   (
      CASE WHEN gospodarze[1] < goscie[1] THEN 1 ELSE 0 END +
      CASE WHEN gospodarze[2] < goscie[2] THEN 1 ELSE 0 END +
      CASE WHEN gospodarze[3] < goscie[3] THEN 1 ELSE 0 END +
      CASE WHEN gospodarze[4] < goscie[4] THEN 1 ELSE 0 END +
      CASE WHEN gospodarze[5] < goscie[5] THEN 1 ELSE 0 END
   )
)
AS wynik
FROM statystyki;

--4. ★ identyfikator meczu, sumę punktów zdobytych przez gospodarzy i sumę punktów
--zdobytych przez gości, dla meczów, w których gospodarze zdobyli ponad 100 punktów
SELECT idmeczu,
(SELECT sum(gospodarze_punkty) FROM unnest(gospodarze) AS gospodarze_punkty) AS "punkty gospodarze",
(SELECT sum(goscie_punkty) FROM unnest(goscie) AS goscie_punkty) AS "punkty gosci"
FROM statystyki
WHERE (SELECT sum(gospodarze_punkty) FROM unnest(gospodarze) AS gospodarze_punkty) > 100;

--5. ★ identyfikator meczu, liczbę punktów zdobytych przez gospodarzy w pierwszym secie,
--sumę punktów zdobytych w meczu przez gospodarzy, dla meczów, w których pierwiastek kwadratowy
--z liczby punktów zdobytych w pierwszym secie jest mniejszy niż logarytm o podstawie 2
--z sumy punktów zdobytych w meczu. ;)
SELECT idmeczu,
gospodarze[1] AS "gosp. pierwszy set",
(SELECT sum(gospodarze_punkty) FROM unnest(gospodarze) AS gospodarze_punkty) AS "gosp. suma"
FROM statystyki
WHERE sqrt(gospodarze[1] + goscie[1])
< log(2, (
   (SELECT sum(gospodarze_punkty) FROM unnest(gospodarze) AS gospodarze_punkty)
   + (SELECT sum(goscie_punkty) FROM unnest(goscie) AS goscie_punkty)
));


--3.7. ★ Napisz skrypt składający się z poleceń psql, który wykona zapytanie
--(użyj dowolnego zapytania z zadania 3.6) oraz zwróci jego wynik jako dokument HTML
--(nie zapomnij o znacznikach html, body itd.), gdzie odpowiedź serwera będzie tabelą HTML.
--psql ... < zapytanie.sql > wynik.html
set search_path to siatkowka;
\H
\qecho <html><head><meta http-equiv="content-type" content="text/html;charset=utf-8"></head><body>
SELECT idmeczu,
(SELECT sum(gospodarze_punkty) FROM unnest(gospodarze) AS gospodarze_punkty) AS "punkty gospodarzy",
(SELECT sum(goscie_punkty) FROM unnest(goscie) AS goscie_punkty) AS "punkty gosci"
FROM statystyki;
\qecho </body></html>
\q


--3.8. ★ Napisz skrypt składający się z poleceń psql, który wykona zapytanie
--(użyj dowolnego zapytania z zadania 3.6, ale innego niż w zadaniu 3.7)
--oraz zwróci jego wynik jako dokument tekstowy z polami oddzielonymi przecinkami
--(Comma Separated Values), z jednym rekordem w jednej linii.
set search_path to siatkowka;
\pset fieldsep ','
\a
\t
SELECT idmeczu,
(SELECT sum(gospodarze_punkty) FROM unnest(gospodarze) AS gospodarze_punkty) AS "punkty gospodarze",
(SELECT sum(goscie_punkty) FROM unnest(goscie) AS goscie_punkty) AS "punkty gosci"
FROM statystyki
WHERE (SELECT sum(gospodarze_punkty) FROM unnest(gospodarze) AS gospodarze_punkty) > 100;
