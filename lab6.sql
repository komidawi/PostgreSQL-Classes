--6.1. Napisz i wykonaj zapytanie (użyj INSERT), które dodaje do tabeli czekoladki następujące informacje:
--1.
INSERT INTO czekoladki(idczekoladki, nazwa, czekolada, orzechy, nadzienie,
opis, koszt, masa) VALUES('W98', 'Biały kieł', 'biala', 'laskowe', 'marcepan',
'Rozpływające się w rękach i kieszeniach', 0.45, 20);

--2.
INSERT INTO klienci VALUES
(90, 'Matusiak Edward', 'Kropiwnickiego 6/3', 'Leningrad', '31-471', '031 423 45 38'),
(91, 'Matusiak Alina', 'Kropiwnickiego 6/3', 'Leningrad', '31-471', '031 423 45 38'),
(92, 'Kimono Franek', 'Karateków 8', 'Mistrz', '30-029', '501 498 324');

--3. Dodaj do tabeli klienci dane Izy Matusiak (idklienta 93). Pozostałe dane osobowe
--Izy Matusiak muszą być takie same jak dla Pana Edwarda Matusiaka. Użyj podzapytań.
INSERT INTO klienci
   SELECT 93, 'Matusiak Iza', ulica, miejscowosc, kod, telefon
   FROM klienci WHERE nazwa='Matusiak Edward';


--6.2. Napisz i wykonaj zapytanie, które doda do tabeli czekoladki następujące pozycje,
--wykorzystaj wartości NULL w poleceniu INSERT:
--1.
INSERT INTO czekoladki VALUES
('X91', 'Nieznana Nieznajoma', NULL, NULL, NULL,
'Niewidzialna czekoladka wspomagajaca odchudzanie.', 0.26, 0),
('M98', 'Mleczny Raj', 'Mleczna', NULL, NULL,
'Aksamitna mleczna czekolada w ksztalcie butelki z mlekiem.', 0.26, 36);


--6.3.
--1. Napisz zapytanie, które usunie informacje dodane w Zadaniu 6.2, użyj DELETE.
DELETE FROM czekoladki WHERE idczekoladki IN('X91', 'M98');

--2. Sprawdź, czy odpowiednie rekordy zostały usunięte
SELECT * FROM czekoladki WHERE idczekoladki IN('X91', 'M98');

--3. Napisz i wykonaj zapytanie, które doda do tabeli czekoladki następujące pozycje,
--wykorzystaj nazwy kolumn w poleceniu INSERT:
INSERT INTO czekoladki(idczekoladki, nazwa, czekolada, opis, koszt, masa) VALUES
('X91', 'Nieznana Nieznajoma', NULL, 'Niewidzialna czekoladka wspomagajaca odchudzanie', 0.26, 0),
('M98', 'Mleczny Raj', 'mleczna', 'Aksamitna mleczna czekolada w ksztalcie butelki z mlekiem.', 0.26, 36);


--6.4. Napisz instrukcje aktualizujące dane w bazie cukiernia.
--1. Zmiana nazwiska Izy Matusiak na Nowak.
UPDATE klienci SET nazwa='Nowak Iza' WHERE nazwa='Matusiak Iza';

--2. Obniżenie kosztu czekoladek o identyfikatorach (idczekoladki): W98, M98 i X91, o 10%.
UPDATE czekoladki SET koszt=koszt*0.9 WHERE idczekoladki IN('W98', 'M98', 'X91');

--3. Ustalenie kosztu czekoladek o nazwie Nieznana Nieznajoma na taką samą
--jak cena czekoladki o identyfikatorze W98.
UPDATE czekoladki SET koszt=(SELECT koszt FROM czekoladki WHERE idczekoladki='W98')
WHERE nazwa='Nieznana Nieznajoma';

--4. ★ Zmiana nazwy z Leningrad na Piotrograd w tabeli klienci
UPDATE klienci SET miejscowosc='Piotrograd' WHERE miejscowosc='Leningrad';

--5. ★ Podniesienie kosztu czekoladek, których dwa ostatnie znaki identyfikatora
--(idczekoladki) są większe od 90, o 15 groszy.
UPDATE czekoladki SET koszt=koszt+0.15
WHERE substring(idczekoladki FROM 2 FOR 2)::numeric > 90;


--6.5. Napisz instrukcje usuwające z bazy danych informacje o:
--1. klientach o nazwisku Matusiak
DELETE FROM klienci WHERE nazwa LIKE 'Matusiak %';

--2. ★ klientach o identyfikatorze większym niż 91
DELETE FROM klienci WHERE idklienta > 91;

--3. ★ czekoladkach, których koszt jest większy lub równy 0.45 lub
--masa jest większa lub równa 36, lub masa jest równa 0.
DELETE FROM czekoladki
WHERE koszt >= 0.45 OR masa >= 36 OR masa = 0;


--6.6. Napisz skrypt zawierający instrukcje INSERT wstawiające do bazy danych
--Cukiernia dwa nowe rekordy do tabeli Pudelka oraz odpowiednie rekordy związane
--z tymi pudełkami do tabeli Zawartosc. Każde z nowych pudełek ma zawierać łącznie
--co najmniej 10 czekoladek, w co najmniej 4 różnych smakach.
INSERT INTO pudelka VALUES
('dyna', 'Dynamiczne smakołyki', 'Czekoladki fanów przedmiotu Systemy Dynamiczne', 45.00, 100),
('dota', 'Dotaminy', 'Czekoladki dla fanów gry DotA wzbogacone o pakiet witamin', 50.00, 10);

INSERT INTO zawartosc VALUES
('dyna', 'b01', 4),
('dyna', 'b02', 3),
('dyna', 'b03', 4),
('dyna', 'd01', 1),
('dota', 'b04', 3),
('dota', 'b05', 2),
('dota', 'b06', 6),
('dota', 'd02', 1);


--6.7. ★ Napisz skrypt zawierający instrukcje COPY wstawiające do bazy danych
--cukiernia dwa nowe rekordy do tabeli pudelka oraz odpowiednie rekordy związane
--z tymi pudełkami do tabeli zawartosc. Każde z nowych pudełek ma zawierać łącznie
--co najmniej 10 czekoladek, w co najmniej 4 różnych smakach.


--6.8.
--1. Napisz instrukcję UDPATE, która dla pudełek dodanych w poprzednich dwóch zadaniach,
--zwiększa o 1 liczbę czekoladek każdego smaku, które w nich występują.
UPDATE zawartosc SET sztuk = sztuk + 1 WHERE idpudelka IN ('dyna', 'dota');

--2. Napisz skrypt zawierający instrukcje UPDATE, które modyfikują tabelę czekoladki
--zastępując w kolumnach: czekolada, orzechy i nadzienie wartości Null wartością “brak”.
UPDATE czekoladki SET czekolada = 'brak' WHERE czekolada IS NULL;
UPDATE czekoladki SET orzechy = 'brak' WHERE orzechy IS NULL;
UPDATE czekoladki SET nadzienie = 'brak' WHERE nadzienie IS NULL;

--3. ★ Napisz skrypt zawierający instrukcje UPDATE,
--które anulują zmiany wprowadzone w poprzednim punkcie.
UPDATE czekoladki SET czekolada = NULL WHERE czekolada = 'brak';
UPDATE czekoladki SET orzechy = NULL WHERE orzechy = 'brak';
UPDATE czekoladki SET nadzienie = NULL WHERE nadzienie = 'brak';
