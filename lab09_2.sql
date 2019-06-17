--9.2.
--1. Wykonaj skrypt tworzący relacje w bazie danych kwiaciarnia
patrz: lab9_1.sql
--2. Przygotuj odpowiednio dane z pliku kwiaciarnia2dane-tekst.txt i zaimportuj je do bazy danych.
patrz: lab9_2_script.sql
--3. Sprawdź (np. wykonując zapytania), czy wszystkie dane zostały zaimportowane do bazy danych.
--4. Jak sprawdzić wartość klucza głównego dla ostatnio dodanego rekodu do tabeli odbiorcy w ramach tej samej sesji?
SELECT currval('odbiorcy_idodbiorcy_seq');

--9.2.1. Zweryfikuj działanie sekwencji. Otwórz dwie sesje z baza danych
--(dwa emulatoy terminala) A i B. Wykonaj odpowiednio co następuje.
-- sesja A: dodaj odbiorcę: Edmund Pasza.
INSERT INTO odbiorcy(nazwa, miasto, kod, adres)
   VALUES('Edmund Pasza', 'Kraków', '30-031', 'ul. Wrocławska 18/5');
-- sesja B: dodaj odbiorcę: Ela Budrys.
INSERT INTO odbiorcy(nazwa, miasto, kod, adres)
   VALUES('Ela Budrys', 'Warszawa', '00-091', 'ul. Marszałkowska 55/4');
-- sesja A: dodaj zamówienie dla Edmunda Paszy; użyj funkcji currval().
INSERT INTO zamowienia(idzamowienia, idklienta, idodbiorcy, idkompozycji, termin)
   VALUES(1, 'msowins', currval('odbiorcy_idodbiorcy_seq'), 'buk1', '2019-03-11');
-- sesja B: dodaj zamówienie dla Eli Budrys; użyj funkcji currval().
INSERT INTO zamowienia(idzamowienia, idklienta, idodbiorcy, idkompozycji, termin)
   VALUES(2, 'mbabik', currval('odbiorcy_idodbiorcy_seq'), 'buk2', '2019-03-11');

-- Czy w identyfikatory odbiorcy w tabeli zamowienia są poprawne? Dlaczego?
Identyfikatory są poprawne, ponieważ funkcja currval() zwraca ostatnią wartość
sekwencji wygenerowaną dla danej sesji. W przypadku, gdy kilka sesji operuje na
danej relacji, currval() widziany przez jedną sesję nie ulega zmianie w wyniku
wygenerowania kolejnej wartości sesji przez sesję drugą. Dzięki temu unikamy
przypadku 'Race Condition'.
