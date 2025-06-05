CREATE DATABASE salary_survey_2021;
USE salary_survey_2021;
CREATE TABLE salary_data (
   Age_Range VARCHAR(100),
    Industry VARCHAR(100),
    Job_Title VARCHAR(100),
    job_title_clarification VARCHAR(100),
    annual_salary DECIMAL(15,2),
    additional_monetary_compensation DECIMAL(15,2),
    Currency VARCHAR(100),
    Country VARCHAR(100),
    State VARCHAR(100),
    City VARCHAR(100),
    Years_of_Professional_Experience_Overall VARCHAR(100),
    Years_of_Professional_Experience_in_feild VARCHAR(100),
    education_level VARCHAR(100),
    Gender VARCHAR(100)
);
 drop table salary_data;
 DROP DATABASE salary_survey_2021;
 
 SELECT * FROM salary_data;
 
 
 # 1. Average Salary by Industry and Gender                        
 SELECT 
    industry,
    gender,
    ROUND(AVG(annual_salary), 2) AS avg_salary
FROM 
    salary_data
WHERE 
    annual_salary IS NOT NULL
GROUP BY 
    industry, gender
ORDER BY 
    industry, gender;
    
# 2.Total Salary Compensation by Job Title                                              
SELECT 
    Job_Title,
    ROUND(SUM(annual_salary + IFNULL(additional_monetary_compensation, 0)), 2)
    AS total_compensation
FROM 
    salary_data
WHERE 
    annual_salary IS NOT NULL
GROUP BY 
    Job_Title
ORDER BY 
    total_compensation DESC;


# 3. Salary Distribution by Education Level                              
SELECT 
    education_level,
    ROUND(AVG(annual_salary), 2) AS avg_salary,
    ROUND(MIN(annual_salary), 2) AS min_salary,
    ROUND(MAX(annual_salary), 2) AS max_salary
FROM 
    salary_data
WHERE 
    annual_salary IS NOT NULL
GROUP BY 
    education_level
ORDER BY 
    avg_salary DESC;

# 4.Number of Employees by Industry and Years of Experience 
SELECT 
    Industry,
    Years_of_Professional_Experience_Overall AS experience_years,
    COUNT(*) AS employee_count
FROM 
    salary_data
WHERE 
    Industry IS NOT NULL 
    AND Years_of_Professional_Experience_Overall IS NOT NULL
GROUP BY 
    Industry, experience_years
ORDER BY 
    Industry, experience_years;
    
    
    
 # 10.Median Salary by Age Range and Gender 
 WITH ranked_salaries AS (
    SELECT 
        Age_Range,
        Gender,
        annual_salary,
        ROW_NUMBER() OVER (PARTITION BY Age_Range, 
        Gender ORDER BY annual_salary) AS rn,
        COUNT(*) OVER (PARTITION BY Age_Range, Gender) AS cnt
    FROM salary_data
    WHERE annual_salary IS NOT NULL
)
SELECT 
    Age_Range,
    Gender,
    AVG(annual_salary) AS median_salary
FROM ranked_salaries
WHERE rn IN (FLOOR((cnt + 1)/2), FLOOR((cnt + 2)/2))
GROUP BY Age_Range, Gender
ORDER BY Age_Range, Gender;

# 7.Job Titles with the Highest Salary in Each Country 
SELECT 
    Country,
    Job_Title,
    annual_salary
FROM 
    salary_data
WHERE 
    (Country, annual_salary) IN (
        SELECT 
            Country, MAX(annual_salary)
        FROM 
            salary_data
        WHERE 
            annual_salary IS NOT NULL
        GROUP BY 
            Country
    )
ORDER BY 
    Country, annual_salary DESC;
     
    
 # 6.Average Salary by City and Industry 
 SELECT 
    City,
    Industry,
    AVG(annual_salary) AS average_salary
FROM 
    salary_data
WHERE 
    annual_salary IS NOT NULL
GROUP BY 
    City, Industry
ORDER BY 
    Industry, average_salary DESC;



# 8.Percentage of Employees with Additional Monetary Compensation by Gender 
SELECT 
    Gender,
    COUNT(CASE 
            WHEN additional_monetary_compensation IS NOT NULL AND 
            additional_monetary_compensation > 0 
            THEN 1 
         END) * 100.0 / COUNT(*) AS percentage_with_additional_compensation
FROM 
    salary_data
WHERE 
    Gender IS NOT NULL
GROUP BY 
    Gender
ORDER BY 
    percentage_with_additional_compensation DESC;


# 9.Total Compensation by Job Title and Years of Experience 
SELECT 
    Job_Title,
    Years_of_Professional_Experience_Overall AS Experience_Level,
    AVG(annual_salary + IFNULL(additional_monetary_compensation, 0))
    AS avg_total_compensation
FROM 
    salary_data
WHERE 
    annual_salary IS NOT NULL
GROUP BY 
    Job_Title, Years_of_Professional_Experience_Overall
ORDER BY 
    Job_Title, avg_total_compensation DESC;
    
    # 5. Average Salary by Industry, Gender, and Education Level 
    SELECT 
    Industry,
    Gender,
    education_level,
    AVG(annual_salary) AS avg_salary
FROM 
    salary_data
WHERE 
    annual_salary IS NOT NULL
GROUP BY 
    Industry, Gender, education_level
ORDER BY 
    Industry, avg_salary DESC;
