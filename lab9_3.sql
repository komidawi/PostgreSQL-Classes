-- 9.3. Przygotuj skrypt implementujący bazę danych firma zgodnie z przedstawionym poniżej opisem.
-- Uwaga: Baza danych ma zostać umieszczona w schemacie firma.

-- Relacja dzialy zawiera atrybuty:

-- iddzialu - typ znakowy, dokładnie 5 znaków, klucz główny,
-- nazwa - typ znakowy, maksymalnie 32 znaki, wymagane,
-- lokalizacja - typ znakowy, maksymalnie 24 znaki, wymagane,
-- kierownik - liczba całkowita, klucz obcy odwołujący się do pola idpracownika w relacji pracownicy.
-- Relacja pracownicy zawiera atrybuty:

-- idpracownika - liczba całkowita, klucz główny,
-- nazwisko - typ znakowy, maksymalnie 32 znaki, wymagane,
-- imie - typ znakowy, maksymalnie 16 znaków, wymagane,
-- dataUrodzenia - data, wymagane,
-- dzial - typ znakowy, dokładnie 5 znaków, wymagane, klucz obcy odwołujący się
-- do pola iddzialu w relacji dzialy,
-- stanowisko - typ znakowy, maksymalnie 24 znaki,
-- pobory - typ stałoprzecinkowy z dokładnością do 2 miejsc po przecinku.


BEGIN;

CREATE SCHEMA IF NOT EXISTS firma;

DROP TABLE IF EXISTS dzialy;
DROP TABLE IF EXISTS pracownicy;

CREATE TABLE firma.dzialy (
   iddzialu    CHAR(5)        PRIMARY KEY    CHECK(length(iddzialu) = 5),
   nazwa       VARCHAR(32)    NOT NULL,
   lokalizacja VARCHAR(24)    NOT NULL,
   kierownik   INTEGER
);

CREATE TABLE firma.pracownicy (
   idpracownika   INTEGER     PRIMARY KEY,
   nazwisko       VARCHAR(32) NOT NULL,
   imie           VARCHAR(16) NOT NULL,
   dataUrodzenia  DATE        NOT NULL,
   dzial          CHAR(5)     NOT NULL    CHECK(length(dzial) = 5)   REFERENCES firma.dzialy(iddzialu),
   stanowisko     VARCHAR(24),
   pobory         NUMERIC(7,2)
);

ALTER TABLE firma.dzialy ADD CONSTRAINT dzial_fk
   FOREIGN KEY(kierownik) REFERENCES firma.pracownicy(idpracownika)
   ON UPDATE CASCADE DEFERRABLE;

COMMIT;
