DROP TABLE addresses;
DROP TABLE type_of_medical_center;
DROP TABLE medical_centers;
DROP TABLE hospital;
DROP TABLE pharmacies;
DROP TABLE patient;
DROP TABLE appointments;
DROP TABLE payment;
DROP TABLE medical_employee_specialization;
DROP TABLE medical_employees;
DROP TABLE performed;
DROP TABLE registered;

CREATE TABLE addresses
(
    address_id      VARCHAR2(25)        NOT NULL,
    city_name       VARCHAR2(15)        NOT NULL,
    street_name     VARCHAR2(15)        NOT NULL,
    number_building NUMBER,
    ZIP_code        VARCHAR2(6)         NOT NULL,
    country         VARCHAR2(10)        NOT NULL
);

ALTER TABLE addresses ADD (
    CONSTRAINT address_id_pk
    PRIMARY KEY
    (address_id)
);

CREATE TABLE type_of_medical_center
(
    med_cntr_type_code      VARCHAR2(6)     NOT NULL,
    med_cntr_description    VARCHAR2(30)
);

ALTER TABLE type_of_medical_center ADD (
    CONSTRAINT med_cntr_type_code_pk
    PRIMARY KEY
    (med_cntr_type_code)
);

CREATE TABLE medical_centers
(
    med_cntr_id             VARCHAR2(6)     NOT NULL,
    address_id              VARCHAR2(25)    NOT NULL,
    med_cntr_type_code      VARCHAR2(30)    NOT NULL,
    medical_center_name     VARCHAR2(30)    NOT NULL,
    medical_center_manager  VARCHAR2(30),
    medical_center_contact  VARCHAR2(10)    NOT NULL
);

ALTER TABLE medical_centers ADD (
    CONSTRAINT med_cntr_id_pk
    PRIMARY KEY
    (med_cntr_id)
);

ALTER TABLE medical_centers ADD (
    CONSTRAINT address_id_fk
    FOREIGN KEY (address_id)
    REFERENCES addresses(address_id)
);

ALTER TABLE medical_centers ADD (
    CONSTRAINT med_cntr_type_code_fk
    FOREIGN KEY (med_cntr_type_code)
    REFERENCES type_of_medical_center(med_cntr_type_code)
);

CREATE TABLE hospital
(
    hospital_id         VARCHAR2(6)     NOT NULL,
    address_id          VARCHAR2(25)    NOT NULL,
    hospital_name       VARCHAR2(30)    NOT NULL,
    hospital_manager    VARCHAR2(30),
    hospital_contact    VARCHAR2(10)    NOT NULL
);

ALTER TABLE hospital ADD (
    CONSTRAINT hospital_id_pk
    PRIMARY KEY
    (hospital_id)
);

ALTER TABLE hospital ADD (
    CONSTRAINT address_id_hsp_fk
    FOREIGN KEY (address_id)
    REFERENCES addresses(address_id)
);

CREATE TABLE pharmacies
(
    pharmacy_id         VARCHAR2(6)     NOT NULL,
    address_id          VARCHAR2(25)    NOT NULL,
    pharmacy_name       VARCHAR2(25)    NOT NULL,
    pharmacy_program    VARCHAR2(10),
    pharmacy_contact    VARCHAR2(10)    NOT NULL
);

ALTER TABLE pharmacies ADD (
    CONSTRAINT pharmacy_id_pk
    PRIMARY KEY
    (pharmacy_id)
);

ALTER TABLE pharmacies ADD (
    CONSTRAINT address_id_phr_fk
    FOREIGN KEY (address_id)
    REFERENCES addresses(address_id)
);

CREATE TABLE patient
(
    patient_id      VARCHAR2(6)     NOT NULL,
    med_cntr_id     VARCHAR2(6)     NOT NULL,
    address_id      VARCHAR2(25)    NOT NULL,
    patient_last    VARCHAR2(30)    NOT NULL,
    patient_first   VARCHAR2(30),
    patient_ci      VARCHAR2(15),
    patient_age     NUMBER(3),
    patient_sex     CHAR(2)         NOT NULL,
    date_of_birth   DATE,
    CONSTRAINT patient_sex_cc CHECK ((patient_sex = 'F') OR (patient_sex = 'M'))
);

ALTER TABLE patient ADD (
    CONSTRAINT patient_id_pk
    PRIMARY KEY
    (patient_id)
);

ALTER TABLE patient ADD (
    CONSTRAINT med_cntr_id_pt_fk
    FOREIGN KEY (med_cntr_id)
    REFERENCES medical_centers(med_cntr_id)
);

ALTER TABLE patient ADD (
    CONSTRAINT address_id_pt_fk
    FOREIGN KEY (address_id)
    REFERENCES addresses(address_id)
);

CREATE TABLE appointments
(
    appointment_id          VARCHAR2(6)     NOT NULL,
    patient_id              VARCHAR2(6)     NOT NULL,
    medical_prescription    VARCHAR2(30),
    appt_date               DATE            NOT NULL,
    appt_time               DATE            NOT NULL
);

ALTER TABLE appointments ADD (
    CONSTRAINT appointment_id_pk
    PRIMARY KEY
    (appointment_id)
);

ALTER TABLE appointments ADD (
    CONSTRAINT patient_id_app_fk
    FOREIGN KEY (patient_id)
    REFERENCES patient(patient_id)
);

CREATE TABLE payment
(
    payment_id          VARCHAR2(6)     NOT NULL,
    appointment_id      VARCHAR2(6)     NOT NULL,
    payment_type        CHAR(4),
    payment_sum         NUMBER(6),
    CONSTRAINT payment_type_cc CHECK ((payment_type = 'CARD') OR (payment_type = 'CASH'))
);

ALTER TABLE payment ADD (
    CONSTRAINT payment_id_pk
    PRIMARY KEY
    (payment_id)
);

ALTER TABLE payment ADD (
    CONSTRAINT appointment_id_py_fk
    FOREIGN KEY (appointment_id)
    REFERENCES appointments(appointment_id)
);

CREATE TABLE medical_employee_specialization
(
    spcl_code           VARCHAR2(6)     NOT NULL,
    spcl_name           VARCHAR2(15)    NOT NULL,
    spcl_description    VARCHAR2(30)
);

ALTER TABLE medical_employee_specialization ADD (
    CONSTRAINT spcl_code_pk
    PRIMARY KEY
    (spcl_code)
);

CREATE TABLE medical_employees
(
    med_empl_id         VARCHAR2(6)     NOT NULL,
    spcl_code           VARCHAR2(6)     NOT NULL,
    med_empl_program    VARCHAR2(10),
    med_empl_sex        CHAR(2)         NOT NULL,
    med_empl_age        NUMBER(3),
    CONSTRAINT med_empl_sex_cc CHECK ((med_empl_sex = 'F') OR (med_empl_sex = 'M'))
);

ALTER TABLE medical_employees ADD (
    CONSTRAINT med_empl_id_pk
    PRIMARY KEY
    (med_empl_id)
);

ALTER TABLE medical_employees ADD (
    CONSTRAINT spcl_code_fk
    FOREIGN KEY (spcl_code)
    REFERENCES medical_employee_specialization(spcl_code)
);

CREATE TABLE performed
(
    med_empl_id         VARCHAR2(6)     NOT NULL,
    appointment_id      VARCHAR2(6)     NOT NULL,
    CONSTRAINT performed_pk PRIMARY KEY (med_empl_id, appointment_id),
    CONSTRAINT performed_mei_fk FOREIGN KEY (med_empl_id) REFERENCES medical_employees(med_empl_id),
    CONSTRAINT performed_appi_fk FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

CREATE TABLE registered
(
    med_cntr_id     VARCHAR2(6)     NOT NULL,
    patient_id      VARCHAR2(6)     NOT NULL,
    CONSTRAINT registered_pk PRIMARY KEY (med_cntr_id, patient_id),
    CONSTRAINT registered_mci_fk FOREIGN KEY (med_cntr_id) REFERENCES medical_centers(med_cntr_id),
    CONSTRAINT registered_pi_fk FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
);

---- inserting into addresses table
INSERT INTO addresses VALUES
('AD100', 'Vaslui', 'Pacii', '300', '630232', 'Romania');

INSERT INTO addresses VALUES
('AD101', 'Bucuresti', 'Nordului', '201', '700232', 'Romania');

INSERT INTO addresses VALUES
('AD102', 'Timisoara', 'Iancului', '332', '405222', 'Romania');

INSERT INTO addresses VALUES
('AD103', 'Iasi', 'Sudului', '23', '654900', 'Romania');

INSERT INTO addresses VALUES
('AD104', 'Vaslui', 'Republicii', '1', '900744', 'Romania');

INSERT INTO addresses VALUES
('AD105', 'Cluj', 'Florilor', '80', '922122', 'Romania');

INSERT INTO addresses VALUES
('AD106', 'Cluj', 'Scolii', '84', '920120', 'Romania');

INSERT INTO addresses VALUES
('AD107', 'Vaslui', 'Stefan cel Mare', '93', '882122', 'Romania');

INSERT INTO addresses VALUES
('AD108', 'Constanta', 'Libertatii', '12', '677322', 'Romania');

INSERT INTO addresses VALUES
('AD109', 'Bucuresti', 'Trandafirilor', '1', '900500', 'Romania');

INSERT INTO addresses VALUES
('AD110', 'Iasi', 'Castanilor', '100', '911500', 'Romania');

INSERT INTO addresses VALUES
('AD111', 'Constanta', 'Marii', '105', '911510', 'Romania');

INSERT INTO addresses VALUES
('AD112', 'Timisoara', 'Timisului', '10', '800400', 'Romania');

---- inserting into type_of_medical_center table
INSERT INTO type_of_medical_center VALUES
('RDG1', 'RADIOLOGIE');

INSERT INTO type_of_medical_center VALUES
('EST2', 'ESTETICA');

INSERT INTO type_of_medical_center VALUES
('ONC3', 'ONCOLOGIE');

INSERT INTO type_of_medical_center VALUES
('GNC4', 'GINECOLOGIE');

INSERT INTO type_of_medical_center VALUES
('ORT5', 'ORTOPEDIE');

INSERT INTO type_of_medical_center VALUES
('KNT6', 'KINETOTERAPIE');

---- inserting into medical_centers table
INSERT INTO medical_centers VALUES
('RE', 'AD100', 'RDG1', 'RECUMED', 'Petrescu Ion', '7155559876');

INSERT INTO medical_centers VALUES
('RO', 'AD101', 'EST2', 'RODERMA', 'Florea Geta', '7155552345');

INSERT INTO medical_centers VALUES
('ML', 'AD102', 'ONC3', 'MEDLIFE', 'Grigorescu Ioana', '7155553907');

INSERT INTO medical_centers VALUES
('TC', 'AD103', 'GNC4', 'TEOCLINICK', 'Petrescu Ionut', '7155556902');

INSERT INTO medical_centers VALUES
('AR', 'AD104', 'ORT5', 'ARCADIA', 'Iopsu Ciprian', '7155558899');

INSERT INTO medical_centers VALUES
('CE', 'AD105', 'KNT6', 'CLINICA_EMINESCU', 'Popescu Andrei', '7155554944');

---- inserting into hospital table
INSERT INTO hospital VALUES
('HS1', 'AD100', 'Spitalul de Radiologie', 'Petrescu Ion', '7155559876');

INSERT INTO hospital VALUES
('HS2', 'AD106', 'Spitalul de Urgente', 'Apostu Mihai', '7756665900');

INSERT INTO hospital VALUES
('HS3', 'AD107', 'Spitalul Alecsandri', 'Petrache Ioan', '7098564900');

INSERT INTO hospital VALUES
('HS4', 'AD108', 'Spitalul Sud', 'Micle Veronica', '7070564565');

INSERT INTO hospital VALUES
('HS5', 'AD109', 'Spitalul Nord', 'Pop Petru', '7765432998');

---- inserting into pharmacies table
INSERT INTO pharmacies VALUES
('PH1', 'AD100', 'Radfarm', '24h', '7115533440');

INSERT INTO pharmacies VALUES
('PH2', 'AD106', 'UrgentFarm', '24h', '7755664343');

INSERT INTO pharmacies VALUES
('PH3', 'AD110', 'Plantago', '12h', '7223346490');

INSERT INTO pharmacies VALUES
('PH4', 'AD111', 'Catena', '8h', '7075544565');

INSERT INTO pharmacies VALUES
('PH5', 'AD112', 'Dona', '12h', '7733223199');

---- inserting into patient table
INSERT INTO patient (patient_id, med_cntr_id, address_id, patient_last, patient_first, patient_ci, patient_age, patient_sex, date_of_birth ) VALUES (1, 'RE', 'AD100', 'Popa', 'Ana', 'VS', 33, 'F', TO_DATE('08/19/1989', 'MM/DD/YYYY'));

INSERT INTO patient (patient_id, med_cntr_id, address_id, patient_last, patient_first, patient_ci, patient_age, patient_sex, date_of_birth ) VALUES (2, 'RO', 'AD101', 'Vasilescu', 'Victor', 'B', 25, 'M', TO_DATE('09/29/1997', 'MM/DD/YYYY'));

INSERT INTO patient (patient_id, med_cntr_id, address_id, patient_last, patient_first, patient_ci, patient_age, patient_sex, date_of_birth ) VALUES (3, 'AR', 'AD102', 'Atudorei', 'Andrei', 'B', 56, 'M', TO_DATE('10/15/1966', 'MM/DD/YYYY'));

INSERT INTO patient (patient_id, med_cntr_id, address_id, patient_last, patient_first, patient_ci, patient_age, patient_sex, date_of_birth ) VALUES (4, 'ML', 'AD103', 'Geman', 'Sergiu', 'IS', 41, 'M', TO_DATE('11/19/1981', 'MM/DD/YYYY'));

INSERT INTO patient (patient_id, med_cntr_id, address_id, patient_last, patient_first, patient_ci, patient_age, patient_sex, date_of_birth ) VALUES (5, 'TC', 'AD104', 'Ion', 'Cristian', 'IS', 30, 'M', TO_DATE('02/01/1991', 'MM/DD/YYYY'));

INSERT INTO patient (patient_id, med_cntr_id, address_id, patient_last, patient_first, patient_ci, patient_age, patient_sex, date_of_birth ) VALUES (6, 'CE', 'AD105', 'Pruteanu', 'Gelu', 'CJ', 28, 'M', TO_DATE('01/10/1993', 'MM/DD/YYYY'));

---- inserting into appointments table
INSERT INTO appointments VALUES
('APP1', '1', 'Abces pulmonar', TO_DATE('08/10/2021', 'MM/DD/YYYY'), TO_DATE('10:00 AM', 'HH:MI AM'));

INSERT INTO appointments VALUES
('APP2', '2', 'Abces pulmonar', TO_DATE('09/20/2021', 'MM/DD/YYYY'), TO_DATE('11:00 AM', 'HH:MI AM'));

INSERT INTO appointments VALUES
('APP3', '3', 'Cataracta', TO_DATE('10/01/2021', 'MM/DD/YYYY'), TO_DATE('12:00 AM', 'HH:MI AM'));

INSERT INTO appointments VALUES
('APP4', '4', 'Cataracta', TO_DATE('11/11/2020', 'MM/DD/YYYY'), TO_DATE('09:00 AM', 'HH:MI AM'));

INSERT INTO appointments VALUES
('APP5', '5', 'Conjunctivita', TO_DATE('02/20/2021', 'MM/DD/YYYY'), TO_DATE('08:00 AM', 'HH:MI AM'));

INSERT INTO appointments VALUES
('APP6', '6', 'COVID-19', TO_DATE('01/17/2019', 'MM/DD/YYYY'), TO_DATE('07:00 AM', 'HH:MI AM'));

INSERT INTO appointments VALUES
('APP7', '6', 'Conjunctivita', TO_DATE('08/10/2021', 'MM/DD/YYYY'), TO_DATE('10:00 AM', 'HH:MI AM'));

INSERT INTO appointments VALUES
('APP8', '4', 'Gastrita', TO_DATE('08/20/2019', 'MM/DD/YYYY'), TO_DATE('11:00 AM', 'HH:MI AM'));

INSERT INTO appointments VALUES
('APP9', '5', 'COVID-19', TO_DATE('03/31/2020', 'MM/DD/YYYY'), TO_DATE('12:00 AM', 'HH:MI AM'));

INSERT INTO appointments VALUES
('APP10', '2', 'Gripa', TO_DATE('10/11/2021', 'MM/DD/YYYY'), TO_DATE('04:00 PM', 'HH:MI PM'));

INSERT INTO appointments VALUES
('APP11', '1', 'Febra', TO_DATE('04/20/2021', 'MM/DD/YYYY'), TO_DATE('03:00 PM', 'HH:MI PM'));

INSERT INTO appointments VALUES
('APP12', '3', 'Fractura', TO_DATE('03/31/2020', 'MM/DD/YYYY'), TO_DATE('02:00 PM', 'HH:MI PM'));

INSERT INTO appointments VALUES
('APP13', '1', 'Fractura Umar', TO_DATE('10/20/2021', 'MM/DD/YYYY'), TO_DATE('02:00 PM', 'HH:MI PM'));

---- inserting into payment table
INSERT INTO payment VALUES
('PY1', 'APP1', 'CASH', 100);

INSERT INTO payment VALUES
('PY2', 'APP2', 'CASH', 100);

INSERT INTO payment VALUES
('PY3', 'APP3', 'CARD', 200);

INSERT INTO payment VALUES
('PY4', 'APP4', 'CARD', 200);

INSERT INTO payment VALUES
('PY5', 'APP5', 'CASH', 400);

INSERT INTO payment VALUES
('PY6', 'APP13', 'CARD', 110);

---- inserting into medical_employee_specialization table
INSERT INTO medical_employee_specialization VALUES
('CRD', 'Cardiolog', NULL);

INSERT INTO medical_employee_specialization VALUES
('DRM', 'DERMATOLOG', NULL);

INSERT INTO medical_employee_specialization VALUES
('GNC', 'GINECOLOG', NULL);

INSERT INTO medical_employee_specialization VALUES
('NRG', 'NEUROLOG', NULL);

INSERT INTO medical_employee_specialization VALUES
('STM', 'STOMATOLOG', NULL);

INSERT INTO medical_employee_specialization VALUES
('RDG', 'RADIOLOG', NULL);

---- inserting into medical_employees table
INSERT INTO medical_employees VALUES
('ME1', 'CRD', '24h', 'F', '40');

INSERT INTO medical_employees VALUES
('ME2', 'DRM', '24h', 'F', NULL);

INSERT INTO medical_employees VALUES
('ME3', 'GNC', '12h', 'M', '45');

INSERT INTO medical_employees VALUES
('ME4', 'NRG', '12h', 'M', '37');

INSERT INTO medical_employees VALUES
('ME5', 'STM', '8h', 'F', '29');

INSERT INTO medical_employees VALUES
('ME6', 'RDG', '6h', 'M', '33');

---- inserting into performed table
INSERT INTO performed VALUES
('ME1', 'APP1');

INSERT INTO performed VALUES
('ME1', 'APP2');

INSERT INTO performed VALUES
('ME2', 'APP3');

INSERT INTO performed VALUES
('ME2', 'APP4');

INSERT INTO performed VALUES
('ME3', 'APP5');

INSERT INTO performed VALUES
('ME3', 'APP6');

INSERT INTO performed VALUES
('ME4', 'APP7');

INSERT INTO performed VALUES
('ME4', 'APP8');

INSERT INTO performed VALUES
('ME5', 'APP9');

INSERT INTO performed VALUES
('ME5', 'APP10');

INSERT INTO performed VALUES
('ME6', 'APP11');

INSERT INTO performed VALUES
('ME6', 'APP12');

---- inserting into registered table
INSERT INTO registered VALUES
('RE', '1');

INSERT INTO registered VALUES
('RE', '2');

INSERT INTO registered VALUES
('RO', '3');

INSERT INTO registered VALUES
('RO', '4');

INSERT INTO registered VALUES
('ML', '5');

INSERT INTO registered VALUES
('ML', '6');

INSERT INTO registered VALUES
('TC', '1');

INSERT INTO registered VALUES
('TC', '2');

INSERT INTO registered VALUES
('AR', '3');

INSERT INTO registered VALUES
('AR', '4');

INSERT INTO registered VALUES
('CE', '5');

INSERT INTO registered VALUES
('CE', '6');

COMMIT;