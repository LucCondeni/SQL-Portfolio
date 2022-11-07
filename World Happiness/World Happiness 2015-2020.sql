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

--Check table for NULL
--There are no NULL

SELECT country, happiness, gdp, family, health, freedom, generosity, government, dystopia, continent, year, 
	social_supp, cpi, id
FROM "WHC"
WHERE country IS NULL OR happiness IS NULL OR gdp IS NULL OR family IS NULL OR 
	health IS NULL OR freedom IS NULL OR generosity IS NULL OR government IS NULL OR 
	dystopia IS NULL OR continent IS NULL OR year IS NULL OR 
	social_supp IS NULL OR cpi IS NULL OR id IS NULL 


--Analysis 




