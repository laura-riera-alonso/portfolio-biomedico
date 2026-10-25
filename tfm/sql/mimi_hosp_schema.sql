
-- CREACIÓN DE ESQUEMA Y TABLAS CON CLAVES PRIMARIAS Y FORÁNEAS PARA MIMIC-IV (HOSPITALIZACIÓN)

CREATE SCHEMA IF NOT EXISTS mimi_hosp;

-- 1. Tabla patients
CREATE TABLE mimi_hosp.patients (
    subject_id INT PRIMARY KEY,
    gender VARCHAR(10),
    anchor_age INT,
    anchor_year INT,
    anchor_year_group VARCHAR(20),
    dob DATE
);

-- 2. Tabla admissions
CREATE TABLE mimi_hosp.admissions (
    hadm_id INT PRIMARY KEY,
    subject_id INT REFERENCES mimi_hosp.patients(subject_id),
    admittime TIMESTAMP,
    dischtime TIMESTAMP,
    deathtime TIMESTAMP,
    admission_type VARCHAR(50),
    admission_location VARCHAR(50),
    discharge_location VARCHAR(50),
    insurance VARCHAR(50),
    language VARCHAR(10),
    marital_status VARCHAR(50),
    ethnicity VARCHAR(50),
    edregtime TIMESTAMP,
    edouttime TIMESTAMP,
    hospital_expire_flag INT
);

-- 3. Tabla transfers
CREATE TABLE mimi_hosp.transfers (
    transfer_id SERIAL PRIMARY KEY,
    hadm_id INT REFERENCES mimi_hosp.admissions(hadm_id),
    subject_id INT REFERENCES mimi_hosp.patients(subject_id),
    careunit VARCHAR(50),
    intime TIMESTAMP,
    outtime TIMESTAMP
);

-- 4. Tabla d_hcpcs
CREATE TABLE mimi_hosp.d_hcpcs (
    code VARCHAR(20) PRIMARY KEY,
    category VARCHAR(100),
    long_description TEXT
);

-- 5. Tabla d_icd_diagnoses
CREATE TABLE mimi_hosp.d_icd_diagnoses (
    icd_code VARCHAR(10) PRIMARY KEY,
    icd_version INT,
    long_title TEXT
);

-- 6. Tabla d_labitems
CREATE TABLE mimi_hosp.d_labitems (
    itemid INT PRIMARY KEY,
    label VARCHAR(100),
    fluid VARCHAR(50),
    category VARCHAR(50),
    loinc_code VARCHAR(20)
);

-- 7. Tabla diagnoses_icd
CREATE TABLE mimi_hosp.diagnoses_icd (
    subject_id INT REFERENCES mimi_hosp.patients(subject_id),
    hadm_id INT REFERENCES mimi_hosp.admissions(hadm_id),
    seq_num INT,
    icd_code VARCHAR(10) REFERENCES mimi_hosp.d_icd_diagnoses(icd_code),
    icd_version INT
);

-- 8. Tabla drgcodes
CREATE TABLE mimi_hosp.drgcodes (
    subject_id INT REFERENCES mimi_hosp.patients(subject_id),
    hadm_id INT REFERENCES mimi_hosp.admissions(hadm_id),
    drg_type VARCHAR(20),
    drg_code VARCHAR(20),
    description TEXT
);

-- 9. Tabla emar
CREATE TABLE mimi_hosp.emar (
    emar_id VARCHAR(30) PRIMARY KEY,
    subject_id INT REFERENCES mimi_hosp.patients(subject_id),
    hadm_id INT REFERENCES mimi_hosp.admissions(hadm_id),
    emar_seq INT,
    pharmacy_id VARCHAR(30),
    medication VARCHAR(200),
    medication_type VARCHAR(50)
);

-- 10. Tabla emar_detail
CREATE TABLE mimi_hosp.emar_detail (
    emar_detail_id VARCHAR(30) PRIMARY KEY,
    emar_id VARCHAR(30) REFERENCES mimi_hosp.emar(emar_id),
    dose_given FLOAT,
    dose_unit VARCHAR(20)
);

-- 11. Tabla hcpcsevents
CREATE TABLE mimi_hosp.hcpcsevents (
    subject_id INT REFERENCES mimi_hosp.patients(subject_id),
    hadm_id INT REFERENCES mimi_hosp.admissions(hadm_id),
    chartdate DATE,
    seq_num INT,
    hcpcs_code VARCHAR(20) REFERENCES mimi_hosp.d_hcpcs(code)
);

-- 12. Tabla labevents
CREATE TABLE mimi_hosp.labevents (
    labevent_id SERIAL PRIMARY KEY,
    subject_id INT REFERENCES mimi_hosp.patients(subject_id),
    hadm_id INT REFERENCES mimi_hosp.admissions(hadm_id),
    itemid INT REFERENCES mimi_hosp.d_labitems(itemid),
    charttime TIMESTAMP,
    value VARCHAR(100),
    valuenum FLOAT,
    valueuom VARCHAR(20)
);

-- 13. Tabla microbiologyevents
CREATE TABLE mimi_hosp.microbiologyevents (
    microevent_id SERIAL PRIMARY KEY,
    subject_id INT REFERENCES mimi_hosp.patients(subject_id),
    hadm_id INT REFERENCES mimi_hosp.admissions(hadm_id),
    chartdate DATE,
    spec_itemid INT,
    org_itemid INT,
    ab_itemid INT
);

-- 14. Tabla omr
CREATE TABLE mimi_hosp.omr (
    subject_id INT REFERENCES mimi_hosp.patients(subject_id),
    chartdate DATE,
    category VARCHAR(50),
    result_name VARCHAR(100),
    result_value VARCHAR(100)
);

-- 15. Tabla pharmacy
CREATE TABLE mimi_hosp.pharmacy (
    pharmacy_id VARCHAR(30) PRIMARY KEY,
    subject_id INT REFERENCES mimi_hosp.patients(subject_id),
    hadm_id INT REFERENCES mimi_hosp.admissions(hadm_id),
    drug VARCHAR(200),
    formulary_drug_cd VARCHAR(100),
    dose_val_rx VARCHAR(50),
    dose_unit_rx VARCHAR(20),
    route VARCHAR(50)
);

-- 16. Tabla poe
CREATE TABLE mimi_hosp.poe (
    poe_id VARCHAR(30) PRIMARY KEY,
    subject_id INT REFERENCES mimi_hosp.patients(subject_id),
    hadm_id INT REFERENCES mimi_hosp.admissions(hadm_id),
    order_type VARCHAR(50),
    order_subtype VARCHAR(50),
    order_category VARCHAR(50),
    order_status VARCHAR(50)
);

-- 17. Tabla poe_detail
CREATE TABLE mimi_hosp.poe_detail (
    poe_detail_id VARCHAR(30) PRIMARY KEY,
    poe_id VARCHAR(30) REFERENCES mimi_hosp.poe(poe_id),
    field_name VARCHAR(100),
    field_value TEXT
);

-- 18. Tabla prescriptions
CREATE TABLE mimi_hosp.prescriptions (
    prescription_id SERIAL PRIMARY KEY,
    subject_id INT REFERENCES mimi_hosp.patients(subject_id),
    hadm_id INT REFERENCES mimi_hosp.admissions(hadm_id),
    drug VARCHAR(200),
    dose_val_rx VARCHAR(50),
    dose_unit_rx VARCHAR(20),
    route VARCHAR(50),
    startdate TIMESTAMP,
    enddate TIMESTAMP
);

-- 19. Tabla procedures_icd
CREATE TABLE mimi_hosp.procedures_icd (
    subject_id INT REFERENCES mimi_hosp.patients(subject_id),
    hadm_id INT REFERENCES mimi_hosp.admissions(hadm_id),
    seq_num INT,
    icd_code VARCHAR(10),
    icd_version INT
);

-- 20. Tabla services
CREATE TABLE mimi_hosp.services (
    subject_id INT REFERENCES mimi_hosp.patients(subject_id),
    hadm_id INT REFERENCES mimi_hosp.admissions(hadm_id),
    transfertime TIMESTAMP,
    prev_service VARCHAR(20),
    curr_service VARCHAR(20)
);
