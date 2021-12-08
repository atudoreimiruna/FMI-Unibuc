--- 11
--- Formulați în limbaj natural și implementați 5 cereri SQL complexe ce vor utiliza, în ansamblul lor, următoarele elemente: 
--- operație join pe cel puțin 4 tabele, 
--- filtrare la nivel de linii,
--- subcereri sincronizate în care intervin cel puțin 3 tabele
--- subcereri nesincronizate în care intervin cel puțin 3 tabele
--- grupări de date, funcții grup, filtrare la nivel de grupuri
--- ordonări
--- utilizarea a cel puțin 2 funcții pe șiruri de caractere, 2 funcții pe date calendaristice, a funcțiilor NVL și DECODE, a cel puțin unei expresii CASE
--- utilizarea a cel puțin 1 bloc de cerere (clauza WITH)

--- Cerere 1
--- Sa se afiseze numele pacientului, varsta, orasul in care locuieste, prescriptia medicala, suma programarii si id-ul centrului medical la care a avut programarea.
--- Sa se afiseze doar pacientii cu varsta mai mare de 20 de ani ordonati in functie de aceasta.
SELECT p.patient_last, p.patient_age, ad.city_name, ap.medical_prescription, py.payment_sum, m.med_empl_id
FROM patient p
JOIN addresses ad ON (p.address_id = ad.address_id)
JOIN appointments ap ON (p.patient_id = ap.patient_id)
JOIN payment py ON (ap.appointment_id = py.appointment_id)
JOIN performed pf ON (pf.appointment_id = ap.appointment_id)
JOIN medical_employees m ON (m.med_empl_id = pf.med_empl_id)
WHERE p.patient_age > 20
ORDER BY p.patient_age;

--- Cerere 2
--- Sa se afiseze numarul total de programari facute si numarul total de programari care au fost facute in fiecare dintre anii 2020 si 2021
--- in plus, sa se afiseze si numarul total de programari de peste 2 luni de la data de 01/01/2019.

SELECT nvl(to_char(count(appointment_id)), 'Nu au fost facute programari. ' ) as "Programari",
count (( case when to_char(appt_date, 'YYYY') = '2020'  then 1 else NULL end )  ) as "2020",
count ( decode ( to_char (sysdate, 'yyyy'), 2021, appt_date) ) as "2021"
from appointments, dual;

--- Cerere 3
--- Scrieți o cerere prin care se afișeze id-ul, luna (în litere) şi anul nasterii pentru toți pacientii care au mers la aceiasi clinica cu address_id-ul cel mai mic ( dpdv lexicografic ), al căror nume conţine  litera “a”. Se  va exclude Popa. 
with addmin as ( select min(p1.address_id)
                from medical_centers p1
                )
select p.patient_id, to_char(p.date_of_birth, 'MM') as Luna,
extract(YEAR FROM p.date_of_birth) as An
from patient p, medical_centers m
where m.address_id = (select * from addmin ) and
lower(p.patient_last) != 'popa' and
lower(p.patient_last) like '%a%';

--- Cerere 4
--- Sa se afiseze numele si prenumele pacientilor care au fost la clinica medicala ce are codul 'RDG1'.
select p.patient_last, p.patient_first
from patient p
where p.patient_id in ( select m.patient_id
                        from registered m
                        where m.med_cntr_id in ( select mm.med_cntr_id
                                                        from medical_centers mm
                                                        where mm.med_cntr_type_code = 'RDG1') ) ;                                                       

--- Cerere 5
--- Să se afișeze id-ul și vârsta medicilor care s-au ocupat de cele mai multe programări.
--- ( în plus vor fi afișați doar cu condiția că s-au ocupat de cel puțin o programare )
select m.spcl_code, m.med_empl_age
from medical_employees m 
where ( select count (o.med_empl_id)
        from performed o 
        where o.med_empl_id = m.med_empl_id) = ( select max(count(o1.med_empl_id))
                                                from performed o1 
                                                group by o1.med_empl_id having count(*) > 1)
order by 1, 2;

--- 12
--- Implementarea a 3 operații de actualizare sau suprimare a datelor utilizând subcereri.

-- UPDATE - Să se dubleze pretul programarilor.
SELECT * from payment;

update payment set payment_sum = payment_sum * 2
where payment_id in ( select p.payment_id
                        from payment p);

SELECT * from payment;

-- DELETE - Să se șteargă platile care au valoarea 100.
SELECT * from payment;

delete from payment
where payment_sum = 100;

SELECT * from payment;

-- UPDATE - Sa se modifice modalitatea de plata in CASH ( unde este cazul ) pentru programarile care costa mai mult de 150 lei.
SELECT * from payment;

update payment set payment_type = 'CASH'
where payment_sum > 150;

SELECT * from payment;

--- 13 
--- Crearea unei secvențe ce va fi utilizată în inserarea înregistrărilor în tabele (punctul 10).
create sequence id_sequence
start with 1
increment by 1
min_value 0
max_value 9999
nocycle;