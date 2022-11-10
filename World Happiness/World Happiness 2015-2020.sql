--Create and load tables

CREATE TABLE "WHC" (
    "country" varchar(100)   NOT NULL,
    "happiness" numeric   NOT NULL,
    "gdp" numeric   NOT NULL,
    "family" numeric   NOT NULL,
    "health" numeric   NOT NULL,
    "freedom" numeric   NOT NULL,
    "generosity" numeric   NOT NULL,
    "government" numeric   NOT NULL,
    "dystopia" numeric   NOT NULL,
    "continent" varchar(100)  NOT NULL,
    "year" int   NOT NULL,
    "social_supp" numeric   NOT NULL,
    "cpi" numeric   NOT NULL,
    "id" numeric   NOT NULL,
    CONSTRAINT "pk_WHC" PRIMARY KEY (
        "id"
     )
);

CREATE TABLE "World_Population" (
    "country" varchar(100)  NOT NULL,
    "code" varchar(100)   NOT NULL,
    "indicatorname" varchar(250)  NOT NULL,
    "indicatorcode" varchar(250)   NOT NULL,
	"2015" numeric,
    "2016" numeric,
    "2017" numeric,
    "2018" numeric,
    "2019" numeric,
    "2020" numeric,
    CONSTRAINT "pk_World_Population" PRIMARY KEY (
        "code"
     )
);

\copy public."WHC" 
FROM  '/WorldHappiness_Corruption_2015_2020.csv'
WITH CSV HEADER; 

\copy public."WHC" 
FROM '/World Happiness/pop total .csv'
WITH CSV HEADER; 

--CLEAN DATA?
	--Data is clean. 
--Check table for NULL

SELECT country, happiness, gdp, family, health, freedom, generosity, government, dystopia, continent, year, 
	social_supp, cpi, id
FROM "WHC"
WHERE country IS NULL OR happiness IS NULL OR gdp IS NULL OR family IS NULL OR 
	health IS NULL OR freedom IS NULL OR generosity IS NULL OR government IS NULL OR 
	dystopia IS NULL OR continent IS NULL OR year IS NULL OR 
	social_supp IS NULL OR cpi IS NULL OR id IS NULL 

--There are no NULL

--Analysis 

-- 1. What are the variables? 

SELECT * 
FROM "WHC"
LIMIT 1

--Country — the country 
--Happiness
--GDP - gross domestic product
--family - family score
--health
--freedom
--generosity
--government 
--dystopia
--continent 
--social_supp
--cpi 

-- 2. Can we group the data? Primary grouping is by continent > country 
--Can also group by year 

SELECT DISTINCT continent 
FROM "WHC"

Australia, Africa, Asia, South America, North America, Europe

SELECT * 
FROM "WHC"
WHERE year = 2015 

-- Repeat for 2016-2020

-- 3. What are the variables' correlation to happiness regardless of group?

SELECT
CORR (happiness, gdp) AS gdp_corr, 
CORR (happiness, family) AS family_corr, 
CORR(happiness, health) AS health_corr, 
CORR(happiness, freedom) AS freedom_coor, 
CORR(happiness, generosity) AS generosity_corr, 
CORR(happiness, government) AS government_corr, 
CORR(happiness, dystopia) AS dystopia_corr, 
CORR(happiness, social_supp) AS social_supp_corr, 
CORR(happiness, cpi) AS cpi_corr
FROM "WHC"

--4. What's the correlation between population and happiness based on year and continent? 
--EUROPE
WITH eu_corr AS (
SELECT whc.country, whc.year, wp."2015" as population, whc.happiness
FROM "WHC" whc INNER JOIN "World_Population" wp 
ON whc.country = wp.country
WHERE whc.continent = 'Europe' AND whc.year = 2015
ORDER BY whc.country, population DESC
)
SELECT CORR(eu.population, eu.happiness) as eu_corr_2015
FROM "eu_corr" eu 
--AUSTRALIA
WITH au_corr AS (
SELECT whc.country, whc.year, wp."2015" as population, whc.happiness
FROM "WHC" whc INNER JOIN "World_Population" wp 
ON whc.country = wp.country
WHERE whc.continent = 'Australia' AND whc.year = 2015
ORDER BY whc.country, population DESC
)
SELECT CORR(au.population, au.happiness) as au_corr_2015
FROM "au_corr" au
--AFRICA
WITH af_corr AS (
SELECT whc.country, whc.year, wp."2015" as population, whc.happiness
FROM "WHC" whc INNER JOIN "World_Population" wp 
ON whc.country = wp.country
WHERE whc.continent = 'Africa' AND whc.year = 2015
ORDER BY whc.country, population DESC
)
SELECT CORR(af.population, af.happiness) as af_corr_2015
FROM "af_corr" af
--ASIA
WITH as_corr AS (
SELECT whc.country, whc.year, wp."2015" as population, whc.happiness
FROM "WHC" whc INNER JOIN "World_Population" wp 
ON whc.country = wp.country
WHERE whc.continent = 'Asia' AND whc.year = 2015
ORDER BY whc.country, population DESC
)
SELECT CORR(a_s.population, a_s.happiness) as as_corr_2015
FROM "as_corr" a_s
--SOUTH AMERICA
WITH as_corr AS (
SELECT whc.country, whc.year, wp."2015" as population, whc.happiness
FROM "WHC" whc INNER JOIN "World_Population" wp 
ON whc.country = wp.country
WHERE whc.continent = 'Asia' AND whc.year = 2015
ORDER BY whc.country, population DESC
)
SELECT CORR(a_s.population, a_s.happiness) as as_corr_2015
FROM "as_corr" a_s
--NORTH AMERICA
WITH as_corr AS (
SELECT whc.country, whc.year, wp."2015" as population, whc.happiness
FROM "WHC" whc INNER JOIN "World_Population" wp 
ON whc.country = wp.country
WHERE whc.continent = 'Asia' AND whc.year = 2015
ORDER BY whc.country, population DESC
)
SELECT CORR(a_s.population, a_s.happiness) as as_corr_2015
FROM "as_corr" a_s

--repeat for 2016-2020

--Aggregate Data

--Average happiness by country, sorted by continent  

SELECT whc.country, AVG(happiness) as avg_happiness
FROM "WHC" whc
WHERE whc.continent = 'Australia'
GROUP BY whc.country
ORDER BY avg_happiness DESC

SELECT whc.country, AVG(happiness) as avg_happiness
FROM "WHC" whc
WHERE whc.continent = 'Africa'
GROUP BY whc.country
ORDER BY avg_happiness DESC

SELECT whc.country, AVG(happiness) as avg_happiness
FROM "WHC" whc
WHERE whc.continent = 'Europe'
GROUP BY whc.country
ORDER BY avg_happiness DESC

SELECT whc.country, AVG(happiness) as avg_happiness
FROM "WHC" whc
WHERE whc.continent = 'Asia'
GROUP BY whc.country
ORDER BY avg_happiness DESC

SELECT whc.country, AVG(happiness) as avg_happiness
FROM "WHC" whc
WHERE whc.continent = 'South America'
GROUP BY whc.country
ORDER BY avg_happiness DESC

SELECT whc.country, AVG(happiness) as avg_happiness
FROM "WHC" whc
WHERE whc.continent = 'North America'
GROUP BY whc.country
ORDER BY avg_happiness DESC

--Average happiness by continent and year? 

SELECT continent, year, AVG(happiness) 
FROM "WHC"
GROUP BY continent, year
ORDER BY year ASC

--Max happiness by continent and year? 

SELECT continent, year, MAX(happiness) 
FROM "WHC"
GROUP BY continent, year
ORDER BY year ASC

--Min happiness by continent and year? 

SELECT continent, year, MIN(happiness) 
FROM "WHC"
GROUP BY continent, year
ORDER BY year ASC

--Difference in happiness by year? 

SELECT country, year, (AVG(happiness) - LAG(AVG(happiness)) OVER(ORDER BY year)) AS happiness_diff
FROM "WHC"
GROUP BY country, year
ORDER BY country, year ASC

--Which country is happiness on average? 

SELECT country, AVG(happiness)
FROM "WHC"
GROUP BY country 
ORDER BY AVG(happiness) DESC
