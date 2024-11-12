--Q1:- Who is the senior most emplyee based on job tittle 

Answer
SELECT * FROM employee
ORDER BY levels DESC
LIMIT 1

--Q2:- Which countries have the most invoices ?

Answer
SELECT COUNT(*) AS c, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY c DESC

--Q3:- What are top 3 values of total invoice

Answer
SELECT * FROM invoice
ORDER BY total DESC
LIMIT 3

--Q4:- Which city has the best customer? We would like to throw a promotional music 
--     festival in the city we made the most money. Write a query that return one city 
--     that has the highest sum of invoice totals. Return both the city and sum of all
--     invoice totals.

Answer
--SELECT * FROM invoice
SELECT SUM(total) AS invoice_total, billing_city
FROM invoice
GROUP BY billing_city
ORDER BY invoice_total DESC

--Q5:- Who is the best customer ? The Customer Who has spent most money will be declared
--     be declared the best cusomer. Writer a query that return the person who has spend 
--     the most money.

Answer
--SELECT* FROM customer
SELECT C.customer_id, C.first_name, C.last_name, SUM(I.total) AS total
FROM customer AS C
JOIN invoice AS I
ON C.customer_id = I.customer_id
GROUP BY C.customer_id
ORDER BY total DESC
LIMIT 1

--Q6:- Write query to return the email, first name, last name & genre of all Rock Music 
--     listeners. Return Your list ordered alphabetically by email starting with A

SELECT DISTINCT email, first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
     SELECT track_id FROM track 
	 JOIN genre ON track.genre_id = genre.genre_id
	 WHERE  genre.name LIKE 'Rock'
)
ORDER BY email;

-- Q7:- Lets invite the artists eho have written the most rock musis in our dataset. Write
--     a query that returns the artist name and total track count of the top 10 rock bands.
SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;


--Q8:- Write a query that determine the customer that has spent the most on music for each 
--     country. write a query that returns the country along with the customer and how must they spent.
--     for countries where the top amount spent is shared, provideall customers who spent this amount

WITH customer_with_country AS (
      SELECT customer.customer_id, first_name, last_name, billing_country, SUM(total) AS total_spending,
	  ROW_NUMBER()  OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS Row_No
	  FROM invoice
	  JOIN customer
	  ON customer.customer_id = invoice.customer_id
	  GROUP BY 1,2,3,4
	  ORDER BY 4 ASC, 5 DESC )
	  SELECT * FROM customer_with_country WHERE Row_No <= 1

	  select*from customer
