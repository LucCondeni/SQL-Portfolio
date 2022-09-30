# Video Game Sales :cd:

## Summary:

Purpose: Summarize which video game titles, genres, platforms, and publishers are most popular, when, and where. 
Dataset obtained through Kaggle: 

[video_game_dataset](https://www.kaggle.com/datasets/gregorut/videogamesales)

Data set contains 16,589 video games with variables:  
* Rank - Ranking of overall sales
* Name - The games name
* Platform - Platform of the games release (i.e. PC,PS4, etc.)
* Year - Year of the game's release
* Genre - Genre of the game
* Publisher - Publisher of the game
* NA_Sales - Sales in North America (in millions)
* EU_Sales - Sales in Europe (in millions)
* JP_Sales - Sales in Japan (in millions)
* Other_Sales - Sales in the rest of the world (in millions)
* Global_Sales - Total worldwide sales.

Data covers unit sales in North America, Europe, and Japanese markets from 1976-2020. There are no game titles from 1978 or 1979. No significant data after 2016. 

## Objectives: 

- Show most popular platform/genre by year and sales 

- Show most successful games by sales region 

- Show trends in genre over time / Show most popular genres by sales region

- Popular publisher by sales region and genre

## Analysis: 

Complete syntax [here](https://github.com/LucCondeni/SQL-Portfolio/blob/main/Video%20Game%20Sales/videogames.sql)

### Reviewed Data:
Data was mostly already clean. Other than N/A values in 'year' column data was complete. 

1. Manually corrected N/A's in 'year' column for games with unit sales > $1M 
2. Manually removed remaining NA's from 'year' column 
3. Checked data: 

``` sql 

SELECT DISTINCT title
FROM public."Video_Game_Sales" -- 11,493 rows affeced; There are 5,100 multiplatform games 

SELECT DISTINCT title, platform
FROM public."Video_Game_Sales" -- 16,593 rows affeced; no duplicate titles or platforms

SELECT title, platform, genre, publisher
FROM public."Video_Game_Sales"
WHERE title = 'NA' OR   
	platform = 'NA' OR 
	genre ='NA' OR
	publisher = 'NA' --There are no N/A's in the title, platform, genre, or publisher columns

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

```
### Summary Statistics: 

```sql 

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

```
### Objective 1: Popular platforms and genres 

1.Platform/genre by year and total sales:

``` sql 
SELECT platform, genre, year,  
	SUM(na_sales)+SUM(eu_sales)+SUM(jp_sales) as total_sales
FROM public."Video_Game_Sales"
GROUP BY platform, genre, year
ORDER BY platform, year DESC
```

2. Genre number of occurrence by year

```sql
	--Genre by year and occurrence
SELECT DISTINCT genre, year, 
	COUNT (genre) OVER(PARTITION BY genre, year) AS num_of_genre
FROM public."Video_Game_Sales"
ORDER BY genre, year DESC
```

3. Genre global sales by year all

```sql 
SELECT DISTINCT genre, year, SUM(global_sales) AS total_sales_global 
FROM public."Video_Game_Sales"
GROUP BY genre, year
ORDER BY genre, year DESC
```

4. Platform global sales by year

```sql 
SELECT DISTINCT platform, year, SUM(global_sales) AS total_sales_global
FROM public."Video_Game_Sales"
GROUP BY platform, year 
ORDER BY platform, year DESC
```

5. Best selling genre per year

```sql 
SELECT MAX(total_sales) max_sales, year, genre
	  FROM (SELECT SUM(global_sales) as total_sales, year, genre
		    FROM public."Video_Game_Sales"
	 		GROUP BY year, genre
			 ORDER BY total_sales DESC 
			 )		a 
GROUP BY year, genre 
ORDER BY year, max_sales DESC

```

### Objective 2: Most Successful Games by Sales Region 

```sql 
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
```

### Objective 3: Trends in genre over time 

1. Count of genre by top NA sales
```sql 
SELECT a.year, a.genre, COUNT(a.genre)
FROM (
SELECT title, year, genre, na_sales
FROM public."Video_Game_Sales"
ORDER BY na_sales DESC
	) a
GROUP BY a.year, a.genre
ORDER BY a.year
```

2. Count of genre by top EU sales
``` sql 
SELECT a.year, a.genre, COUNT(a.genre)
FROM (
SELECT title, year, genre, eu_sales
FROM public."Video_Game_Sales"
ORDER BY eu_sales DESC
	) a
GROUP BY a.year, a.genre
ORDER BY a.year
```
3. Count of genre by top JP sales
``` sql
SELECT a.year, a.genre, COUNT(a.genre)
FROM (
SELECT title, year, genre, jp_sales
FROM public."Video_Game_Sales"
ORDER BY jp_sales DESC
	) a
GROUP BY a.year, a.genre
ORDER BY a.year
```

### Objective 4: Most popular genres by sales region

1. Genre sales NA 
``` sql 
SELECT genre, SUM(na_sales) as sum_na_sales
FROM public."Video_Game_Sales"
GROUP BY genre
ORDER BY sum_na_sales DESC
```

2. Genre sales EU
```sql 
SELECT genre, SUM(eu_sales) as sum_eu_sales
FROM public."Video_Game_Sales"
GROUP BY genre
ORDER BY sum_eu_sales DESC
```

3. Genre sales JP
```sql 
SELECT genre, SUM(jp_sales) as sum_jp_sales
FROM public."Video_Game_Sales"
GROUP BY genre
ORDER BY sum_jp_sales DESC
```

### Objective 5: Popular Publishers by sales region / genre

1. Publishers by NA Sales Top 5000
```sql
SELECT a.publisher, COUNT(a.publisher) as pub_count
FROM (SELECT title, publisher, na_sales
	 FROM public."Video_Game_Sales"
	  ORDER BY na_sales DESC
	  LIMIT 5000
	 ) a
GROUP BY a.publisher
ORDER BY pub_count DESC
```
2. Publishers by NA Sales Top 100
```sql
SELECT a.publisher, COUNT(a.publisher) as pub_count
FROM (SELECT title, publisher, na_sales
	 FROM public."Video_Game_Sales"
	  ORDER BY na_sales DESC
	  LIMIT 100
	 ) a
GROUP BY a.publisher
ORDER BY pub_count DESC
```

3. Publishers by EU Sales Top 5000
```sql
SELECT a.publisher, COUNT(a.publisher) as pub_count
FROM (SELECT title, publisher, eu_sales
	 FROM public."Video_Game_Sales"
	  ORDER BY eu_sales DESC
	  LIMIT 5000
	 ) a
GROUP BY a.publisher
ORDER BY pub_count DESC
```

4. Publishers by EU Sales Top 100
```sql
SELECT a.publisher, COUNT(a.publisher) as pub_count
FROM (SELECT title, publisher, eu_sales
	 FROM public."Video_Game_Sales"
	  ORDER BY eu_sales DESC
	  LIMIT 100
	 ) a
GROUP BY a.publisher
ORDER BY pub_count DESC
```

5. Publishers by JP Sales Top 5000
```sql
SELECT a.publisher, COUNT(a.publisher) as pub_count
FROM (SELECT title, publisher, jp_sales
	 FROM public."Video_Game_Sales"
	  ORDER BY jp_sales DESC
	  LIMIT 5000
	 ) a
GROUP BY a.publisher
ORDER BY pub_count DESC
```

6. Publishers by JP Sales Top 100
```sql
SELECT a.publisher, COUNT(a.publisher) as pub_count
FROM (SELECT title, publisher, jp_sales
	 FROM public."Video_Game_Sales"
	  ORDER BY jp_sales DESC
	  LIMIT 100
	 ) a
GROUP BY a.publisher
ORDER BY pub_count DESC
```

7. Genre by Publisher 
```sql
SELECT DISTINCT genre, COUNT(publisher) as pub_count
FROM public."Video_Game_Sales"
GROUP BY genre
ORDER BY pub_count DESC
```

8. Top Publishers and their genres
```sql
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
```

9. Publisher Global Sales
```sql 
SELECT publisher, SUM(global_sales) as total_sales
FROM public."Video_Game_Sales"
GROUP BY publisher
ORDER BY total_sales DESC
```

## Conclusion and Findings 

[All Viz](https://public.tableau.com/app/profile/lucas.condeni/viz/vgsalesviz/videogame_sales)

### 1. Popular Platforms/Genres

Overview of the three sales regions (NA, EU, JP) over the specified timeframe by total units sold and average units sold:  

![All Sales Years](https://user-images.githubusercontent.com/110264861/192432491-5b7c06ca-1782-4b47-b11a-63313852e591.png)

North America has a much larger market than Europe or Japan likely based on a larger population. Platform and genre total sales: 

![Platform Total Sales](https://user-images.githubusercontent.com/110264861/193207586-5d9bba98-a4be-4ae4-b4e9-fd846df86a80.png)

The flagship platforms of Nintendo DS (handheld), Playstation 1-3, Wii, and Xbox 360 sold the most units. As the data ends in 2016, Playstation 4-5 and Xbonx One have likely surpassed these figures. 

![Genre Total Sales](https://user-images.githubusercontent.com/110264861/193207618-bf16fc11-d1b3-48d2-a76e-c76ae3c7a7e3.png)

There are multiple genres that stand out, but Action and Sports are clear favorites. 

### 2. Top game titles in each sales region: 

![Popular Titles NA](https://user-images.githubusercontent.com/110264861/193208828-a07eab7d-4abe-4711-8da8-f4a9e8643f5a.png)

NA has interesting results. Wii Sports sold over 40 million copies and makes up over 10% of the total units sold. Top 5 includes Duck Hunt (1985) and Tetris (1984). Various titles in the Call of Duty Franchise appear in the top 25. 

![Popular Titles EU](https://user-images.githubusercontent.com/110264861/193208761-e3cabd41-3326-493b-8fce-87bf057c4abc.png)

Wii Sports is again the victor in EU. Call of Duty isn't nearly as popular as in NA (which is somewhat expected), although Grand Theft Auto is also in the Top 5. 11 out of the Top 15 are Nintendo released titles. PC game World of Warcraft makes the top 20. 

![Popular Titles JP](https://user-images.githubusercontent.com/110264861/193208794-a32ee175-37f7-4eac-a43c-493db5edac86.png)

JP sales region has dramatically different tastes. The 1996 release Pokemon Red/Pokemon Blue and the follow up 1999 Pokemon Gold/Pokemon Silver are clear winners. Almost all games in this list are released by Nintendo as a Japense publisher. 

### 3. Popular genres by sales regions

![Genres NA](https://user-images.githubusercontent.com/110264861/193208341-4ac1cbb5-e912-48e5-9c44-d778f08ae646.png)

As expected Action, Sports, and Shooter have the highest unit counts. While franchies like Call of Duty boost the Shooters category and individually sold more units than most titles, over the complete time span Action and Sports have been more popular, particullary Wii Sports. 

![Genres EU](https://user-images.githubusercontent.com/110264861/193208387-7cd2ffee-9717-40b6-9488-d0aba3ba12d1.png)

EU looks very similar to NA, with Action, Shooter, and Sports being the most popular. 

![Genres JP](https://user-images.githubusercontent.com/110264861/193208430-3714b287-f4df-4179-80e1-fb860f037f6d.png)

Again the JP region looks very different from the other two. JP clearly favores Role-Playing games, namely Pokemon. 

### 4. Popular Publishers by sales region

![Publishers NA](https://user-images.githubusercontent.com/110264861/193212831-874e70b7-b4f9-4fb4-98a4-05c1ea2f1876.png)

Nintendo as a publisher shows up a lot. Nintendo has over 800 million copies sold in NA. Electronic Arts and Activision are No. 2 and 3. 

![Publishers EU ](https://user-images.githubusercontent.com/110264861/193212880-42a156eb-3dd3-4a07-8f98-ef6ff8247ba4.png)

This is seen again in EU in the same order. The EU market is nearly half the size of NA, but the popular publishers are the same. 

![Publishers JP](https://user-images.githubusercontent.com/110264861/193212894-770aadcf-b968-4e90-bc3e-647caa12bd23.png)

As expected, Nintendo makes up over 40% of the JP market. 


