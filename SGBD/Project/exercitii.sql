-- Exercitiul 6

-- Folosind un subprogram stocat care să utilizeze două tipuri de colecție studiate
-- afisati salariile tuturor angajatilor dintr-un centru medical dat ca parametru.
 
CREATE OR REPLACE PROCEDURE Exercitiul6 
    ( id_mc medical_center.med_cntr_id%TYPE)
IS
    TYPE index_table1 IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v1 index_table1; 
    v2 index_table1; 
    v3 index_table1; 
    TYPE medical_employees IS TABLE OF NUMBER;
    w medical_employees;
BEGIN
    SELECT med_emp_id, salary BULK COLLECT INTO v1, v2
    from medical_employees;

    FOR i in v1.FIRST..v1.LAST LOOP
        v3(v1(i)):=v2(i);
    END LOOP;

    SELECT med_emp_id BULK COLLECT INTO w 
    FROM medical_employees 
    WHERE med_cntr_id = id_mc;

    FOR i IN 1..w.COUNT LOOP 
        DBMS_OUTPUT.PUT_LINE('Angajatul are salariul ' || v3(w(i)));
    END LOOP;
END;
/
BEGIN  
    Exercitiul6('RE1');
END;
/

-- Exercitiul 7

-- Folosind o procedura stocata si un tip de cursor studiat afisati 
-- pentru fiecare clinica medicala cati angajati lucreaza in cadrul acesteia.

-- cursor explicit 
CREATE OR REPLACE PROCEDURE Exercitiul7 
AS
    name_of_med_cntr medical_center.med_cntr_name%TYPE;
    number_of_employee NUMBER(4);
        -- declarare cursor
        CURSOR c IS 
            SELECT med_cntr_name, COUNT(med_emp_id)
            FROM medical_center m JOIN medical_employees me ON (m.med_cntr_id = me.med_cntr_id)
            GROUP BY med_cntr_name;
BEGIN
    OPEN c; -- deschidere cursor
    LOOP    
            FETCH c INTO name_of_med_cntr, number_of_employee;  -- incarcare cursor
            EXIT WHEN c%NOTFOUND;   -- verificare cursor

            IF number_of_employee = 0 THEN
                DBMS_OUTPUT.PUT_LINE('In centrul medical ' || name_of_med_cntr || ' nu lucreaza angajati');
            ELSIF number_of_employee = 1 THEN   
                DBMS_OUTPUT.PUT_LINE('In centrul medical ' || name_of_med_cntr || ' lucreaza un angajat');
            ELSE 
                DBMS_OUTPUT.PUT_LINE('In centrul medical ' || name_of_med_cntr || ' lucreaza ' || number_of_employee || ' angajati');
            END IF;

    END LOOP;
    CLOSE c;    -- inchidere cursor
END;
/
-- metoda apelare 'Bloc PLSQL'
BEGIN  
    Exercitiul7();
END;
/

-- Exercitiul 8

-- Folosind un subprogram stocat de tip funcție care să utilizeze 
-- într-o singură comandă SQL 3 dintre tabelele definite, afisati 
-- cel mai mare salariu al unui medic specialist care a asignat 
-- un diagnostic pentru o problema medicala.

CREATE OR REPLACE FUNCTION Exercitiul8
    ( med_diagnosis diagnosis.diagnosis_id%TYPE )
RETURN NUMBER
IS 
maxim NUMBER;
BEGIN
    SELECT MAX(salary) INTO maxim
    FROM medical_employees me
        JOIN assign a ON ( me.med_emp_id = a.specialist_doc_id)
        JOIN diagnosis d ON ( a.diagnosis_id = d.diagnosis_id)
    WHERE d.diagnosis_id = med_diagnosis
    GROUP BY d.diagnosis_id;
    RETURN maxim;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR( -20000, 'Nu exista diagnostic pentru acest id');
    WHEN OTHERS THEN    
        RAISE_APPLICATION_ERROR(-20001, 'Alta eroare');
END Exercitiul8;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE('Salariul maxim este ' || Exercitiul8('D9'));
END;
/

-- Exercitiul 9

-- Folosind un subprogram stocat de tip procedură care să utilizeze într-o singură
-- comandă SQL 5 dintre tabelele definite, afișați numele doctorului de familie care 
-- s-a ocupat de programarea pacientului dat.

CREATE OR REPLACE PROCEDURE Exercitiul9
    ( name_of_patient patient.patient_name%TYPE)
IS
    name_of_doctor medical_employees.first_name%TYPE;
BEGIN
    SELECT first_name INTO name_of_doctor
    FROM medical_employees me JOIN diagnosis d ON ( me.med_emp_id = d.fam_doctor_id )
        JOIN medical_problem mp ON ( mp.med_prob_id = d.med_prob_id )
        JOIN appointment a ON ( mp.appointment_id = a.appointment_id )
        JOIN patient p ON ( a.patient_id = p.patient_id )
    WHERE p.patient_name = name_of_patient;

    DBMS_OUTPUT.PUT_LINE( 'Numele doctorului de familie care s-a ocupat de programarea pacientului ' || name_of_patient || ' este ' || name_of_doctor );

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR( -20000, 'Nu exista pacient cu numele dat' );
    WHEN TOO_MANY_ROWS THEN 
        RAISE_APPLICATION_ERROR( -20001, 'Exista mai multi doctori de familie care s-au ocupat de programare' );
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare!' );

END Exercitiul9;
/
BEGIN
    Exercitiul9('Popa Ana');
END;
/

-- Exercitiul 10

-- Definiți un declanșator care să permită lucrul asupra tabelului medical_employees 
-- ( INSERT,  UPDATE, DELETE ) decât în intervalul de ore 8:00-17:00, 
-- in zilele lucratoare ( declanșator la nivel de comandă ).

SELECT * FROM medical_employees;

CREATE OR REPLACE TRIGGER Exercitiul10
    BEFORE INSERT OR UPDATE OR DELETE ON medical_employees
BEGIN
    IF ( TO_CHAR ( SYSDATE, 'DD/MM') = '25/12' OR TO_CHAR ( SYSDATE, 'DD/MM') = '01/05' )
        OR ( TO_CHAR ( SYSDATE, 'HH24' ) NOT BETWEEN 8 AND 17)
    THEN
    RAISE_APPLICATION_ERROR(-20001,'Tabelul nu poate fi actualizat');
    END IF;
END;
/

UPDATE medical_employees set salary = 4000
WHERE med_emp_id = 'ME1';

SELECT * FROM medical_employees;

-- Exercitiul 11

-- Definiți un declanșator prin care să nu se permită micșorarea salariilor
-- angajaților din tabelul medical_employees ( declanșator la nivel de linie ).

CREATE OR REPLACE TRIGGER Exercitiul11
    BEFORE UPDATE OF salary ON medical_employees
    FOR EACH ROW
BEGIN
    IF ( :NEW.salary < :OLD.salary ) THEN
    RAISE_APPLICATION_ERROR(-20002,'Salariul nu poate fi micsorat');
    END IF;
END;
/
UPDATE medical_employees
SET salary = salary - 1000;
DROP TRIGGER Exercitiul11;

-- Exercitiul 12

-- Creati tabelul new_event cu urmatoarele campuri:
-- -> eveniment ( evenimentul sistemului )
-- -> nume_obiect ( numele obiectului )
-- -> tip_obiect ( tipul obiectului )
-- -> ora ( ora producerii evenimentului )
-- -> data ( data producerii evenimentului )
-- Definiti un declansator care sa introduca date in acest tabel dupa ce
-- utilizatorul a folosit o comanda LDD ( declansator sistem - la nivel de schema ).

CREATE TABLE new_event (
    eveniment   VARCHAR2(30),
    nume_obiect VARCHAR2(30),
    tip_obiect  VARCHAR2(30),
    time_exec   DATE,
    data_exec   DATE
);

CREATE OR REPLACE TRIGGER Exercitiul12
    AFTER CREATE OR DROP OR ALTER ON SCHEMA
BEGIN
    INSERT INTO new_event 
    VALUES ( SYS.SYSEVENT, SYS.DICTIONARY_OBJ_NAME, SYS.DICTIONARY_OBJ_TYPE, CURRENT_TIMESTAMP , CURRENT_DATE );
END;
/

CREATE TABLE tabel_aux ( n NUMBER );

SELECT * FROM new_event;

-- Exercitiul 13

-- Definiti un pachet care sa contina toate obiectele definite in cadrul proiectului.

CREATE OR REPLACE PACKAGE proiect AS
    PROCEDURE Exercitiul6 ( id_mc medical_center.med_cntr_id%TYPE);
    PROCEDURE Exercitiul7;
    FUNCTION Exercitiul8 ( med_diagnosis diagnosis.diagnosis_id%TYPE)
        RETURN NUMBER;
    PROCEDURE Exercitiul9 ( name_of_patient patient.patient_name%TYPE );

END proiect;
/

CREATE OR REPLACE PACKAGE BODY proiect AS
    FUNCTION Exercitiul8
    ( med_diagnosis diagnosis.diagnosis_id%TYPE )
RETURN NUMBER
IS
maxim NUMBER;
BEGIN
    SELECT MAX(salary) INTO maxim
    FROM medical_employees me
        JOIN assign a ON ( me.med_emp_id = a.specialist_doc_id)
        JOIN diagnosis d ON ( a.diagnosis_id = d.diagnosis_id)
    WHERE d.diagnosis_id = med_diagnosis
    GROUP BY d.diagnosis_id;
    RETURN maxim;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR( -20000, 'Nu exista diagnostic pentru acest id');
    WHEN OTHERS THEN    
        RAISE_APPLICATION_ERROR(-20001, 'Alta eroare');

END Exercitiul8;

PROCEDURE Exercitiul7 
AS
    name_of_med_cntr medical_center.med_cntr_name%TYPE;
    number_of_employee NUMBER(4);
        -- declarare cursor
        CURSOR c IS 
            SELECT med_cntr_name, COUNT(med_emp_id)
            FROM medical_center m JOIN medical_employees me ON (m.med_cntr_id = me.med_cntr_id)
            GROUP BY med_cntr_name;
BEGIN
    OPEN c; -- deschidere cursor
    LOOP    
            FETCH c INTO name_of_med_cntr, number_of_employee;  -- incarcare cursor
            EXIT WHEN c%NOTFOUND;   -- verificare cursor

            IF number_of_employee = 0 THEN
                DBMS_OUTPUT.PUT_LINE('In centrul medical ' || name_of_med_cntr || ' nu lucreaza angajati');
            ELSIF number_of_employee = 1 THEN   
                DBMS_OUTPUT.PUT_LINE('In centrul medical ' || name_of_med_cntr || ' lucreaza un angajat');
            ELSE 
                DBMS_OUTPUT.PUT_LINE('In centrul medical ' || name_of_med_cntr || ' lucreaza ' || number_of_employee || ' angajati');
            END IF;

    END LOOP;
    CLOSE c;    -- inchidere cursor
END Exercitiul7;

PROCEDURE Exercitiul9
    ( name_of_patient patient.patient_name%TYPE)
IS
    name_of_doctor medical_employees.first_name%TYPE;
BEGIN
    SELECT first_name INTO name_of_doctor
    FROM medical_employees me JOIN diagnosis d ON ( me.med_emp_id = d.fam_doctor_id )
        JOIN medical_problem mp ON ( mp.med_prob_id = d.med_prob_id )
        JOIN appointment a ON ( mp.appointment_id = a.appointment_id )
        JOIN patient p ON ( a.patient_id = p.patient_id )
    WHERE p.patient_name = name_of_patient;

    DBMS_OUTPUT.PUT_LINE( 'Numele doctorului de familie care s-a ocupat de programarea pacientului ' || name_of_patient || ' este ' || name_of_doctor );

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR( -20000, 'Nu exista pacient cu numele dat' );
    WHEN TOO_MANY_ROWS THEN 
        RAISE_APPLICATION_ERROR( -20001, 'Exista mai multi doctori de familie care s-au ocupat de programare' );
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare!' );

END Exercitiul9;

PROCEDURE Exercitiul6 
    ( id_mc medical_center.med_cntr_id%TYPE)
IS
    TYPE index_table1 IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v1 index_table1; 
    v2 index_table1; 
    v3 index_table1; 
    TYPE medical_employees IS TABLE OF NUMBER;
    w medical_employees;
BEGIN
    SELECT med_emp_id, salary BULK COLLECT INTO v1, v2
    from medical_employees;

    FOR i in v1.FIRST..v1.LAST LOOP
        v3(v1(i)):=v2(i);
    END LOOP;

    SELECT med_emp_id BULK COLLECT INTO w 
    FROM medical_employees 
    WHERE med_cntr_id = id_mc;

    FOR i IN 1..w.COUNT LOOP 
        DBMS_OUTPUT.PUT_LINE(v3(w(i)));
    END LOOP;
END Exercitiul6;

END proiect;
/

BEGIN 
    proiect.Exercitiul9('Popa Ana');
END;
/




