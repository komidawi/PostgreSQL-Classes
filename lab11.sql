--11.1.
--1. Napisz funkcję masaPudelka wyznaczającą masę pudełka jako sumę masy czekoladek
--w nim zawartych. Funkcja jako argument przyjmuje identyfikator pudełka.
--Przetestuj działanie funkcji na podstawie prostej instrukcji select.
CREATE OR REPLACE FUNCTION masaPudelka(idpudelka_ CHAR(4))
   RETURNS INTEGER AS
   $$
      BEGIN
         RETURN
         (SELECT sum(sztuk * masa) FROM zawartosc NATURAL JOIN czekoladki
         WHERE idpudelka = idpudelka_);
      END;
   $$
LANGUAGE plpgsql;

--2. ★ Napisz funkcję liczbaCzekoladek wyznaczającą liczbę czekoladek
--znajdujących się w pudełku. Funkcja jako argument przyjmuje identyfikator pudełka.
--Przetestuj działanie funkcji na podstawie prostej instrukcji select.
CREATE OR REPLACE FUNCTION liczbaCzekoladek(idpudelka_ CHAR(4))
   RETURNS INTEGER AS
   $$
      BEGIN
         RETURN
         (SELECT sum(sztuk) FROM zawartosc WHERE idpudelka = idpudelka_);
      END;
   $$
LANGUAGE plpgsql;


--11.2.
--1. Napisz funkcję zysk obliczającą zysk jaki cukiernia uzyskuje ze sprzedaży jednego
--pudełka czekoladek, zakładając, że zysk ten jest różnicą między ceną pudełka, a kosztem
--wytworzenia zawartych w nim czekoladek i kosztem opakowania (0,90 zł dla każdego pudełka).
--Funkcja jako argument przyjmuje identyfikator pudełka.
--Przetestuj działanie funkcji na podstawie prostej instrukcji select.
CREATE OR REPLACE FUNCTION zysk(idpudelka_ CHAR(4))
   RETURNS NUMERIC(7,2) AS
   $$
      DECLARE
         kosztOpakowania NUMERIC(7,2) := 0.90;
         cenaPudelka NUMERIC(7,2);
         kosztCzekoladek NUMERIC(7,2);
      BEGIN
         cenaPudelka := (SELECT cena FROM pudelka WHERE idpudelka = idpudelka_);
         kosztCzekoladek := (SELECT sum(sztuk * koszt) FROM zawartosc NATURAL JOIN czekoladki
                             WHERE idPudelka = idpudelka_);
         RETURN (cenaPudelka - kosztCzekoladek - kosztOpakowania);
      END;
   $$
LANGUAGE plpgsql;

--2. Napisz funkcję obliczającą zysk jaki cukiernia
--uzyska ze sprzedaży pudełek zamówionych w wybranym dniu.
CREATE OR REPLACE FUNCTION zyskDanegoDnia(dzien DATE)
   RETURNS NUMERIC(7,2) AS
   $$
      BEGIN
         RETURN
         (SELECT sum(sztuk * zysk(idpudelka)) FROM zamowienia NATURAL JOIN artykuly
         WHERE dataRealizacji = dzien);
      END;
   $$
LANGUAGE plpgsql;


--11.3.
--1. Napisz funkcję sumaZamowien obliczającą łączną wartość zamówień złożonych przez klienta,
--które czekają na realizację (są w tabeli Zamowienia). Funkcja jako argument
--przyjmuje identyfikator klienta. Przetestuj działanie funkcji.
CREATE OR REPLACE FUNCTION sumaZamowien(idklienta_ INTEGER)
   RETURNS NUMERIC(7,2) AS
   $$
      BEGIN
         RETURN
         (SELECT sum(sztuk * cena) FROM zamowienia NATURAL JOIN artykuly NATURAL JOIN pudelka
         WHERE idklienta = idklienta_);
      END;
   $$
LANGUAGE plpgsql;

--2. Napisz funkcję rabat obliczającą rabat jaki otrzymuje klient składający zamówienie.
--Funkcja jako argument przyjmuje identyfikator klienta. Rabat wyliczany jest na podstawie
--wcześniej złożonych zamówień w sposób następujący:
--4 % jeśli wartość zamówień jest z przedziału 100-200 zł;
--7 % jeśli wartość zamówień jest z przedziału 200-400 zł;
--8 % jeśli wartość zamówień jest większa od 400 zł.
CREATE OR REPLACE FUNCTION rabat(idklienta_ INTEGER)
   RETURNS NUMERIC(3,2) AS
   $$
      DECLARE
         wartoscZamowien NUMERIC(7,2) := (SELECT sumaZamowien(idklienta_));
      BEGIN
         IF wartoscZamowien BETWEEN 100 AND 199.99
            THEN return 0.04;
         ELSIF wartoscZamowien BETWEEN 200 AND 399.99
            THEN return 0.07;
         ELSIF wartoscZamowien > 400
            THEN return 0.08;
         ELSE
            return 0.00;
         END IF;
      END;
   $$
LANGUAGE plpgsql;


--11.4.
-- Napisz bezargumentową funkcję podwyzka, która dokonuje podwyżki kosztów produkcji czekoladek o:
-- 3 gr dla czekoladek, których koszt produkcji jest mniejszy od 20 gr;
-- 4 gr dla czekoladek, których koszt produkcji jest z przedziału 20-29 gr;
-- 5 gr dla pozostałych.
-- Funkcja powinna ponadto podnieść cenę pudełek o tyle o ile zmienił się koszt
-- produkcji zawartych w nich czekoladek.
CREATE OR REPLACE FUNCTION zmienCeneCzekoladki(idczekoladki_ CHAR(3), roznica NUMERIC(7,2))
   RETURNS VOID AS
   $$
      BEGIN
         UPDATE czekoladki
         SET koszt = koszt + roznica WHERE idczekoladki = idczekoladki_;
      END;
   $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION zmienCenePudelek(idczekoladki_ CHAR(3), roznicaCenyCzekoladki NUMERIC(7,2))
   RETURNS VOID AS
   $$
      DECLARE
         zawartoscPudelka RECORD;
         roznicaCenyPudelka NUMERIC(7,2);
      BEGIN
         FOR zawartoscPudelka IN SELECT idpudelka, idCzekoladki, sztuk FROM zawartosc
            WHERE idCzekoladki = idczekoladki_
         LOOP
            roznicaCenyPudelka := zawartoscPudelka.sztuk * roznicaCenyCzekoladki;

            UPDATE pudelka
            SET cena = cena + roznicaCenyPudelka WHERE idPudelka = zawartoscPudelka.idPudelka;

         END LOOP;
      END;
   $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION podwyzka()
   RETURNS VOID AS
   $$
      DECLARE
         wiersz RECORD;
         kwotaPodwyzki NUMERIC(7,2);
      BEGIN
         FOR wiersz IN SELECT idczekoladki, koszt FROM czekoladki
         LOOP
            IF wiersz.koszt < 0.20
               THEN kwotaPodwyzki := 0.03;
            ELSIF wiersz.koszt BETWEEN 0.20 AND 0.29
               THEN kwotaPodwyzki := 0.04;
            ELSE
               kwotaPodwyzki := 0.05;
            END IF;

            PERFORM zmienCeneCzekoladki(wiersz.idczekoladki, kwotaPodwyzki);
            PERFORM zmienCenePudelek(wiersz.idczekoladki, kwotaPodwyzki);
         END LOOP;
      END;
   $$
LANGUAGE plpgsql;


--11.5
--Napisz funkcję obnizka odwracająca zmiany wprowadzone w poprzedniej funkcji. Przetestuj działanie funkcji.
CREATE OR REPLACE FUNCTION obnizka()
   RETURNS VOID AS
   $$
      DECLARE
         wiersz RECORD;
         kwotaObnizki NUMERIC(7, 2);
      BEGIN
         FOR wiersz IN SELECT idczekoladki, koszt FROM czekoladki
         LOOP
            IF wiersz.koszt < 0.23
               THEN kwotaObnizki := -0.03;
            ELSIF wiersz.koszt BETWEEN 0.24 AND 0.33
               THEN kwotaObnizki := -0.04;
            ELSE
               kwotaObnizki := -0.05;
            END IF;

            PERFORM zmienCeneCzekoladki(wiersz.idczekoladki, kwotaObnizki);
            PERFORM zmienCenePudelek(wiersz.idczekoladki, kwotaObnizki);
         END LOOP;
      END;
   $$
LANGUAGE plpgsql;


--11.6
--1. Napisz funkcję zwracającą informacje o zamówieniach złożonych przez klienta,
--którego identyfikator podawany jest jako argument wywołania funkcji.
--W/w informacje muszą zawierać: idzamowienia, idpudelka, datarealizacji.
--Przetestuj działanie funkcji. Uwaga: Funkcja zwraca więcej niż 1 wiersz!
CREATE OR REPLACE FUNCTION pobierz_zamowienia_klienta(idklienta INTEGER)
   RETURNS TABLE (idZamowienia INTEGER, idPudelka CHAR(4), dataRealizacji DATE)
   AS
   $$
      DECLARE
         wiersz RECORD;
      BEGIN
         FOR wiersz IN SELECT * FROM pobierz_ID_oraz_daty_zamowien(idklienta)
         LOOP
            RETURN QUERY
            SELECT wiersz.idZamowienia, artykuly.idPudelka, wiersz.dataRealizacji
               FROM artykuly WHERE artykuly.idZamowienia = wiersz.idZamowienia;
         END LOOP;
      END;
   $$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION pobierz_ID_oraz_daty_zamowien(idklienta_ INTEGER)
   RETURNS TABLE (idZamowienia INTEGER, dataRealizacji DATE)
   AS
   $$
      BEGIN
         RETURN QUERY
         SELECT zamowienia.idzamowienia, zamowienia.datarealizacji
            FROM zamowienia WHERE zamowienia.idklienta = idklienta_;
      END;
   $$
LANGUAGE plpgsql;


-- Wersja #2
CREATE OR REPLACE FUNCTION pobierz_zamowienia_klienta_2(idklienta_ INTEGER)
   RETURNS TABLE (idZamowienia INTEGER, idPudelka CHAR(4), dataRealizacji DATE)
   AS
   $$
      BEGIN
         RETURN QUERY
         SELECT zamowienia.idZamowienia, artykuly.idPudelka, zamowienia.dataRealizacji
            FROM zamowienia NATURAL JOIN artykuly WHERE zamowienia.idklienta = idklienta_;
      END;
   $$
LANGUAGE plpgsql;


--2.★ Napisz funkcję zwracającą listę klientów z miejscowości, której nazwa
--podawana jest jako argument wywołania funkcji. Lista powinna zawierać:
--nazwę klienta i adres. Przetestuj działanie funkcji.
CREATE OR REPLACE FUNCTION lista_klientow_z_miejscowosci(miejscowosc_ VARCHAR(15))
   RETURNS TABLE(nazwa VARCHAR(130), ulica VARCHAR(30))
   AS
   $$
      BEGIN
         RETURN QUERY
         SELECT klienci.nazwa, klienci.ulica FROM klienci WHERE klienci.miejscowosc = miejscowosc_;
      END;
   $$
LANGUAGE plpgsql;
