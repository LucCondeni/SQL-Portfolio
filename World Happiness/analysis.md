
## Data Sources

[World Happiness](https://www.kaggle.com/datasets/eliasturk/world-happiness-based-on-cpi-20152020)

[Country Population](https://data.worldbank.org/indicator/SP.POP.TOTL)
 
## Create Tables and import data 

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
