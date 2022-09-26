--Video Game Sales Data--

--Author: Lucas Condeni
--Date: 9/25/22
--Platform: PG Admin 4 for Postgres SQL 

CREATE TABLE public."Video_Game_Sales" (

    rank integer,
	title character varying (100), 
	platform character varying (100), 
	year smallint, 
	genre character varying (100), 
	publisher character varying (100), 
	NA_Sales numeric, 
	EU_Sales numeric, 
	JP_Sales numeric, 
	Other_Sales numeric, 
	Global_sales numeric
)

--Manually corrected 'year' column for games with sales > $1M where N/A
--Manually removed remaining NA's from 'year' column 

--Imported csv file  
\copy public."Video_Game_Sales" FROM '/Users/lucascondeni/Downloads/vgsales.csv' WITH CSV HEADER ;

--Check table
SELECT * 
FROM public."Video_Game_Sales"
LIMIT 1

--Check/Clean Data
SELECT DISTINCT title
FROM public."Video_Game_Sales" -- 11,493 rows affeced; There are 5,100 multiplatform games 

SELECT DISTINCT title, platform
FROM public."Video_Game_Sales" -- 16,593 rows affeced; no duplicate titles or platforms

SELECT title, platform, genre, publisher
FROM public."Video_Game_Sales"
WHERE title = 'NA' OR   
	platform = 'NA' OR 
	genre ='NA' OR
	publisher = 'NA'	--There are no N/A's in the title, platform, genre, or publisher columns

SELECT LENGTH(CAST(year AS varchar(10))) AS num_letters_years
FROM public."Video_Game_Sales"
WHERE LENGTH(CAST(year AS varchar(10))) > 4 --0 rows returned; All years 4 or less

SELECT LENGTH(CAST(year AS varchar(10))) AS num_letters_years
FROM public."Video_Game_Sales"
WHERE LENGTH(CAST(year AS varchar(10))) < 4 --0 rows returned; All years greater than 4 digits

SELECT rank, title, year
FROM public."Video_Game_Sales"
WHERE year ISNULL --259 games have null for year. Chose to keep them in for platform agg sales data

SELECT *
FROM public."Video_Game_Sales"
WHERE year = 1978 or year = 1979 -- There are no game titles from 1978 or 1979


--SUMMARY STATISTICS: 

	--NA Sales
SELECT platform, year, 
		MIN(na_sales) AS min_sales_na, 
		MAX(na_sales) AS max_sales_na, 
		AVG(na_sales) AS avg_sales_na, 
		SUM(na_sales) AS sum_sales_na
FROM public."Video_Game_Sales"
GROUP BY year, platform 
ORDER BY platform, year DESC

	--EU Sales
SELECT platform, year, 
		MIN(eu_sales) AS min_sales_eu, 
		MAX(eu_sales) AS max_sales_eu, 
		AVG(eu_sales) AS avg_sales_eu, 
		SUM(eu_sales) AS sum_sales_eu
FROM public."Video_Game_Sales"
GROUP BY year, platform 
ORDER BY platform, year DESC

	--JP Sales
SELECT platform, year, 
		MIN(jp_sales) AS min_sales_jp, 
		MAX(jp_sales) AS max_sales_jp, 
		AVG(jp_sales) AS avg_sales_jp, 
		SUM(jp_sales) AS sum_sales_jp
FROM public."Video_Game_Sales"
GROUP BY year, platform 
ORDER BY platform, year DESC	

	--Sum Sales by Platform
SELECT platform,  
		SUM(na_sales) AS total_na_sales, 
		SUM(eu_sales) AS total_eu_sales, 
		SUM(jp_sales) AS total_jp_sales
FROM public."Video_Game_Sales"
GROUP BY platform 

	--Avg Sales by Platform 
SELECT platform, 
		AVG(na_sales) AS avg_na_sales, 
		AVG(eu_sales) AS avg_eu_sales, 
		AVG(jp_sales) AS avg_jp_sales
FROM public."Video_Game_Sales"
GROUP BY platform 


--OBJECTIVES: 
--1. Platform/genre by year and total sales 
SELECT platform, genre, year,  
	SUM(na_sales)+SUM(eu_sales)+SUM(jp_sales) as total_sales
FROM public."Video_Game_Sales"
GROUP BY platform, genre, year
ORDER BY platform, year DESC

	--Genre by year and occurrence
SELECT DISTINCT genre, year, 
	COUNT (genre) OVER(PARTITION BY genre, year) AS num_of_genre
FROM public."Video_Game_Sales"
ORDER BY genre, year DESC

	--Genre global sales by year
SELECT DISTINCT genre, year, SUM(global_sales) AS total_sales_global 
FROM public."Video_Game_Sales"
GROUP BY genre, year
ORDER BY genre, year DESC

	--Platform global sales by year
SELECT DISTINCT platform, year, SUM(global_sales) AS total_sales_global
FROM public."Video_Game_Sales"
GROUP BY platform, year 
ORDER BY platform, year DESC

	--Best selling genre by year
SELECT MAX(total_sales) max_sales, year, genre
	  FROM (SELECT SUM(global_sales) as total_sales, year, genre
		    FROM public."Video_Game_Sales"
	 		GROUP BY year, genre
			 ORDER BY total_sales DESC 
			 )		a 
GROUP BY year, genre 
ORDER BY year, max_sales DESC

--2. Most successful games by sales region 
SELECT title, genre, year, na_sales
FROM public."Video_Game_Sales"
ORDER BY na_sales DESC 
LIMIT 30

SELECT title, genre, year, eu_sales
FROM public."Video_Game_Sales"
ORDER BY eu_sales DESC 
LIMIT 30

SELECT title, genre, year, jp_sales
FROM public."Video_Game_Sales"
ORDER BY jp_sales DESC 
LIMIT 30

--3. Popular Genres Over Time / Popular genres by sales region 
	--Count of genre by top NA sales
SELECT a.year, a.genre, COUNT(a.genre)
FROM (
SELECT title, year, genre, na_sales
FROM public."Video_Game_Sales"
ORDER BY na_sales DESC
	) a
GROUP BY a.year, a.genre
ORDER BY a.year

	--Count of genre by top EU sales
SELECT a.year, a.genre, COUNT(a.genre)
FROM (
SELECT title, year, genre, eu_sales
FROM public."Video_Game_Sales"
ORDER BY eu_sales DESC
	) a
GROUP BY a.year, a.genre
ORDER BY a.year

	--Count of genre by top JP sales
SELECT a.year, a.genre, COUNT(a.genre)
FROM (
SELECT title, year, genre, jp_sales
FROM public."Video_Game_Sales"
ORDER BY jp_sales DESC
	) a
GROUP BY a.year, a.genre
ORDER BY a.year

	--Genre sales NA 
SELECT genre, SUM(na_sales) as sum_na_sales
FROM public."Video_Game_Sales"
GROUP BY genre
ORDER BY sum_na_sales DESC

	--Genre sales EU
SELECT genre, SUM(eu_sales) as sum_eu_sales
FROM public."Video_Game_Sales"
GROUP BY genre
ORDER BY sum_eu_sales DESC

	--Genre sales JP
SELECT genre, SUM(jp_sales) as sum_jp_sales
FROM public."Video_Game_Sales"
GROUP BY genre
ORDER BY sum_jp_sales DESC

--4. Popular Publishers by sales region / genre 
	--Publishers by NA Sales Top 5000
SELECT a.publisher, COUNT(a.publisher) as pub_count
FROM (SELECT title, publisher, na_sales
	 FROM public."Video_Game_Sales"
	  ORDER BY na_sales DESC
	  LIMIT 5000
	 ) a
GROUP BY a.publisher
ORDER BY pub_count DESC

	--Publishers by NA Sales Top 100
SELECT a.publisher, COUNT(a.publisher) as pub_count
FROM (SELECT title, publisher, na_sales
	 FROM public."Video_Game_Sales"
	  ORDER BY na_sales DESC
	  LIMIT 100
	 ) a
GROUP BY a.publisher
ORDER BY pub_count DESC

	--Publishers by EU Sales Top 5000
SELECT a.publisher, COUNT(a.publisher) as pub_count
FROM (SELECT title, publisher, eu_sales
	 FROM public."Video_Game_Sales"
	  ORDER BY eu_sales DESC
	  LIMIT 5000
	 ) a
GROUP BY a.publisher
ORDER BY pub_count DESC

	--Publishers by EU Sales Top 100
SELECT a.publisher, COUNT(a.publisher) as pub_count
FROM (SELECT title, publisher, eu_sales
	 FROM public."Video_Game_Sales"
	  ORDER BY eu_sales DESC
	  LIMIT 100
	 ) a
GROUP BY a.publisher
ORDER BY pub_count DESC

	--Publishers by JP Sales Top 5000
SELECT a.publisher, COUNT(a.publisher) as pub_count
FROM (SELECT title, publisher, jp_sales
	 FROM public."Video_Game_Sales"
	  ORDER BY jp_sales DESC
	  LIMIT 5000
	 ) a
GROUP BY a.publisher
ORDER BY pub_count DESC

	--Publishers by JP Sales Top 100
SELECT a.publisher, COUNT(a.publisher) as pub_count
FROM (SELECT title, publisher, jp_sales
	 FROM public."Video_Game_Sales"
	  ORDER BY jp_sales DESC
	  LIMIT 100
	 ) a
GROUP BY a.publisher
ORDER BY pub_count DESC

	--Genre by Publisher 
SELECT DISTINCT genre, COUNT(publisher) as pub_count
FROM public."Video_Game_Sales"
GROUP BY genre
ORDER BY pub_count DESC

	--Top Publishers and their genres
WITH cte AS ( 
	SELECT publisher, genre, total_sales, top_genre, 
		RANK() OVER(PARTITION BY publisher
			ORDER BY top_genre DESC
			) AS r 
	FROM (SELECT publisher, genre, SUM(global_sales) as total_sales, COUNT(genre) as top_genre
		 	FROM public."Video_Game_Sales"
		  GROUP BY publisher, genre
		 ) a
	)
SELECT DISTINCT publisher, genre, total_sales, top_genre
FROM cte 
WHERE r=1
ORDER BY total_sales DESC

	--Publisher Global Sales
SELECT publisher, SUM(global_sales) as total_sales
FROM public."Video_Game_Sales"
GROUP BY publisher
ORDER BY total_sales DESC





