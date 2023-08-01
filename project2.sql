-- create database project2;
select * from hr
-- ALTER TABLE hr
-- CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;
 DESCRIBE hr;
--   SELECT birthdate FROM hr;

-- UPDATE hr
-- SET birthdate = CASE
-- 	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
--     WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
--     ELSE NULL
-- END;

-- ALTER TABLE hr
-- MODIFY COLUMN birthdate DATE;

 -- UPDATE hr
-- SET hire_date = CASE
-- 	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
--     WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
--     ELSE NULL
-- END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

select termdate from hr;

UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

ALTER TABLE hr
MODIFY COLUMN termdate  DATE;

ALTER TABLE hr ADD COLUMN age INT;

UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

select  birthdate,age from hr;

SELECT count(*) FROM hr WHERE age < 18;

SELECT 
	min(age) AS youngest,
    max(age) AS oldest
FROM hr;
-- 1. What is the gender breakdown of employees in the company? 

SELECT gender, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY gender

-- 2. What is the race/ethnicity breakdown of employees in the company?

SELECT race, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY race
ORDER BY count DESC

-- 3. What is the age distribution of employees in the company?
select max(age) as oldest,
min(age) as younger from hr WHERE age >= 18

select
case
when age>=18 and age <= 24 then '18-24'
when age>=25 and age <= 34 then '25-34'
when age>=35 and age <= 44 then '35-44'
when age>=45 and age <= 54 then '45-54'
else '55+'
end as age_group,
count(*) as count 
from hr where age>=18
group by age_group
order by age_group

SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group,gender ,
  COUNT(*) AS count
FROM 
  hr
WHERE 
  age >= 18
GROUP BY age_group,gender
ORDER BY age_group,gender

-- 4. How many employees work at headquarters versus remote locations?
SELECT location, COUNT(*) as count
FROM hr
WHERE age >= 18
GROUP BY location;

-- 5. How does the gender distribution vary across departments?
select department,gender,count(*) from hr
where age>=18
group by department,gender
order by department

-- 6. What is the distribution of job titles across the company?
SELECT jobtitle, COUNT(*) as count
FROM hr
WHERE age >= 18
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 7. Which department has the highest turnover rate?
select department,count(*) as total_count,
 SUM(CASE WHEN termdate <= CURDATE() AND termdate <> '0000-00-00' THEN 1 ELSE 0 END) as terminated_count, 
    SUM(CASE WHEN termdate = '0000-00-00' THEN 1 ELSE 0 END) as active_count,
    (SUM(CASE WHEN termdate <= CURDATE() THEN 1 ELSE 0 END) / COUNT(*)) as termination_rate
from hr
WHERE age >= 18
GROUP BY department
ORDER BY termination_rate DESC;

-- 8. What is the distribution of employees across locations by state?
SELECT location_state, COUNT(*) as count
FROM hr
WHERE age >= 18
GROUP BY location_state
ORDER BY count DESC;
-- 9. How has the company's employee count changed over time based on hire and term dates?
SELECT 
    YEAR(hire_date) AS year, 
    COUNT(*) AS hires, 
    SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations, 
    COUNT(*) - SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS net_change,
    ROUND(((COUNT(*) - SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END)) / COUNT(*) * 100),2) AS net_change_percent
FROM 
    hr
WHERE age >= 18
GROUP BY 
    YEAR(hire_date)
ORDER BY 
    YEAR(hire_date) ASC;