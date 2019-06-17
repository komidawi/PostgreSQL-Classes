--9.6. Napisz zapytanie działające na tabelach bazy danych firma, które:
--1. Wyświetla nazwisko, wiek oraz roczne pobory pracownika posortowane wg poborów
--oraz nazwiska (pole pobory w tabeli pracownicy określa pobory miesięczne).
SELECT nazwisko, extract(year FROM age(dataUrodzenia)) AS wiek,
pobory * 12 AS "roczne pobory" FROM pracownicy ORDER BY 3 DESC, 1;

--2. Wyświetla nazwisko, imię, datę urodzenia, stanowisko, dział i pobory pracownika,
--który pracuje na stanowisku robotnik lub analityk i zarabia więcej niż 2000 miesięcznie.
SELECT nazwisko, imie, dataUrodzenia, stanowisko, dzial, pobory
FROM pracownicy WHERE stanowisko IN('robotnik', 'analityk') AND pobory > 2000;

--3. Wyświetla nazwiska i imiona pracowników, którzy zarabiają więcej niż zarabia Adam Kowalik.
SELECT nazwisko, imie FROM pracownicy
WHERE pobory > (SELECT pobory FROM pracownicy WHERE imie='Adam' AND nazwisko='Kowalik');

--4. Podnosi zarobki o 10% na stanowisku robotnik.
UPDATE pracownicy SET pobory = 1.1 * pobory WHERE stanowisko='robotnik';

--5. Oblicza średnie zarobki oraz ilość pracowników na poszczególnych stanowiskach
--z wyłączeniem stanowisk kierownik.
SELECT stanowisko, avg(pobory), count(idpracownika) FROM pracownicy
WHERE stanowisko<>'kierownik' GROUP BY stanowisko;
