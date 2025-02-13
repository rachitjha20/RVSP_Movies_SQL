USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT table_name,
       table_rows
FROM   information_schema.tables
WHERE  table_schema = 'imdb';

/*
+------------------+------------+
| TABLE_NAME       | TABLE_ROWS |
+------------------+------------+
| director_mapping |       3867 |
| genre            |      14662 |
| movie            |       9025 |
| names            |      26093 |
| ratings          |       7927 |
| role_mapping     |      16013 |
+------------------+------------+
*/

-- Q2. Which columns in the movie table have null values?
-- Type your code below:


-- Query to count the number of nulls in each column using case statements
SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS ID_NULL_COUNT,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_NULL_COUNT,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS year_NULL_COUNT,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_NULL_COUNT,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration_NULL_COUNT,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country_NULL_COUNT,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS worlwide_gross_income_NULL_COUNT,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages_NULL_COUNT,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company_NULL_COUNT
FROM   movie; 

/*
Country, worlwide_gross_income, languages and production_company columns have NULL values
+---------------+------------------+-----------------+---------------------------+---------------------+--------------------+----------------------------------+----------------------+-------------------------------+
| ID_NULL_COUNT | title_NULL_COUNT | year_NULL_COUNT | date_published_NULL_COUNT | duration_NULL_COUNT | country_NULL_COUNT | worlwide_gross_income_NULL_COUNT | languages_NULL_COUNT | production_company_NULL_COUNT |
+---------------+------------------+-----------------+---------------------------+---------------------+--------------------+----------------------------------+----------------------+-------------------------------+
|             0 |                0 |               0 |                         0 |                   0 |                 20 |                             3724 |                  194 |                           528 |
+---------------+------------------+-----------------+---------------------------+---------------------+--------------------+----------------------------------+----------------------+-------------------------------+
*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+-------------------+--------------------+
| Year		    |    number_of_movies|
+-------------------+--------------------+
|	2017	    |	    2134	 |
|	2018	    |		.	 |
|	2019	    |		.	 |
+---------------+------------------------+


Output format for the second part of the question:
+---------------+-------------------+
|    month_num	|   number_of_movies|
+---------------+-------------------+
|	1	|	 134	    |
|	2	|	 231	    |
|	.	|	.	    |
+---------------+-------------------+ */
-- Type your code below:


-- Number of movies released each year
SELECT year,
       Count(title) AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY year;

-- Number of movies released each month 
SELECT Month(date_published) AS MONTH_NUM,
       Count(*)              AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 

-- Highest number of movies were released in 2017

/* 
Yearly
+------+------------------+
| year | NUMBER_OF_MOVIES |
+------+------------------+
| 2017 |             3052 |
| 2018 |             2944 |
| 2019 |             2001 |
+------+------------------+

Monthly
+-----------+------------------+
| MONTH_NUM | NUMBER_OF_MOVIES |
+-----------+------------------+
|         1 |              804 |
|         2 |              640 |
|         3 |              824 |
|         4 |              680 |
|         5 |              625 |
|         6 |              580 |
|         7 |              493 |
|         8 |              678 |
|         9 |              809 |
|        10 |              801 |
|        11 |              625 |
|        12 |              438 |
+-----------+------------------+
*/


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- Pattern matching using LIKE operator for country column
SELECT Count(DISTINCT id) AS number_of_movies, year
FROM   movie
WHERE  ( country LIKE '%INDIA%'
          OR country LIKE '%USA%' )
       AND year = 2019; 
/*
1059 movies were produced in the USA or India in the year 2019
+------------------+------+
| number_of_movies | year |
+------------------+------+
|             1059 | 2019 |
+------------------+------+
*/


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


-- Finding unique genres using DISTINCT keyword
SELECT DISTINCT genre
FROM   genre; 

/* 
Movies belong to 13 genres in the dataset.
+-----------+
| genre     |
+-----------+
| Drama     |
| Fantasy   |
| Thriller  |
| Comedy    |
| Horror    |
| Family    |
| Romance   |
| Adventure |
| Action    |
| Sci-Fi    |
| Crime     |
| Mystery   |
| Others    |
+-----------+
*/


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:


-- Using LIMIT  to display only the genre with highest number of movies produced
SELECT     genre,
           Count(m.id) AS number_of_movies
FROM       movie       AS m
INNER JOIN genre       AS g
where      g.movie_id = m.id
GROUP BY   genre
ORDER BY   number_of_movies DESC limit 1 ;
 
/*
4265 Drama movies were produced in total and are the highest among all genres.

+-------+------------------+
| genre | number_of_movies |
+-------+------------------+
| Drama |             4285 |
+-------+------------------+
*/

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

-- Using genre table to find movies which belong to only one genre
-- Grouping rows based on movie id and finding the distinct number of genre each movie belongs to
-- Using the result of CTE, we find the count of movies which belong to only one genre
WITH movies_with_one_genre
     AS (SELECT movie_id
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(DISTINCT genre) = 1)
SELECT Count(*) AS movies_with_one_genre
FROM   movies_with_one_genre; 

/*
3289 movies belong to only one genre
+-----------------------+
| movies_with_one_genre |
+-----------------------+
|                  3289 |
+-----------------------+
*/

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre		|   avg_duration    |
+---------------+-------------------+
|   thriller	|	105	    |
|	.	|	.	    |
|	.	|	.	    |
+---------------+-------------------+ */
-- Type your code below:

-- Finding the average duration of movies by grouping the genres that movies belong to 
SELECT     genre,
           Round(Avg(duration),2) AS avg_duration
FROM       movie                  AS m
INNER JOIN genre                  AS g
ON      g.movie_id = m.id
GROUP BY   genre
ORDER BY avg_duration DESC;


/*
Action genre has the highest duration of 112.88 seconds followed by romance and crime genres.
+-----------+--------------+
| genre     | avg_duration |
+-----------+--------------+
| Action    |       112.88 |
| Romance   |       109.53 |
| Crime     |       107.05 |
| Drama     |       106.77 |
| Fantasy   |       105.14 |
| Comedy    |       102.62 |
| Adventure |       101.87 |
| Mystery   |       101.80 |
| Thriller  |       101.58 |
| Family    |       100.97 |
| Others    |       100.16 |
| Sci-Fi    |        97.94 |
| Horror    |        92.72 |
+-----------+--------------+
*/


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre		|	movie_count |	genre_rank        |	
+---------------+-------------------+---------------------+
|drama		|	2312	    |		2	  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- CTE : Finds the rank of each genre based on the number of movies in each genre
-- Select query displays the genre rank and the number of movies belonging to Thriller genre
WITH genre_summary AS
(
           SELECT     genre,
                      Count(movie_id)                            AS movie_count ,
                      Rank() OVER(ORDER BY Count(movie_id) DESC) AS genre_rank
           FROM       genre                                 
           GROUP BY   genre )
SELECT *
FROM   genre_summary
WHERE  genre = "THRILLER" ;

/*
Thriller has rank=3 and movie count of 1484
+----------+-------------+------------+
| genre    | movie_count | genre_rank |
+----------+-------------+------------+
| Thriller |        1484 |          3 |
+----------+-------------+------------+
*/



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|  max_avg_rating   |	min_total_votes   |	max_total_votes  |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|	0	|		5   |	       177	  |	   2000	    	 |	0	   |      8	     |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

-- Using MIN and MAX functions for the query 
SELECT Min(avg_rating)    AS MIN_AVG_RATING,
       Max(avg_rating)    AS MAX_AVG_RATING,
       Min(total_votes)   AS MIN_TOTAL_VOTES,
       Max(total_votes)   AS MAX_TOTAL_VOTES,
       Min(median_rating) AS MIN_MEDIAN_RATING,
       Max(median_rating) AS MAX_MEDIAN_RATING
FROM   ratings; 
/*

Maximum value per column except movie_id column from rating table below.
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
| MIN_AVG_RATING | MAX_AVG_RATING | MIN_TOTAL_VOTES | MAX_TOTAL_VOTES | MIN_MEDIAN_RATING | MAX_MEDIAN_RATING |
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
|            1.0 |           10.0 |             100 |          725138 |                 1 |                10 |
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
*/
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title		|	avg_rating  |	movie_rank        |
+---------------+-------------------+---------------------+
| Fan		|		9.6 |		5	  |
|	.	|		.   |		.	  |
|	.	|		.   |		.	  |
|	.	|		.   |		.	  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

-- Finding the rank of each movie based on it's average rating
-- Displaying the top 10 movies using LIMIT clause
-- Methode 1
SELECT     title,
           avg_rating,
           Rank() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM       ratings                               AS r
INNER JOIN movie                                 AS m
ON         m.id = r.movie_id limit 10;

-- Methode 2
-- top 10 movies can also be displayed using WHERE caluse with CTE
WITH MOVIE_RANK AS
(
SELECT     title,
           avg_rating,
           ROW_NUMBER() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM       ratings                               AS r
INNER JOIN movie                                 AS m
ON         m.id = r.movie_id
)
SELECT * FROM MOVIE_RANK
WHERE movie_rank<=10;

/*
Top 3 movies have average rating >= 9.8
+--------------------------------+------------+------------+
| title                          | avg_rating | movie_rank |
+--------------------------------+------------+------------+
| Kirket                         |       10.0 |          1 |
| Love in Kilnerry               |       10.0 |          2 |
| Gini Helida Kathe              |        9.8 |          3 |
| Runam                          |        9.7 |          4 |
| Fan                            |        9.6 |          5 |
| Android Kunjappan Version 5.25 |        9.6 |          6 |
| Yeh Suhaagraat Impossible      |        9.5 |          7 |
| Safe                           |        9.5 |          8 |
| The Brighton Miracle           |        9.5 |          9 |
| Shibu                          |        9.4 |         10 |
+--------------------------------+------------+------------+
*/





/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count |
+---------------+-------------------+
|	1	|	105	    |
|	.	|	.	    |
|	.	|	.	    |
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

-- Finding the number of movies vased on median rating and sorting based on movie count.
SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC; 


/*
+---------------+-------------+
| median_rating | movie_count |
+---------------+-------------+
|             7 |        2257 |
|             6 |        1975 |
|             8 |        1030 |
|             5 |         985 |
|             4 |         479 |
|             9 |         429 |
|            10 |         346 |
|             3 |         283 |
|             2 |         119 |
|             1 |          94 |
+---------------+-------------+
*/

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |    prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1      |   1	  	     |
+------------------+-------------------+---------------------+*/
-- Type your code below:


-- CTE: Finding the rank of production company based on movie count with average rating > 8 using RANK function.
-- Querying the CTE to find the production company with rank=1
WITH production_company_hit_movie_summary
     AS (SELECT production_company,
                Count(movie_id)                     AS MOVIE_COUNT,
                Rank()
                  OVER(
                    ORDER BY Count(movie_id) DESC ) AS PROD_COMPANY_RANK
         FROM   ratings AS R
                INNER JOIN movie AS M
                        ON M.id = R.movie_id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   production_company_hit_movie_summary
WHERE  prod_company_rank = 1; 
 
/*
Dream Warrior Pictures and National Theatre Live production houses has produced the most number of hit movies (average rating > 8)
They have rank=1 and movie count =3
+------------------------+-------------+-------------------+
| production_company     | MOVIE_COUNT | PROD_COMPANY_RANK |
+------------------------+-------------+-------------------+
| Dream Warrior Pictures |           3 |                 1 |
| National Theatre Live  |           3 |                 1 |
+------------------------+-------------+-------------------+
*/

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+-------------------+-------------------+
| genre		    |	movie_count	|
+-------------------+-------------------+
|	thriller    |		105	|
|	.	    |		.	|
|	.	    |		.	|
+-------------------+-------------------+ */
-- Type your code below:

/*
 Query to find 
	1. Number of movies released in each genre 
	2. During March 2017 
	3. In the USA  (LIKE operator is used for pattern matching)
	4. Movies had more than 1,000 votes*/

SELECT genre,
       Count(M.id) AS MOVIE_COUNT
FROM   movie AS M
       INNER JOIN genre AS G
               ON G.movie_id = M.id
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  year = 2017
       AND Month(date_published) = 3
       AND country LIKE '%USA%'
       AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC; 

/*
24 Drama movies were released during March 2017 in the USA and had more than 1,000 votes
Top 3 genres are drama, comedy and action during March 2017 in the USA and had more than 1,000 votes
+-----------+-------------+
| genre     | MOVIE_COUNT |
+-----------+-------------+
| Drama     |          24 |
| Comedy    |           9 |
| Action    |           8 |
| Thriller  |           8 |
| Sci-Fi    |           7 |
| Crime     |           6 |
| Horror    |           6 |
| Mystery   |           4 |
| Romance   |           4 |
| Fantasy   |           3 |
| Adventure |           3 |
| Family    |           1 |
+-----------+-------------+
*/

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| 	title	|	avg_rating  |		genre	  |
+---------------+-------------------+---------------------+
| 	Theeran	|	8.3	    |		Thriller  |
|	.	|	.	    |			. |
|	.	|	.	    |			. |
|	.	|	.	    |			. |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- Query to find:
-- 1. Number of movies of each genre that start with the word ‘The’ (LIKE operator is used for pattern matching)
-- 2. Which have an average rating > 8?
-- Grouping by title to fetch distinct movie titles as movie belog to more than one genre

SELECT  title,
       avg_rating,
       genre
FROM   movie AS M
       INNER JOIN genre AS G
               ON G.movie_id = M.id
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  avg_rating > 8
       AND title LIKE 'THE%'
ORDER BY avg_rating DESC;

/*
 There are 8 movies which begin with "The" in their title.
The Brighton Miracle has highest average rating of 9.5.
All the movies belong to the top 3 genres. 
+--------------------------------------+------------+----------+
| title                                | avg_rating | genre    |
+--------------------------------------+------------+----------+
| The Brighton Miracle                 |        9.5 | Drama    |
| The Colour of Darkness               |        9.1 | Drama    |
| The Blue Elephant 2                  |        8.8 | Drama    |
| The Blue Elephant 2                  |        8.8 | Horror   |
| The Blue Elephant 2                  |        8.8 | Mystery  |
| The Irishman                         |        8.7 | Crime    |
| The Irishman                         |        8.7 | Drama    |
| The Mystery of Godliness: The Sequel |        8.5 | Drama    |
| The Gambinos                         |        8.4 | Crime    |
| The Gambinos                         |        8.4 | Drama    |
| Theeran Adhigaaram Ondru             |        8.3 | Action   |
| Theeran Adhigaaram Ondru             |        8.3 | Crime    |
| Theeran Adhigaaram Ondru             |        8.3 | Thriller |
| The King and I                       |        8.2 | Drama    |
| The King and I                       |        8.2 | Romance  |
+--------------------------------------+------------+----------+
*/



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.

SELECT m.title,
       r.median_rating,
       g.genre
FROM   movie m
       INNER JOIN ratings r
               ON r.movie_id = m.id
       INNER JOIN genre g
               ON g.movie_id = m.id
WHERE  m.title LIKE 'The%'
       AND r.median_rating > 8
ORDER  BY r.median_rating DESC;

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

-- BETWEEN operator is used to find the movies released between 1 April 2018 and 1 April 2019
SELECT median_rating, Count(*) AS movie_count
FROM   movie AS M
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  median_rating = 8
       AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;

/*
361 movies have released between 1 April 2018 and 1 April 2019 with a median rating of 8
+---------------+-------------+
| median_rating | movie_count |
+---------------+-------------+
|             8 |         361 |
+---------------+-------------+
*/



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- By country column compute the total number of votes for German and Italian movies

SELECT country, sum(total_votes) as total_votes
FROM movie AS m
	INNER JOIN ratings as r ON m.id=r.movie_id
WHERE country like '%Germany%' or country like '%Italy%'
GROUP BY country;

-- By language we will also compute

SELECT 
    SUM(CASE WHEN m.languages LIKE '%German%' THEN r.total_votes ELSE 0 END) AS German_movie,
    SUM(CASE WHEN m.languages LIKE '%Italian%' THEN r.total_votes ELSE 0 END) AS Italian_movie
FROM 
    movie AS m
    INNER JOIN ratings AS r ON m.id = r.movie_id;



/*
Answer is YES if German votes > Italian votes
Answer is NO if German votes <= Italian votes
By observation, German movies received the highest number of votes when queried against language and country columns.
By Country
+---------+-------------+
| country | total_votes |
+---------+-------------+
| Germany |      106710 |
| Italy   |       77965 |
+---------+-------------+

By Language
+--------------+---------------+
| German_movie | Italian_movie |
+--------------+---------------+
|      4421525 |       2559540 |
+--------------+---------------+
*/


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls| date_of_birth_nulls |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|0		|    123	    |	       1234	  |	   12345 	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- NULL counts for columns of names table using CASE statements
SELECT 
		SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
		
FROM names;

/*
Height, date_of_birth, known_for_movies columns contain NULLS
+------------+--------------+---------------------+------------------------+
| name_nulls | height_nulls | date_of_birth_nulls | known_for_movies_nulls |
+------------+--------------+---------------------+------------------------+
|          0 |        17335 |               13431 |                  15226 |
+------------+--------------+---------------------+------------------------+
*/



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count |
+---------------+-------------------|
|James Mangold	|		4   |
|	.	|		.   |
|	.	|		.   |
+---------------+-------------------+ */
-- Type your code below:


-- CTE: Computes the top 3 genres using average rating > 8 condition and highest movie counts
-- Using the top genres derived from the CTE, the directors are found whose movies have an average rating > 8 and are sorted based on number of movies made.  
WITH top_3_genres AS
(
           SELECT     genre,
                      Count(m.id)                            AS movie_count ,
                      Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM       movie                                  AS m
           INNER JOIN genre                                  AS g
           ON         g.movie_id = m.id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 )
SELECT     n.NAME            AS director_name ,
           Count(d.movie_id) AS movie_count
FROM       director_mapping  AS d
INNER JOIN genre G
using     (movie_id)
INNER JOIN names AS n
ON         n.id = d.name_id
INNER JOIN top_3_genres
using     (genre)
INNER JOIN ratings
using      (movie_id)
WHERE      avg_rating > 8
GROUP BY   NAME
ORDER BY   movie_count DESC limit 3 ;

/*
James Mangold , Anthony Russo and Soubin Shahir are top three directors in the top three genres whose movies have an average rating > 8
+---------------+-------------+
| director_name | movie_count |
+---------------+-------------+
| James Mangold |           4 |
| Anthony Russo |           3 |
| Soubin Shahir |           3 |
+---------------+-------------+
*/

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/


-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+--------------------+
| actor_name	|	movie_count  |
+-------------------+----------------+
|Christain Bale	|		10   |
|	.	|		.    |
+---------------+--------------------+ */
-- Type your code below:

SELECT N.name          AS actor_name,
       Count(movie_id) AS movie_count
FROM   role_mapping AS RM
       INNER JOIN movie AS M
               ON M.id = RM.movie_id
       INNER JOIN ratings AS R USING(movie_id)
       INNER JOIN names AS N
               ON N.id = RM.name_id
WHERE  R.median_rating >= 8
AND category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2; 
        
/*
Top 2 actors are Mammootty and Mohanlal.
+------------+-------------+
| actor_name | movie_count |
+------------+-------------+
| Mammootty  |           8 |
| Mohanlal   |           5 |
+------------+-------------+
*/



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|   vote_count	|	prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers	   |		830	|		1     |
|	.	   |		.	|		.     |
|	.	   |		.	|	        .     |
+------------------+--------------------+---------------------+*/
-- Type your code below:

WITH ranking AS(
SELECT production_company, sum(total_votes) AS vote_count,
	RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie AS m
	INNER JOIN ratings AS r ON r.movie_id=m.id
GROUP BY production_company)
SELECT production_company, vote_count, prod_comp_rank
FROM ranking
WHERE prod_comp_rank<4;

/*
Top three production houses based on the number of votes received by their movies are Marvel Studios, Twentieth Century Fox and Warner Bros.
+-----------------------+------------+----------------+
| production_company    | vote_count | prod_comp_rank |
+-----------------------+------------+----------------+
| Marvel Studios        |    2656967 |              1 |
| Twentieth Century Fox |    2411163 |              2 |
| Warner Bros.          |    2396057 |              3 |
+-----------------------+------------+----------------+
*/



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+--------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes  |	movie_count	   |	actor_avg_rating  |    actor_rank   |
+---------------+--------------------+---------------------+----------------------+-----------------+
|Yogi Babu	|	3455	     |	       11	   |	   8.42	          |     1   	    |
|.		|	.	     |	       .	   |	   .	    	  |	.           |
|.		|	.	     |	       .	   |	   .	    	  |	.           |
|.		|       .	     |	       .	   |	   .	    	  |	.           |
+---------------+--------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Considering Only Indian Movies
WITH actor_summary AS (
    SELECT 
        N.name AS actor_name,
        COUNT(R.movie_id) AS movie_count,
        SUM(R.total_votes) AS total_votes,
        ROUND(SUM(R.avg_rating * R.total_votes) / SUM(R.total_votes), 2) AS actor_avg_rating
    FROM 
        movie AS M
        INNER JOIN ratings AS R ON M.id = R.movie_id
        INNER JOIN role_mapping AS RM ON M.id = RM.movie_id
        INNER JOIN names AS N ON RM.name_id = N.id
    WHERE 
        RM.category = 'ACTOR'
        AND M.country = 'India'
    GROUP BY 
        N.name
    HAVING 
        COUNT(R.movie_id) >= 5
)
SELECT 
    actor_name,
    movie_count,
    total_votes,
    actor_avg_rating,
    RANK() OVER (ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
FROM 
    actor_summary
ORDER BY 
    actor_rank;

/*
Top actor is Vijay Sethupathi followed by Fahadh Faasil and Yogi Babu.
+--------------------+-------------+-------------+------------------+------------+
| actor_name         | movie_count | total_votes | actor_avg_rating | actor_rank |
+--------------------+-------------+-------------+------------------+------------+
| Vijay Sethupathi   |           5 |       23114 |             8.42 |          1 |
| Fahadh Faasil      |           5 |       13557 |             7.99 |          2 |
| Yogi Babu          |          11 |        8500 |             7.83 |          3 |
| Joju George        |           5 |        3926 |             7.58 |          4 |
| Ammy Virk          |           6 |        2504 |             7.55 |          5 |
| Dileesh Pothan     |           5 |        6235 |             7.52 |          6 |
| Kunchacko Boban    |           6 |        5628 |             7.48 |          7 |
| Pankaj Tripathi    |           5 |       40728 |             7.44 |          8 |
| Rajkummar Rao      |           6 |       42560 |             7.37 |          9 |
| Dulquer Salmaan    |           5 |       17666 |             7.30 |         10 |
| Amit Sadh          |           5 |       13355 |             7.21 |         11 |
| Tovino Thomas      |           8 |       11596 |             7.15 |         12 |
| Mammootty          |           8 |       12613 |             7.04 |         13 |
| Nassar             |           5 |        4016 |             7.03 |         14 |
| Karamjit Anmol     |           6 |        1970 |             6.91 |         15 |
| Hareesh Kanaran    |           5 |        3196 |             6.58 |         16 |
| Naseeruddin Shah   |           5 |       12604 |             6.54 |         17 |
| Anandraj           |           6 |        2750 |             6.54 |         18 |
| Mohanlal           |           6 |       17244 |             6.51 |         19 |
| Siddique           |           7 |        5953 |             6.43 |         20 |
| Aju Varghese       |           5 |        2237 |             6.43 |         21 |
| Prakash Raj        |           6 |        8548 |             6.37 |         22 |
| Jimmy Sheirgill    |           6 |        3826 |             6.29 |         23 |
| Mahesh Achanta     |           6 |        2716 |             6.21 |         24 |
| Biju Menon         |           5 |        1916 |             6.21 |         25 |
| Suraj Venjaramoodu |           6 |        4284 |             6.19 |         26 |
| Abir Chatterjee    |           5 |        1413 |             5.80 |         27 |
| Sunny Deol         |           5 |        4594 |             5.71 |         28 |
| Radha Ravi         |           5 |        1483 |             5.70 |         29 |
| Prabhu Deva        |           5 |        2044 |             5.68 |         30 |
+--------------------+-------------+-------------+------------------+------------+
*/

-- Considering all the movies which have released in Hindi language
WITH ActorRatings AS (
    SELECT 
        n.name AS actor_name, 
        SUM(r.total_votes) AS total_votes, 
        COUNT(m.id) AS movie_count, 
        ROUND(SUM(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2) AS 'actor_avg_rating'
    FROM 
        movie m
    INNER JOIN 
        ratings r ON r.movie_id = m.id
    INNER JOIN 
        role_mapping rm ON rm.movie_id = m.id
    INNER JOIN 
        names n ON rm.name_id = n.id
    WHERE 
        rm.category = 'actor'
        AND m.country LIKE '%India%'
    GROUP BY 
        n.name
    HAVING 
        COUNT(m.id) > 4
)
SELECT 
    actor_name, 
    total_votes, 
    movie_count, 
    actor_avg_rating, 
    RANK() OVER (ORDER BY actor_avg_rating DESC, total_votes DESC) AS 'actor_rank'
FROM 
    ActorRatings
ORDER BY 
    actor_rank;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes |	movie_count	  |actress_avg_rating 	 |  actress_ranK   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|    Tabu	|	3455	    |	       11	  |	   8.42	    	 |		1  |
|	.       |	.	    |	       .	  |	   .	    	 |		.  |
|	.	|	.	    |	       .	  |	   .	    	 |		.  |
|	.	|	.	    |	       .	  |	   .	    	 |		.  |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_summary AS (
    SELECT 
        N.name AS actress_name,
        COUNT(R.movie_id) AS movie_count,
        SUM(R.total_votes) AS total_votes,
        ROUND(SUM(R.avg_rating * R.total_votes) / SUM(R.total_votes), 2) AS actress_avg_rating
    FROM 
        movie AS M
        INNER JOIN ratings AS R ON M.id = R.movie_id
        INNER JOIN role_mapping AS RM ON M.id = RM.movie_id
        INNER JOIN names AS N ON RM.name_id = N.id
    WHERE 
        RM.category = 'ACTRESS'
        AND M.country = 'INDIA'
        AND M.languages LIKE '%HINDI%'
    GROUP BY 
        N.name
    HAVING 
        COUNT(R.movie_id) >= 3
)
SELECT 
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating,
    RANK() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC) AS actress_rank
FROM 
    actress_summary
ORDER BY 
    actress_rank
LIMIT 5;


/*
Top five actresses in Hindi movies released in India based on their average ratings are Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda

+-----------------+-------------+-------------+--------------------+--------------+
| actress_name    | total_votes | movie_count | actress_avg_rating | actress_rank |
+-----------------+-------------+-------------+--------------------+--------------+
| Taapsee Pannu   |       18061 |           3 |               7.74 |            1 |
| Kriti Sanon     |       21967 |           3 |               7.05 |            2 |
| Divya Dutta     |        8579 |           3 |               6.88 |            3 |
| Shraddha Kapoor |       26779 |           3 |               6.63 |            4 |
| Kriti Kharbanda |        2549 |           3 |               4.80 |            5 |
+-----------------+-------------+-------------+--------------------+--------------+
*/





/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


WITH thriller_movies AS (
    SELECT DISTINCT 
        M.title,
        R.avg_rating
    FROM 
        movie AS M
        INNER JOIN ratings AS R ON R.movie_id = M.id
        INNER JOIN genre AS G USING(movie_id)
    WHERE 
        G.genre LIKE 'THRILLER'
)
SELECT 
    title,
    avg_rating,
    CASE
        WHEN avg_rating > 8 THEN 'Superhit movies'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
    END AS avg_rating_category
FROM 
    thriller_movies;




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+----------------------+----------------------+
| genre		|	avg_duration|running_total_duration| moving_avg_duration  |
+---------------+-------------------+----------------------+----------------------+
|	comdy	|	145	    |	       106.2	  |	   128.42     	  |
|	.	|	.           |	       .	  |	   .		  |
|	.	|	.	    |	       .	  |	   .	    	  |
|	.	|	.      	    |          .	  |	   .	    	  |
+---------------+-------------------+---------------------+-----------------------+*/
-- Type your code below:

WITH genre_avg_duration AS (
    SELECT 
        g.genre,
        ROUND(AVG(m.duration), 2) AS avg_duration
    FROM 
        movie AS m
        INNER JOIN genre AS g ON m.id = g.movie_id
    GROUP BY 
        g.genre
)
SELECT 
    genre,
    avg_duration,
    SUM(avg_duration) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
    AVG(avg_duration) OVER (ORDER BY genre ROWS BETWEEN 10 PRECEDING AND CURRENT ROW) AS moving_avg_duration
FROM 
    genre_avg_duration
ORDER BY 
    genre;

/*
Genre-wise running total and moving average of the average movie duration are -
+-----------+--------------+------------------------+---------------------+
| genre     | avg_duration | running_total_duration | moving_avg_duration |
+-----------+--------------+------------------------+---------------------+
| Action    |       112.88 |                 112.88 |          112.880000 |
| Adventure |       101.87 |                 214.75 |          107.375000 |
| Comedy    |       102.62 |                 317.37 |          105.790000 |
| Crime     |       107.05 |                 424.42 |          106.105000 |
| Drama     |       106.77 |                 531.19 |          106.238000 |
| Family    |       100.97 |                 632.16 |          105.360000 |
| Fantasy   |       105.14 |                 737.30 |          105.328571 |
| Horror    |        92.72 |                 830.02 |          103.752500 |
| Mystery   |       101.80 |                 931.82 |          103.535556 |
| Others    |       100.16 |                1031.98 |          103.198000 |
| Romance   |       109.53 |                1141.51 |          103.773636 |
| Sci-Fi    |        97.94 |                1239.45 |          102.415455 |
| Thriller  |       101.58 |                1341.03 |          102.389091 |
+-----------+--------------+------------------------+---------------------+
*/

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre		|	year	    |	movie_name	  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|comedy		|	2017	    |     indian	  |	   $103244842    |    1	           |
|.		|	.	    |	       . 	  |	   .	         |    .	           |
|.		|	.      	    |	       .	  |	   .	         |    .	           |
|.		|	.   	    |	       .	  |	   .	         |    .	           |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies


WITH top3_genre AS (
    SELECT 
        genre,
        COUNT(movie_id) AS movie_count
    FROM 
        genre
    GROUP BY 
        genre
    ORDER BY 
        movie_count DESC
    LIMIT 3
),

-- Convert and rank movies based on worldwide gross income
top5_movie AS (
    SELECT 
        g.genre,
        m.year,
        m.title AS movie_name,
        CASE
            WHEN m.worlwide_gross_income LIKE 'INR%' THEN
                CONCAT('$', FORMAT(CAST(REPLACE(REPLACE(m.worlwide_gross_income, 'INR', ''), ' ', '') AS DECIMAL(15, 2)) / 82, 2))
            WHEN m.worlwide_gross_income LIKE '$%' THEN
                CONCAT('$', REPLACE(REPLACE(m.worlwide_gross_income, '$', ''), ' ', ''))
            ELSE
                NULL
        END AS worldwide_gross_income_usd,
        DENSE_RANK() OVER (PARTITION BY m.year ORDER BY 
            CASE
                WHEN m.worlwide_gross_income LIKE 'INR%' THEN
                    CAST(REPLACE(REPLACE(m.worlwide_gross_income, 'INR', ''), ' ', '') AS DECIMAL(15, 2)) / 82
                WHEN m.worlwide_gross_income LIKE '$%' THEN
                    CAST(REPLACE(REPLACE(m.worlwide_gross_income, '$', ''), ' ', '') AS DECIMAL(15, 2))
                ELSE
                    NULL
            END DESC) AS movie_rank
    FROM 
        movie AS m
        INNER JOIN genre AS g ON m.id = g.movie_id
    WHERE 
        g.genre IN (SELECT genre FROM top3_genre)
)

-- Select top 5 highest-grossing movies per year and genre
SELECT 
    genre,
    year,
    movie_name,
    worldwide_gross_income_usd AS worldwide_gross_income,
    movie_rank
FROM 
    top5_movie
WHERE 
    movie_rank <= 5
ORDER BY 
    year,
    movie_rank;


/*
Assumed $1 to be 82 INR, Please fine the Yearly rank of heighest world wide gross income below in tabular formnat.
+----------+------+--------------------------------+------------------------+------------+
| genre    | year | movie_name                     | worldwide_gross_income | movie_rank |
+----------+------+--------------------------------+------------------------+------------+
| Thriller | 2017 | The Fate of the Furious        | $1236005118            |          1 |
| Comedy   | 2017 | Despicable Me 3                | $1034799409            |          2 |
| Comedy   | 2017 | Jumanji: Welcome to the Jungle | $962102237             |          3 |
| Drama    | 2017 | Zhan lang II                   | $870325439             |          4 |
| Thriller | 2017 | Zhan lang II                   | $870325439             |          4 |
| Comedy   | 2017 | Guardians of the Galaxy Vol. 2 | $863756051             |          5 |
| Drama    | 2018 | Bohemian Rhapsody              | $903655259             |          1 |
| Thriller | 2018 | Venom                          | $856085151             |          2 |
| Thriller | 2018 | Mission: Impossible - Fallout  | $791115104             |          3 |
| Comedy   | 2018 | Deadpool 2                     | $785046920             |          4 |
| Comedy   | 2018 | Ant-Man and the Wasp           | $622674139             |          5 |
| Drama    | 2019 | Avengers: Endgame              | $2797800564            |          1 |
| Drama    | 2019 | The Lion King                  | $1655156910            |          2 |
| Comedy   | 2019 | Toy Story 4                    | $1073168585            |          3 |
| Drama    | 2019 | Joker                          | $995064593             |          4 |
| Thriller | 2019 | Joker                          | $995064593             |          4 |
| Thriller | 2019 | Ne Zha zhi mo tong jiang shi   | $700547754             |          5 |
+----------+------+--------------------------------+------------------------+------------+
*/





-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count	|	prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers	    |	830		|	1	      |
|	.	    |	.		|	.	      |
|	.	    |	.		|	.	      |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_summary
     AS (SELECT production_company,
                Count(*) AS movie_count
         FROM   movie AS m
                inner join ratings AS r
                        ON r.movie_id = m.id
         WHERE  median_rating >= 8
                AND production_company IS NOT NULL
                AND Position(',' IN languages) > 0
         GROUP  BY production_company
         ORDER  BY movie_count DESC)
SELECT *,
       Rank()
         over(
           ORDER BY movie_count DESC) AS prod_comp_rank
FROM   production_company_summary
LIMIT 2; 

/*
Star Cinema and Twentieth Century Fox are the top two production houses that have produced the highest number of hits among multilingual movies.
+-----------------------+-------------+----------------+
| production_company    | movie_count | prod_comp_rank |
+-----------------------+-------------+----------------+
| Star Cinema           |           7 |              1 |
| Twentieth Century Fox |           4 |              2 |
+-----------------------+-------------+----------------+
*/

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes |	movie_count	  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|Laura Dern	|           1016    |	       1	  |	   9.60		 |	1          |
|.		|              .    |	       .	  |	   .	    	 |	.	   |
|.		|              .    |	       .	  |	   .	    	 |	.          |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_summary AS
(
           SELECT     n.NAME AS actress_name,
                      SUM(total_votes) AS total_votes,
                      Count(r.movie_id)                                     AS movie_count,
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM       movie                                                 AS m
           INNER JOIN ratings                                               AS r
           ON         m.id=r.movie_id
           INNER JOIN role_mapping AS rm
           ON         m.id = rm.movie_id
           INNER JOIN names AS n
           ON         rm.name_id = n.id
           INNER JOIN GENRE AS g
           ON g.movie_id = m.id
           WHERE      category = 'ACTRESS'
           AND        avg_rating>8
           AND genre = "Drama"
           GROUP BY   NAME )
SELECT   *,
         Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM     actress_summary LIMIT 3;

/*
Top 3 actresses based on number of Super Hit movies are Parvathy Thiruvothu, Susan Brown and Amanda Lawrence
+---------------------+-------------+-------------+--------------------+--------------+
| actress_name        | total_votes | movie_count | actress_avg_rating | actress_rank |
+---------------------+-------------+-------------+--------------------+--------------+
| Parvathy Thiruvothu |        4974 |           2 |               8.25 |            1 |
| Susan Brown         |         656 |           2 |               8.94 |            1 |
| Amanda Lawrence     |         656 |           2 |               8.94 |            1 |
+---------------------+-------------+-------------+--------------------+--------------+
*/

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|     director_name |	number_of_movies  | avg_inter_movie_days |  avg_rating	| total_votes  | min_rating | max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967	|	A.L. Vijay  |			5 |	       177	 |	   5.65	|	1754   |	3.7 |	6.9	 |  613		  |
|	.	|		.   |			. |	       .	 |	   .	|	.      |	.   |	.	 |    .		  |
|	.	|		.   |			. |	       .	 |	   .	|	.      |	.   |	.	 |    .		  |
|	.	|		.   |			. |	       .	 |	   .	|	.      |	.   |	.	 |    .		  |
|	.	|		.   |			. |	       .	 |	   .	|	.      |	.   |	.	 |    .		  |
|	.	|		.   |			. |	       .	 |	   .	|	.      |	.   |	.	 |    .		  |
|	.	|		.   |			. |	       .	 |	   .	|	.      |	.   |	.	 |    .		  |
|	.	|		.   |			. |	       .	 |	   .	|	.      |	.   |	.	 |    .		  |
|	.	|		.   |			. |	       .	 |	   .	|	.      |	.   |	.	 |    .		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

*/
-- Type you code below:


WITH next_date_published_summary AS
(
           SELECT     d.name_id,
                      NAME,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM       director_mapping                                                                      AS d
           INNER JOIN names                                                                                 AS n
           ON         n.id = d.name_id
           INNER JOIN movie AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id ), top_director_summary AS
(
       SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   next_date_published_summary )
SELECT   name_id                       AS director_id,
         NAME                          AS director_name,
         Count(movie_id)               AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2)               AS avg_rating,
         Sum(total_votes)              AS total_votes,
         Min(avg_rating)               AS min_rating,
         Max(avg_rating)               AS max_rating,
         Sum(duration)                 AS total_duration
FROM     top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;

/* Requested details are below in tabular form.
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
| director_id | director_name     | number_of_movies | avg_inter_movie_days | avg_rating | total_votes | min_rating | max_rating | total_duration |
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
| nm2096009   | Andrew Jones      |                5 |               190.75 |       3.02 |        1989 |        2.7 |        3.2 |            432 |
| nm1777967   | A.L. Vijay        |                5 |               176.75 |       5.42 |        1754 |        3.7 |        6.9 |            613 |
| nm0814469   | Sion Sono         |                4 |               331.00 |       6.03 |        2972 |        5.4 |        6.4 |            502 |
| nm0831321   | Chris Stokes      |                4 |               198.33 |       4.33 |        3664 |        4.0 |        4.6 |            352 |
| nm0515005   | Sam Liu           |                4 |               260.33 |       6.23 |       28557 |        5.8 |        6.7 |            312 |
| nm0001752   | Steven Soderbergh |                4 |               254.33 |       6.48 |      171684 |        6.2 |        7.0 |            401 |
| nm0425364   | Jesse V. Johnson  |                4 |               299.00 |       5.45 |       14778 |        4.2 |        6.5 |            383 |
| nm2691863   | Justin Price      |                4 |               315.00 |       4.50 |        5343 |        3.0 |        5.8 |            346 |
| nm6356309   | Özgür Bakar       |                4 |               112.00 |       3.75 |        1092 |        3.1 |        4.9 |            374 |
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
*/




