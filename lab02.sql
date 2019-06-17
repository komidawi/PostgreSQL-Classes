--2.1 Napisz zapytanie w języku SQL, które:
--1. wyświetla listę klientów (nazwa, ulica, miejscowość) posortowaną według nazw klientów,
SELECT nazwa, ulica, miejscowosc FROM klienci ORDER BY nazwa;

--2. wyświetla listę klientów posortowaną malejąco według nazw miejscowości,
--a w ramach tej samej miejscowości rosnąco według nazw klientów,
SELECT nazwa, ulica, miejscowosc FROM klienci ORDER BY miejscowosc DESC, nazwa;

--3. wyświetla listę klientów z Krakowa lub z Warszawy posortowaną malejąco
--według nazw miejscowości, a w ramach tej samej miejscowości rosnąco według
--nazw klientów (zapytanie utwórz na dwa sposoby stosując w kryteriach or lub in).
SELECT nazwa, ulica, miejscowosc FROM klienci WHERE miejscowosc='Kraków' OR
miejscowosc='Warszawa' ORDER BY miejscowosc DESC, nazwa;

SELECT nazwa, ulica, miejscowosc FROM klienci WHERE miejscowosc in('Kraków', 'Warszawa')
ORDER BY miejscowosc DESC, nazwa;

--4.★ wyświetla listę klientów posortowaną malejąco według nazw miejscowości,
SELECT nazwa, ulica, miejscowosc FROM klienci ORDER BY miejscowosc DESC;

--5.★ wyświetla listę klientów z Krakowa posortowaną według nazw klientów.
SELECT nazwa, ulica, miejscowosc FROM klienci WHERE miejscowosc='Kraków' ORDER BY nazwa;


--2.2. Napisz zapytanie w języku SQL, które:
--1. wyświetla nazwę i masę czekoladek, których masa jest większa niż 20 g,
SELECT nazwa, masa FROM czekoladki WHERE masa > 20;

--2. wyświetla nazwę, masę i koszt produkcji czekoladek, których masa
--jest większa niż 20 g i koszt produkcji jest większy niż 25 gr,
SELECT nazwa, masa, koszt FROM czekoladki WHERE masa > 20 AND koszt > 0.25;

--3. j.w. ale koszt produkcji musi być podany w groszach,
SELECT nazwa, masa, (koszt*100)::integer AS "Koszt [gr]" FROM czekoladki
WHERE masa > 20 AND koszt > 0.25;

--4. wyświetla nazwę oraz rodzaj czekolady, nadzienia i orzechów dla czekoladek,
--które są w mlecznej czekoladzie i nadziane malinami lub są w mlecznej czekoladzie
--i nadziane truskawkami lub zawierają orzechy laskowe, ale nie są w gorzkiej czekoladzie,
SELECT nazwa, czekolada, nadzienie, orzechy FROM czekoladki
WHERE czekolada='mleczna' AND nadzienie in('maliny', 'truskawki')
OR orzechy='laskowe' AND czekolada<>'gorzka';

--5. ★ wyświetla nazwę i koszt produkcji czekoladek, których koszt produkcji jest większy niż 25 gr,
SELECT nazwa, koszt FROM czekoladki WHERE koszt > 0.25;

--6. ★ wyświetla nazwę i rodzaj czekolady dla czekoladek, które są w białej lub mlecznej czekoladzie.
SELECT nazwa, czekolada FROM czekoladki WHERE czekolada in('biała', 'mleczna');


--2.3. Potraktuj psql jak kalkulator i wyznacz:
--1. 124 * 7 + 45
SELECT 124 * 7 + 45;

--2. 2 ^ 20
SELECT power(2, 20);

--3. ★ √3
SELECT sqrt(3);

--4. ★ π
SELECT pi();


--2.4 Napisz zapytanie w języku SQL wyświetlające informacje na temat czekoladek
--(IDCzekoladki, Nazwa, Masa, Koszt), których:
--1. masa mieści się w przedziale od 15 do 24 g
SELECT idczekoladki, nazwa, masa, koszt FROM czekoladki
WHERE masa BETWEEN 15 AND 24;

--2. koszt produkcji mieści się w przedziale od 25 do 35 gr
SELECT idczekoladki, nazwa, masa, koszt FROM czekoladki
WHERE koszt BETWEEN 0.25 AND 0.35;

--3. ★ masa mieści się w przedziale od 25 do 35 g lub
--koszt produkcji mieści się w przedziale od 15 do 24 gr.
SELECT idczekoladki, nazwa, masa, koszt FROM czekoladki
WHERE (masa BETWEEN 25 AND 35) AND (koszt BETWEEN 0.15 AND 0.24);


--2.5. Napisz zapytanie w języku SQL wyświetlające informacje na temat czekoladek
--(idCzekoladki, nazwa, czekolada, orzechy, nadzienie), które:
--1. zawierają jakieś orzechy
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie FROM czekoladki
WHERE orzechy IS NOT NULL;

--2. nie zawierają orzechów
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie FROM czekoladki
WHERE orzechy IS NULL;

--3. zawierają jakieś orzechy lub jakieś nadzienie
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie FROM czekoladki
WHERE (orzechy IS NOT NULL) OR (nadzienie IS NOT NULL);

--4. są w mlecznej lub białej czekoladzie (użyj IN) i nie zawierają orzechów
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie FROM czekoladki
WHERE czekolada in('mleczna', 'biała') AND orzechy IS NULL;

--5. nie są ani w mlecznej ani w białej czekoladzie i zawierają
--jakieś orzechy lub jakieś nadzienie
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie FROM czekoladki
WHERE (czekolada NOT in('mleczna', 'biała')) AND (orzechy IS NOT NULL OR nadzienie IS NOT NULL);


--2.6. Napisz zapytanie w języku SQL, które wyświetli czekoladki których:
--1. masa mieści się w przedziale od 15 do 24 g lub
--koszt produkcji mieści się w przedziale od 15 do 24 gr
SELECT nazwa, masa, koszt FROM czekoladki WHERE (masa BETWEEN 15 AND 24)
OR (koszt BETWEEN 0.15 AND 0.24);

--2. masa mieści się w przedziale od 15 do 24 g i koszt produkcji mieści się
--w przedziale od 15 do 24 gr lub masa mieści się w przedziale od 25 do 35 g
--i koszt produkcji mieści się w przedziale od 25 do 35 gr
SELECT nazwa, masa, koszt FROM czekoladki WHERE
((masa BETWEEN 15 AND 24) AND (koszt BETWEEN 0.15 AND 0.24)) OR
((masa BETWEEN 25 AND 35) AND (koszt BETWEEN 0.25 AND 0.35));

--3. ★ masa mieści się w przedziale od 15 do 24 g i koszt produkcji
--mieści się w przedziale od 15 do 24 gr
SELECT nazwa, masa, koszt FROM czekoladki WHERE (masa BETWEEN 15 AND 24)
AND (koszt BETWEEN 0.15 AND 0.24);

--4. ★ masa mieści się w przedziale od 25 do 35 g, ale koszt produkcji
--nie mieści się w przedziale od 25 do 35 gr
SELECT nazwa, masa, koszt FROM czekoladki WHERE (masa BETWEEN 25 AND 35)
AND (koszt NOT BETWEEN 0.25 AND 0.35);

--5. ★ masa mieści się w przedziale od 25 do 35 g, ale koszt produkcji
--nie mieści się ani w przedziale od 15 do 24 gr, ani w przedziale od 25 do 35 gr.
SELECT nazwa, masa, koszt FROM czekoladki WHERE (masa BETWEEN 25 AND 35)
AND ((koszt NOT BETWEEN 0.15 AND 0.24) AND (koszt NOT BETWEEN 0.25 AND 0.35));


--2.7 Korzystając z psql utwórz zapytanie wyświetlające całą zawartość tabeli Klienci.
SELECT * FROM klienci;
--1. Wydaj polecenie \a i ponownie wykonaj to samo zapytanie.
\a    --sprawia, że tabela nie jest wyrównana, pogarsza to czytelność
--2. Wydaj polecenie \f ' ' i ponownie wykonaj to samo zapytanie.
\f ' ' --zamienia domyślny znak '|' dzielący wiersze tabeli na spację
--3. Wydaj polecenie \H i ponownie wykonaj to samo zapytanie.
\H --sprawia, że w wyniku dostajemy tabelę w języku HTML
--4. Stosując polecenie \o przekieruj wyniki zapytania do pliku wynik.html.
--Ponownie wykonaj to samo zapytanie. Na drugiej konsoli sprawdź efekt jego realizacji.
\o wynik.html --wynik następnego zapytania zostanie zapisany w pliku wynik.html

--2.8
--1.★ W pliku zapytanie1.sql umieść zapytanie wyświetlające pola:
--idczekoladki, nazwa i opis z tabeli czekoladki. Wykonaj skrypt z poziomu psql.
--zapytanie1.sql:
SELECT idczekoladki, nazwa, opis FROM czekoladki;

\i zapytanie1.sql

--2.9 ★ Zmodyfikuj skrypt tak, aby wynik w formacie HTML był umieszczany
--w pliku zapytanie1.html.
--zapytanie1.sql:
\H
\o zapytanie1.html
SELECT idczekoladki, nazwa, opis FROM czekoladki;
\o
\H
