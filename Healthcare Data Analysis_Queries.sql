

-- PRSQL-02 Medical Data History 

-- 1. Male patients
SELECT first_name, last_name, gender FROM patients WHERE gender = 'M';

-- 2. Patients without allergies
SELECT first_name, last_name FROM patients WHERE allergies IS NULL;

-- 3. Patients whose first name starts with 'C'
SELECT first_name FROM patients WHERE first_name LIKE 'C%';

-- 4. Patients with weight between 100 and 120
SELECT first_name, last_name FROM patients WHERE weight BETWEEN 100 AND 120;

-- 5. Update NULL allergies to 'NKA'
UPDATE patients SET allergies = 'NKA' WHERE allergies IS NULL;

-- 6. Full name (concatenated)
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM patients;

-- 7. Patients with full province name
SELECT p.first_name, p.last_name, pn.province_name
FROM patients p
JOIN province_names pn ON p.province_id = pn.province_id;

-- 8. Count of patients born in 2010
SELECT COUNT(*) FROM patients WHERE YEAR(birth_date) = 2010;

-- 9. Patient with greatest height
SELECT first_name, last_name, height
FROM patients
WHERE height = (SELECT MAX(height) FROM patients);

-- 10. Patients with specific IDs
SELECT * FROM patients WHERE patient_id IN (1, 45, 534, 879, 1000);

-- 11. Total number of admissions
SELECT COUNT(*) FROM admissions;

-- 12. Admissions on same day
SELECT * FROM admissions WHERE admission_date = discharge_date;

-- 13. Total admissions for patient_id 579
SELECT COUNT(*) FROM admissions WHERE patient_id = 579;

-- 14. Unique cities in province_id 'NS'
SELECT DISTINCT city FROM patients WHERE province_id = 'NS';

-- 15. Patients with height > 160 and weight > 70
SELECT first_name, last_name, birth_date
FROM patients
WHERE height > 160 AND weight > 70;

-- 16. Unique birth years ordered
SELECT DISTINCT YEAR(birth_date) AS birth_year FROM patients ORDER BY birth_year;

-- 17. Unique first names (appear only once)
SELECT first_name
FROM patients
GROUP BY first_name
HAVING COUNT(*) = 1;

-- 18. First names start and end with 's' and at least 6 characters
SELECT patient_id, first_name
FROM patients
WHERE first_name LIKE 's%' AND first_name LIKE '%s' AND LENGTH(first_name) >= 6;

-- 19. Patients with diagnosis 'Dementia'
SELECT p.patient_id, p.first_name, p.last_name
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
WHERE a.diagnosis = 'Dementia';

-- 20. First names ordered by length then alphabetically
SELECT first_name
FROM patients
ORDER BY LENGTH(first_name), first_name;

-- 21. Male and female patient counts in same row
SELECT
  SUM(CASE WHEN gender = 'M' THEN 1 ELSE 0 END) AS male_count,
  SUM(CASE WHEN gender = 'F' THEN 1 ELSE 0 END) AS female_count
FROM patients;

-- 22. (SAME QUERY AS 21 )

-- 23. Patients admitted multiple times for same diagnosis
SELECT patient_id, diagnosis
FROM admissions
GROUP BY patient_id, diagnosis
HAVING COUNT(*) > 1;

-- 24. Total patients per city
SELECT city, COUNT(*) AS patient_count
FROM patients
GROUP BY city
ORDER BY patient_count DESC, city ASC;

-- 25. Names and roles from patients and doctors
SELECT first_name, last_name, 'Patient' AS role FROM patients
UNION
SELECT first_name, last_name, 'Doctor' AS role FROM doctors;

-- 26. Allergies ordered by popularity (no NULLs)
SELECT allergies, COUNT(*) AS count
FROM patients
WHERE allergies IS NOT NULL
GROUP BY allergies
ORDER BY count DESC;

-- 27. Patients born in 1970s
SELECT first_name, last_name, birth_date
FROM patients
WHERE YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date;

-- 28. FULL NAME with format: LASTNAME,FIRSTNAME
SELECT CONCAT(UPPER(last_name), ',', LOWER(first_name)) AS full_name
FROM patients
ORDER BY LOWER(first_name) DESC;

-- 29. province_id(s) with height sum ≥ 7000
SELECT province_id, SUM(height) AS total_height
FROM patients
GROUP BY province_id
HAVING SUM(height) >= 7000;

-- 30. Weight difference for last name 'Maroni'
SELECT MAX(weight) - MIN(weight) AS weight_difference
FROM patients
WHERE last_name = 'Maroni';

-- 31. Admissions per day of month
SELECT DAY(admission_date) AS day_of_month, COUNT(*) AS admissions
FROM admissions
GROUP BY DAY(admission_date)
ORDER BY admissions DESC;

-- 32. Patients grouped by weight groups (100s)
SELECT FLOOR(weight / 10) * 10 AS weight_group, COUNT(*) AS total
FROM patients
GROUP BY weight_group
ORDER BY weight_group DESC;

-- 33. Obesity check
SELECT patient_id, weight, height,
  CASE
    WHEN weight / POWER(height / 100, 2) >= 30 THEN 1
    ELSE 0
  END AS isObese
FROM patients;

ALTER TABLE admissions RENAME COLUMN attending_doctor_id TO doctor_id;

-- 34. Patients diagnosed with 'Epilepsy' attended by 'Lisa'
SELECT p.patient_id, p.first_name, p.last_name, d.specialty
FROM patients p
JOIN admissions a ON p.patient_id = a.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
WHERE a.diagnosis = 'Epilepsy' AND d.first_name = 'Lisa';

-- 35. Temporary password = patient_id + length(last_name) + birth year
SELECT patient_id,
       CONCAT(
         patient_id,
         LENGTH(last_name),
         YEAR(birth_date)
       ) AS temp_password
FROM patients
WHERE patient_id IN (SELECT DISTINCT patient_id FROM admissions);
