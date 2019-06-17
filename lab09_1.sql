--9.1. Tworzona baza danych ma stanowić podstawę dla istnienia internetowej kwiaciarni.
--Z jednej strony ma ona umożliwić klientowi wybór jednej lub kilku z gotowych kompozycji
--z oferty kwiaciarni. Przy złożeniu zamówienia klient musi podać swoje dane
--(identyfikator i hasło) lub zarejestrować się w systemie jeśli jest nowym klientem
--(korzysta z kwiaciarni pierwszy raz). Poza tym klient musi określić, gdzie
--mają dostarczone zostać kwiaty i osobę, której mają one zostać przekazane.
--Z drugiej strony baza danych ma stanowić podstawę zarządzania kwiaciarnią.
--Powinny być w niej przechowywane informacje o aktualnych zasobach kwiaciarni
--(ilości poszczególnych kompozycji) i automatycznie zgłaszane zapotrzebowanie na wyczerpujące się zasoby.

--Przygotuj skrypt implementujący bazę danych kwiaciarnia zgodnie z przedstawionym poniżej projektem i opisem.
--Uwaga: Baza danych kwiaciarnia ma zostać umieszczona w schemacie kwiaciarnia (patrz zadanie 1.1).
--Uwaga: zapis maksymalnie n znaków oznacza, że należy użyć typ varchar(n). Zapis dokładnie n znaków oznacza, że należy użyć typ char(n).

-- idklienta - typ znakowy, maksymalnie 10 znaków (tzn. użyć varchar(10)), klucz główny,
-- haslo - typ znakowy, maksymalnie 10 znaków, minimum 4 znaki, wymagane,
-- nazwa - typ znakowy, maksymalnie 40 znaków, wymagane,
-- miasto - typ znakowy, maksymalnie 40 znaków, wymagane,
-- kod - typ znakowy, dokładnie 6 znaków, wymagane,
-- adres - typ znakowy, maksymalnie 40 znaków, wymagane,
-- email - typ znakowy, maksymalnie 40 znaków,
-- telefon - typ znakowy, maksymalnie 16 znaków, wymagane,
-- fax - typ znakowy, maksymalnie 16 znaków,
-- nip - typ znakowy, dokładnie 13 znaków,
-- regon - typ znakowy, dokładnie 9 znaków,
-- idkompozycji - typ znakowy, dokładnie 5 znaków (tzn. użyć char(5)), klucz główny,
-- nazwa - typ znakowy, maksymalnie 40 znaków, wymagane,
-- opis - typ znakowy, maksymalnie 100 znaków,
-- cena - typ numeryczny z dokładnością do 2 cyfr po przecinku, minimalna cena to 40.00 zł,
-- minimum - typ całkowity,
-- stan - typ całkowity,
-- idodbiorcy - typ serial, klucz główny,
-- nazwa - typ znakowy, maksymalnie 40 znaków, wymagane,
-- miasto - typ znakowy, maksymalnie 40 znaków, wymagane,
-- kod - typ znakowy, dokładnie 6 znaków, wymagane,
-- adres - typ znakowy, maksymalnie 40 znaków, wymagane,
-- idzamowienia - typ całkowity, klucz główny,
-- idklienta - typ znakowy, maksymalnie 10 znaków, klucz obcy, wymagane,
-- idodbiorcy - typ całkowity, klucz obcy, wymagane,
-- idkompozycji - typ znakowy, dokładnie 5 znaków, klucz obcy, wymagane,
-- termin - data, wymagane,
-- cena - typ numeryczny z dokładnością do 2 cyfr po przecinku,
-- zaplacone - typ logiczny,
-- uwagi - typ znakowy, maksymalnie 200 znaków,
-- idzamowienia - typ całkowity, klucz główny,
-- idklienta - typ znakowy, maksymalnie 10 znaków,
-- idkompozycji - typ znakowy, dokładnie 5 znaków,
-- cena - typ numeryczny z dokładnością do 2 cyfr po przecinku,
-- termin - data,
-- idkompozycji - typ znakowy, dokładnie 5 znaków, klucz główny i klucz obcy,
-- data - data.


BEGIN;

CREATE SCHEMA IF NOT EXISTS kwiaciarnia;

DROP TABLE IF EXISTS kwiaciarnia.klienci;
DROP TABLE IF EXISTS kwiaciarnia.kompozycje;
DROP TABLE IF EXISTS kwiaciarnia.odbiorcy;
DROP TABLE IF EXISTS kwiaciarnia.zamowienia;
DROP TABLE IF EXISTS kwiaciarnia.historia;
DROP TABLE IF EXISTS kwiaciarnia.zapotrzebowanie;

CREATE TABLE kwiaciarnia.klienci (
   idklienta   VARCHAR(10)    PRIMARY KEY,
   haslo       VARCHAR(10)    NOT NULL    CHECK(length(haslo) >= 4),
   nazwa       VARCHAR(40)    NOT NULL,
   miasto      VARCHAR(40)    NOT NULL,
   kod         CHAR(6)        NOT NULL    CHECK(length(kod) = 6),
   adres       VARCHAR(40)    NOT NULL,
   email       VARCHAR(40),
   telefon     VARCHAR(16)    NOT NULL,
   fax         VARCHAR(16),
   nip         CHAR(13)       CHECK(length(nip) = 13),
   regon       CHAR(9)        CHECK(length(regon) = 9)
);

CREATE TABLE kwiaciarnia.kompozycje (
   idkompozycji   CHAR(5)        PRIMARY KEY    CHECK(length(idkompozycji) = 5),
   nazwa          VARCHAR(40)    NOT NULL,
   opis           VARCHAR(100),
   cena           NUMERIC(7,2)   CHECK(cena >= 40.00),
   minimum        INTEGER,
   stan           INTEGER
);

CREATE TABLE kwiaciarnia.odbiorcy (
   idodbiorcy     SERIAL         PRIMARY KEY,
   nazwa          VARCHAR(40)    NOT NULL,
   miasto         VARCHAR(40)    NOT NULL,
   kod            CHAR(6)        NOT NULL    CHECK(length(kod) = 6),
   adres          VARCHAR(40)    NOT NULL
);

CREATE TABLE kwiaciarnia.zamowienia (
   idzamowienia   INTEGER     PRIMARY KEY,
   idklienta      VARCHAR(10) NOT NULL    REFERENCES kwiaciarnia.klienci,
   idodbiorcy     INTEGER     NOT NULL    REFERENCES kwiaciarnia.odbiorcy,
   idkompozycji   CHAR(5)     NOT NULL    CHECK(length(idkompozycji) = 5)     REFERENCES kwiaciarnia.kompozycje,
   termin         DATE        NOT NULL,
   cena           NUMERIC(7,2),
   zaplacone      BOOLEAN,
   uwagi          VARCHAR(200)
);

CREATE TABLE kwiaciarnia.historia (
   idzamowienia   INTEGER        PRIMARY KEY,
   idklienta      VARCHAR(10),
   idkompozycji   CHAR(5)        CHECK(length(idkompozycji) = 5),
   cena           NUMERIC(7,2),
   termin         DATE
);

CREATE TABLE kwiaciarnia.zapotrzebowanie (
   idkompozycji   CHAR(5)  PRIMARY KEY    CHECK(length(idkompozycji) = 5)     REFERENCES kwiaciarnia.kompozycje,
   data           DATE
);

COMMIT;

-- Uwaga: Sprawdź jaka jest wartość domyślna w kolumnie odbiorcy.idodbiorcy. Skąd się bierze ta wartość?
Odp: Domyślna wartość to 1, 2, 3... samoczynnie inkrementująca się,
gdyż atrybut odbiorcy.idodbiorcy jest typu SERIAL
