
------------------------
-- Verificación de esquemas creados
------------------------

SELECT tablename, schemaname 
FROM pg_tables 
WHERE schemaname IN ('mimi_hosp');

-- Para ejecutar desde la terminal:
--  psql "dbname=mimi user=<USER>" -v data_dir='<PATH_TO_DATA>' -f load_data.sql

------------------------
-- Carga de datos en el esquema mimi_hosp
------------------------

COPY mimi_hosp.patients FROM :data_dir || '/patients.csv' DELIMITER ',' CSV HEADER NULL '';
COPY mimi_hosp.admissions FROM :data_dir || '/admissions.csv' DELIMITER ',' CSV HEADER NULL '';
COPY mimi_hosp.transfers FROM :data_dir || '/transfers.csv' DELIMITER ',' CSV HEADER NULL '';

COPY mimi_hosp.d_hcpcs FROM :data_dir || '/d_hcpcs.csv' DELIMITER ',' CSV HEADER NULL '';
COPY mimi_hosp.d_icd_diagnoses FROM :data_dir || '/d_icd_diagnoses.csv' DELIMITER ',' CSV HEADER NULL '';
COPY mimi_hosp.d_labitems FROM :data_dir || '/d_labitems.csv' DELIMITER ',' CSV HEADER NULL '';

COPY mimi_hosp.diagnoses_icd FROM :data_dir || '/diagnoses_icd.csv' DELIMITER ',' CSV HEADER NULL '';
COPY mimi_hosp.drgcodes FROM :data_dir || '/drgcodes.csv' DELIMITER ',' CSV HEADER NULL '';
COPY mimi_hosp.emar FROM :data_dir || '/emar.csv' DELIMITER ',' CSV HEADER NULL '';
COPY mimi_hosp.emar_detail FROM :data_dir || '/emar_detail.csv' DELIMITER ',' CSV HEADER NULL '';
COPY mimi_hosp.hcpcsevents FROM :data_dir || '/hcpcsevents.csv' DELIMITER ',' CSV HEADER NULL '';
COPY mimi_hosp.labevents FROM :data_dir || '/labevents.csv' DELIMITER ',' CSV HEADER NULL '';
COPY mimi_hosp.microbiologyevents FROM :data_dir || '/microbiologyevents.csv' DELIMITER ',' CSV HEADER NULL '';
COPY mimi_hosp.omr FROM :data_dir || '/omr.csv' DELIMITER ',' CSV HEADER NULL '';
COPY mimi_hosp.pharmacy FROM :data_dir || '/pharmacy.csv' DELIMITER ',' CSV HEADER NULL '';
COPY mimi_hosp.poe FROM :data_dir || '/poe.csv' DELIMITER ',' CSV HEADER NULL '';
COPY mimi_hosp.poe_detail FROM :data_dir || '/poe_detail.csv' DELIMITER ',' CSV HEADER NULL '';
COPY mimi_hosp.prescriptions FROM :data_dir || '/prescriptions.csv' DELIMITER ',' CSV HEADER NULL '';
COPY mimi_hosp.procedures_icd FROM :data_dir || '/procedures_icd.csv' DELIMITER ',' CSV HEADER NULL '';
COPY mimi_hosp.services FROM :data_dir || '/services.csv' DELIMITER ',' CSV HEADER NULL '';

------------------------
-- Comprobación de filas cargadas
------------------------

SELECT 'patients', COUNT(*) FROM mimi_hosp.patients;
SELECT 'admissions', COUNT(*) FROM mimi_hosp.admissions;
SELECT 'transfers', COUNT(*) FROM mimi_hosp.transfers;
SELECT 'pharmacy', COUNT(*) FROM mimi_hosp.pharmacy;
SELECT 'microbiologyevents', COUNT(*) FROM mimi_hosp.microbiologyevents;
SELECT 'labevents', COUNT(*) FROM mimi_hosp.labevents;
SELECT 'prescriptions', COUNT(*) FROM mimi_hosp.prescriptions;
