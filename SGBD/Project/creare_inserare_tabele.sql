-- CREAREA TABELELOR --

-- Crearea tabelului MEDICAL_CENTER

CREATE TABLE medical_center
(
    med_cntr_id             VARCHAR2(6)     NOT NULL,
    address_id              VARCHAR2(25)    NOT NULL,
    med_cntr_name           VARCHAR2(30)    NOT NULL,
    med_cntr_contact        VARCHAR2(12)    NOT NULL
);

ALTER TABLE medical_center ADD (
    CONSTRAINT med_cntr_id_pk
    PRIMARY KEY
    (med_cntr_id)
);

-- Crearea tabelului PATIENT

CREATE TABLE patient
(
    patient_id      VARCHAR2(6)     NOT NULL,
    patient_name    VARCHAR2(30)    NOT NULL,
    contact_pat     VARCHAR2(12)    NOT NULL
);

ALTER TABLE patient ADD (
    CONSTRAINT patient_id_pk
    PRIMARY KEY
    (patient_id)
);

-- Crearea tabelului MEDICAL_EMPLOYEES

CREATE TABLE medical_employees
(
    med_emp_id          VARCHAR2(6)     NOT NULL,
    med_cntr_id         VARCHAR2(6)     NOT NULL,
    first_name          VARCHAR2(30)    NOT NULL,
    last_name           VARCHAR2(30)    NOT NULL,
    contact             VARCHAR2(12)    NOT NULL,
    salary              VARCHAR2(6)     NOT NULL,
    fam_doctor_id       VARCHAR2(6)     NOT NULL,
    assistant_id        VARCHAR2(6)     NOT NULL,
    specialist_doc_id   VARCHAR2(6)     NOT NULL
);

ALTER TABLE medical_employees ADD (
    CONSTRAINT med_emp_id_pk
    PRIMARY KEY
    (med_emp_id)
);

ALTER TABLE medical_employees ADD (
    CONSTRAINT med_cntr_id_fk
    FOREIGN KEY (med_cntr_id)
    REFERENCES medical_center(med_cntr_id)
);

-- Crearea tabelului APPOINTMENT

CREATE TABLE appointment
(
    appointment_id          VARCHAR2(6)     NOT NULL,
    med_cntr_id             VARCHAR2(6)     NOT NULL,
    patient_id              VARCHAR2(6)     NOT NULL,
    assistant_id            VARCHAR2(6)     NOT NULL,
    appointment_date        DATE            NOT NULL,
    appointment_price       VARCHAR2(6)     NOT NULL
);

ALTER TABLE appointment ADD (
    CONSTRAINT appointment_id_pk
    PRIMARY KEY
    (appointment_id)
);

ALTER TABLE appointment ADD (
    CONSTRAINT med_cntr_id_app_fk
    FOREIGN KEY (med_cntr_id)
    REFERENCES medical_center(med_cntr_id)
);

ALTER TABLE appointment ADD (
    CONSTRAINT patient_id_app_fk
    FOREIGN KEY (patient_id)
    REFERENCES patient(patient_id)
);

ALTER TABLE appointment ADD (
    CONSTRAINT assistant_id_app_fk
    FOREIGN KEY (assistant_id)
    REFERENCES medical_employees(med_emp_id)
);

-- Crearea tabelului MEDICAL_PROBLEM

CREATE TABLE medical_problem
(
    med_prob_id         VARCHAR2(6)     NOT NULL,
    appointment_id      VARCHAR2(6)     NOT NULL,
    description_prob    VARCHAR2(30)
);

ALTER TABLE medical_problem ADD (
    CONSTRAINT med_prob_id_pk
    PRIMARY KEY
    (med_prob_id)
);

ALTER TABLE medical_problem ADD (
    CONSTRAINT appointment_id_mp_fk
    FOREIGN KEY (appointment_id)
    REFERENCES appointment(appointment_id)
);

-- Crearea tabelului DIAGNOSIS

CREATE TABLE diagnosis
(
    diagnosis_id        VARCHAR2(6)     NOT NULL,
    med_prob_id         VARCHAR2(6)     NOT NULL,
    fam_doctor_id       VARCHAR2(6)     NOT NULL,
    prescription_id     VARCHAR2(25)    NOT NULL,
    solved_id           VARCHAR2(25)    NOT NULL,
    under_obs_id        VARCHAR2(25),
    diagnosis_date      DATE            NOT NULL
);

ALTER TABLE diagnosis ADD (
    CONSTRAINT diagnosis_id_pk
    PRIMARY KEY
    (diagnosis_id)
);

ALTER TABLE diagnosis ADD (
    CONSTRAINT med_prob_id_dg_fk
    FOREIGN KEY (med_prob_id)
    REFERENCES medical_problem(med_prob_id)
);

ALTER TABLE diagnosis ADD (
    CONSTRAINT fam_doctor_id_dg_fk
    FOREIGN KEY (fam_doctor_id)
    REFERENCES medical_employees(med_emp_id)
);

-- Crearea tabelului MEDICAL_SOLUTION

CREATE TABLE medical_solution
(
    med_sol_id          VARCHAR2(25)    NOT NULL,
    diagnosis_id        VARCHAR2(6)     NOT NULL,
    specialist_doc_id   VARCHAR2(6)     NOT NULL,
    description_sol     VARCHAR2(30)
);

ALTER TABLE medical_solution ADD (
    CONSTRAINT med_sol_id_pk
    PRIMARY KEY
    (med_sol_id)
);

ALTER TABLE medical_solution ADD (
    CONSTRAINT diagnosis_id_ms_fk
    FOREIGN KEY (diagnosis_id)
    REFERENCES diagnosis(diagnosis_id)
);

ALTER TABLE medical_solution ADD (
    CONSTRAINT specialist_doc_id_ms_fk
    FOREIGN KEY (specialist_doc_id)
    REFERENCES medical_employees(med_emp_id)
);

-- Crearea tabelului ASSIGN

CREATE TABLE assign
(
    specialist_doc_id   VARCHAR2(6)     NOT NULL,
    assistant_id        VARCHAR2(6)     NOT NULL,
    diagnosis_id        VARCHAR2(6)     NOT NULL,
    CONSTRAINT assign_pk PRIMARY KEY (specialist_doc_id, assistant_id, diagnosis_id),
    CONSTRAINT assign_sdi_fk FOREIGN KEY (specialist_doc_id) REFERENCES medical_employees(med_emp_id),
    CONSTRAINT assign_ai_fk FOREIGN KEY (assistant_id) REFERENCES medical_employees(med_emp_id),
    CONSTRAINT assign_di_fk FOREIGN KEY (diagnosis_id) REFERENCES diagnosis(diagnosis_id)
);

-- INSERAREA IN TABELE --

-- inserarea in tabelul MEDICAL_CENTER

INSERT INTO medical_center VALUES
('RE1', 'AD100', 'RECUMED_GORJULUI', '715555987');

INSERT INTO medical_center VALUES
('RE2', 'AD101', 'RECUMED_ROMANA', '715555234');

-- inserarea in tabelul PATIENT

INSERT INTO patient VALUES 
(1, 'Popa Ana', '715555811');

INSERT INTO patient VALUES 
(2, 'Vasilescu Victor', '715555789');

INSERT INTO patient VALUES 
(3, 'Atudorei Andrei', '715458699');

INSERT INTO patient VALUES 
(4, 'Geman Sergiu', '715555811');

INSERT INTO patient VALUES 
(5, 'Ion Cristian', '715115889');

INSERT INTO patient VALUES 
(6, 'Pruteanu Gelu', '715335879');

INSERT INTO patient VALUES 
(7, 'Geman Amalia', '715335879');

INSERT INTO patient VALUES 
(8, 'Grigorescu Ingrid', '715335879');

INSERT INTO patient VALUES 
(9, 'Mihalachi Cristina', '715335879');

INSERT INTO patient VALUES 
(10, 'Bulgaru Rodica', '715335879');

-- inserarea in tabelul MEDICAL_EMPLOYEES

INSERT INTO medical_employees VALUES
(1, 'RE1', 'Ion', 'Florescu', '715110879', '2600', '1', '0', '0');

INSERT INTO medical_employees VALUES
(2, 'RE1', 'Ana', 'Minciunescu', '715300879', '4000', '0', '0', '1');

INSERT INTO medical_employees VALUES
(3, 'RE1', 'Florin', 'Mindrescu', '715125879', '5000', '0', '0', '1');

INSERT INTO medical_employees VALUES
(4, 'RE1', 'Andrei', 'Florescu', '715665879', '2600', '1', '0', '0');

INSERT INTO medical_employees VALUES
(5, 'RE1', 'Alex', 'Florea', '715337779', '2400', '1', '0', '0');

INSERT INTO medical_employees VALUES
(6, 'RE1', 'Mihai', 'Neagoe', '715300879', '4000', '0', '0', '1');

INSERT INTO medical_employees VALUES
(7, 'RE2', 'Miruna', 'Atudorei', '715115879', '3000', '1', '0', '0');

INSERT INTO medical_employees VALUES
(8, 'RE2', 'Cristian', 'Pucean', '715225879', '3600', '1', '0', '0');

INSERT INTO medical_employees VALUES
(9, 'RE2', 'Iulian', 'Hristea', '715388879', '2000', '0', '1', '0');

INSERT INTO medical_employees VALUES
(10, 'RE2', 'Gabriel', 'Fanaru', '715555879', '1700', '0', '1', '0');

INSERT INTO medical_employees VALUES
(11, 'RE2', 'Octavian', 'Florean', '715344879', '4000', '0', '0', '1');

INSERT INTO medical_employees VALUES
(12, 'RE2', 'Cosmina', 'Georgescu', '715535879', '7000', '0', '0', '1');

-- inserarea in tabelul APPOINTMENT

INSERT INTO appointment VALUES
('APP1', 'RE1', 1, 9, TO_DATE('08/10/2021', 'MM/DD/YYYY'), '110');

INSERT INTO appointment VALUES
('APP2', 'RE2', 2, 10, TO_DATE('09/20/2021', 'MM/DD/YYYY'), '150');

INSERT INTO appointment VALUES
('APP3', 'RE1', 3, 9, TO_DATE('10/01/2021', 'MM/DD/YYYY'), '200');

INSERT INTO appointment VALUES
('APP4', 'RE2', 4, 10, TO_DATE('11/11/2020', 'MM/DD/YYYY'), '250');

INSERT INTO appointment VALUES
('APP5', 'RE1', 5, 9, TO_DATE('02/20/2021', 'MM/DD/YYYY'), '110');

INSERT INTO appointment VALUES
('APP6', 'RE2', 6, 10, TO_DATE('01/17/2019', 'MM/DD/YYYY'), '150');

INSERT INTO appointment VALUES
('APP7', 'RE1', 6, 9, TO_DATE('08/10/2021', 'MM/DD/YYYY'), '220');

INSERT INTO appointment VALUES
('APP8', 'RE2', 7, 10, TO_DATE('08/20/2019', 'MM/DD/YYYY'), '210');

INSERT INTO appointment VALUES
('APP9', 'RE1', 8, 9, TO_DATE('03/31/2020', 'MM/DD/YYYY'), '200');

INSERT INTO appointment VALUES
('APP10', 'RE2', 8, 10, TO_DATE('10/11/2021', 'MM/DD/YYYY'), '150');

-- inserarea in tabelul MEDICAL_PROBLEM

INSERT INTO medical_problem VALUES
('MP1', 'APP1', 'GINECOLOGIE');

INSERT INTO medical_problem VALUES
('MP2', 'APP2', 'DERMATOLOGIE');

INSERT INTO medical_problem VALUES
('MP3', 'APP3', 'DERMATOLOGIE');

INSERT INTO medical_problem VALUES
('MP4', 'APP4', 'NEUROLOGIE');

INSERT INTO medical_problem VALUES
('MP5', 'APP5', 'STOMATOLOGIE');

INSERT INTO medical_problem VALUES
('MP6', 'APP6', 'STOMATOLOGIE');

INSERT INTO medical_problem VALUES
('MP7', 'APP7', 'RADIOLOGIE');

INSERT INTO medical_problem VALUES
('MP8', 'APP8', 'RADIOLOGIE');

-- inserarea in tabelul DIAGNOSIS

INSERT INTO diagnosis VALUES
('D1', 'MP1', 1, 'P100', '0', '0', TO_DATE('08/10/2021', 'MM/DD/YYYY'));

INSERT INTO diagnosis VALUES
('D2', 'MP2', 4, 'P101', '0', '0', TO_DATE('08/30/2021', 'MM/DD/YYYY'));

INSERT INTO diagnosis VALUES
('D4', 'MP4', 7, '0', '0', 'UO1', TO_DATE('12/10/2021', 'MM/DD/YYYY'));

INSERT INTO diagnosis VALUES
('D5', 'MP5', 8, '0', '0', 'UO2', TO_DATE('10/10/2021', 'MM/DD/YYYY'));

INSERT INTO diagnosis VALUES
('D6', 'MP6', 1, '0', 'S1', '0', TO_DATE('04/10/2021', 'MM/DD/YYYY'));

INSERT INTO diagnosis VALUES
('D7', 'MP7', 4, '0', 'S2', '0', TO_DATE('03/10/2021', 'MM/DD/YYYY'));

-- insearea in tabelul MEDICAL_SOLUTION 

INSERT INTO medical_solution VALUES
('MS1', 'D1', 12, 'Prescriptie medicala');

INSERT INTO medical_solution VALUES
('MS2', 'D2', 11, 'Prescriptie medicala');

INSERT INTO medical_solution VALUES
('MS3', 'D4', 6, 'Sub observatie');

INSERT INTO medical_solution VALUES
('MS4', 'D7', 2, 'Declarat sanatos');

INSERT INTO medical_solution VALUES
('MS5', 'D5', 3, 'Sub observatie');

INSERT INTO medical_solution VALUES
('MS6', 'D6', 11, 'Declarat sanatos');

---- inserarea in tabelul ASSIGN

INSERT INTO assign VALUES
(3, 9, 'D1');

INSERT INTO assign VALUES
(3, 10, 'D5');

INSERT INTO assign VALUES
(12, 9, 'D6');

INSERT INTO assign VALUES
(2, 10, 'D2');

INSERT INTO assign VALUES
(6, 10, 'D4');

INSERT INTO assign VALUES
(11, 9, 'D5');

INSERT INTO assign VALUES
(12, 10, 'D6');

INSERT INTO assign VALUES
(11, 9, 'D7');

INSERT INTO assign VALUES
(11, 10, 'D2');

INSERT INTO assign VALUES
(12, 10, 'D4');

COMMIT; 