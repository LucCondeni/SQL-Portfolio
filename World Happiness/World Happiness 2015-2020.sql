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

-- 2. Can we group the data? 

SELECT DISTINCT continent 
FROM "WHC"

Australia, Africa, Asia, South America, North America, Europe

-- 3. What are the variable's correlation regardless of group?

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

