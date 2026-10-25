
-- CREACIÓN DE ESQUEMA Y TABLAS FILTRADAS PARA PACIENTES CON DIABETES TIPO 1

CREATE SCHEMA IF NOT EXISTS mimi_diabetic;

-- Crear tabla con IDs de pacientes diabéticos tipo 1
CREATE TABLE mimi_diabetic.diabetic_patients_ids AS
SELECT DISTINCT subject_id
FROM mimi_hosp.diagnoses_icd
WHERE icd_code LIKE '250.01%' OR icd_code LIKE '250.03%' OR icd_code LIKE 'E10%';

-- Crear versiones filtradas de cada tabla en mimi_diabetic

-- Tabla patients
CREATE TABLE mimi_diabetic.patients AS
SELECT *
FROM mimi_hosp.patients
WHERE subject_id IN (SELECT subject_id FROM mimi_diabetic.diabetic_patients_ids);

-- Tabla admissions
CREATE TABLE mimi_diabetic.admissions AS
SELECT *
FROM mimi_hosp.admissions
WHERE subject_id IN (SELECT subject_id FROM mimi_diabetic.diabetic_patients_ids);

-- Tabla transfers
CREATE TABLE mimi_diabetic.transfers AS
SELECT *
FROM mimi_hosp.transfers
WHERE subject_id IN (SELECT subject_id FROM mimi_diabetic.diabetic_patients_ids);

-- Tabla diagnoses_icd
CREATE TABLE mimi_diabetic.diagnoses_icd AS
SELECT *
FROM mimi_hosp.diagnoses_icd
WHERE subject_id IN (SELECT subject_id FROM mimi_diabetic.diabetic_patients_ids);

-- Tabla drgcodes
CREATE TABLE mimi_diabetic.drgcodes AS
SELECT *
FROM mimi_hosp.drgcodes
WHERE subject_id IN (SELECT subject_id FROM mimi_diabetic.diabetic_patients_ids);

-- Tabla emar
CREATE TABLE mimi_diabetic.emar AS
SELECT *
FROM mimi_hosp.emar
WHERE subject_id IN (SELECT subject_id FROM mimi_diabetic.diabetic_patients_ids);

-- Tabla emar_detail
CREATE TABLE mimi_diabetic.emar_detail AS
SELECT *
FROM mimi_hosp.emar_detail
WHERE emar_id IN (SELECT emar_id FROM mimi_diabetic.emar);

-- Tabla hcpcsevents
CREATE TABLE mimi_diabetic.hcpcsevents AS
SELECT *
FROM mimi_hosp.hcpcsevents
WHERE subject_id IN (SELECT subject_id FROM mimi_diabetic.diabetic_patients_ids);

-- Tabla labevents
CREATE TABLE mimi_diabetic.labevents AS
SELECT *
FROM mimi_hosp.labevents
WHERE subject_id IN (SELECT subject_id FROM mimi_diabetic.diabetic_patients_ids);

-- Tabla microbiologyevents
CREATE TABLE mimi_diabetic.microbiologyevents AS
SELECT *
FROM mimi_hosp.microbiologyevents
WHERE subject_id IN (SELECT subject_id FROM mimi_diabetic.diabetic_patients_ids);

-- Tabla omr
CREATE TABLE mimi_diabetic.omr AS
SELECT *
FROM mimi_hosp.omr
WHERE subject_id IN (SELECT subject_id FROM mimi_diabetic.diabetic_patients_ids);

-- Tabla pharmacy
CREATE TABLE mimi_diabetic.pharmacy AS
SELECT *
FROM mimi_hosp.pharmacy
WHERE subject_id IN (SELECT subject_id FROM mimi_diabetic.diabetic_patients_ids);

-- Tabla poe
CREATE TABLE mimi_diabetic.poe AS
SELECT *
FROM mimi_hosp.poe
WHERE subject_id IN (SELECT subject_id FROM mimi_diabetic.diabetic_patients_ids);

-- Tabla poe_detail
CREATE TABLE mimi_diabetic.poe_detail AS
SELECT *
FROM mimi_hosp.poe_detail
WHERE poe_id IN (SELECT poe_id FROM mimi_diabetic.poe);

-- Tabla prescriptions
CREATE TABLE mimi_diabetic.prescriptions AS
SELECT *
FROM mimi_hosp.prescriptions
WHERE subject_id IN (SELECT subject_id FROM mimi_diabetic.diabetic_patients_ids);

-- Tabla procedures_icd
CREATE TABLE mimi_diabetic.procedures_icd AS
SELECT *
FROM mimi_hosp.procedures_icd
WHERE subject_id IN (SELECT subject_id FROM mimi_diabetic.diabetic_patients_ids);

-- Tabla services
CREATE TABLE mimi_diabetic.services AS
SELECT *
FROM mimi_hosp.services
WHERE subject_id IN (SELECT subject_id FROM mimi_diabetic.diabetic_patients_ids);
