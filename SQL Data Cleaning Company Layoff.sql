
-- -- EMUDIAGA RUKEVWE ERICSON -- --

-- Data Cleaning of yearly company layoffs
-- 
-- A blank database was created in MySQL
CREATE DATABASE company_layoff;
-- Data was imported into MySQL from a csv file downloaded from Kaggle
-- The imported data was added as a table to the COMPANY_LAYOFF database created earlier

-- -- -- Analysis -- -- --
-- Overview of the dataset
SELECT 
    *
FROM
    layoffs;

-- Examining if the company names are consistent
SELECT DISTINCT
    company
FROM
    layoffs
ORDER BY 1;

-- It was revealed that that the name of companies contained unusual spaces, hence we used TRIM function to eradicate the spaces
UPDATE layoffs 
SET 
    company = TRIM(company);

-- Furthermore, I examined industry names for consistency
SELECT DISTINCT
    industry
FROM
    layoffs
ORDER BY 1;


-- Not all names were consistent hence the UPDATE, WHERE, LIKE functions were useful
UPDATE layoffs 
SET 
    industry = 'Crypto'
WHERE
    industry LIKE 'crypto%';


-- Same diagnosis and treatment used in the inductry feature was applied to the country
SELECT DISTINCT
    country
FROM
    layoffs
ORDER BY 1;

UPDATE layoffs 
SET 
    country = 'United States'
WHERE
    country LIKE 'United States%';

-- The date column was in text (STRING) FORMAT, hence i transformed it to DATE type using STR_TO_DATE function
UPDATE layoffs 
SET 
    `date` = STR_TO_DATE(`date`, '%m/%d/%Y');


-- Since the aim of the dataset was to uncover causing factors for layoff in thesecompanies, we checked if all records show layoff numbers ofr percentage layoffs
SELECT 
    *
FROM
    layoffs
WHERE
    (total_laid_off IS NULL
        OR total_laid_off = '')
        AND percentage_laid_off IS NULL;

-- Records with no trace of total laid off or percentage laid off, were treated as irrelevant hence, they were dropped

DELETE FROM layoffs 
WHERE
    (total_laid_off IS NULL
    OR total_laid_off = '')
    AND percentage_laid_off IS NULL;

-- A common table expression (CTE) was developed to assess for duplicated records
with duplicated as 
(
select *, 
row_number() 
over(partition by company, location, industry, total_laid_off, `date`, stage, country, funds_raised_millions) as row_id
 from layoffs) 
 select * from duplicated
  order by row_id desc;
 
 -- All duplicate records were dropped to avoid data redundancy
DELETE FROM layoffs 
WHERE
    company IN ('Cazoo' , 'Hibob', 'Wildlife Studios', 'Yahoo');


-- Evaluation for missing values for industry    
SELECT 
    *
FROM
    layoffs
WHERE
    industry = '';
 
 
 -- -- Missing values for industry was treated through population with UNKNOWN TAG
UPDATE layoffs 
SET 
    industry = 'Unknown'
WHERE
    industry IS NULL OR industry = ''; 
  
 -- Final view of dataset for 
  SELECT 
    *
FROM
    layoffs;
