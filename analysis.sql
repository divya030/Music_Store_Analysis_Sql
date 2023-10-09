-- Q1. Who is the senior most employee based on job title?

SELECT title
FROM music_store.employee
ORDER BY levels DESC
LIMIT 1;

-- Q2. Which countries have the most Invoices?

SELECT billing_country, count(billing_country)
FROM music_store.invoice
GROUP BY invoice.billing_country 
ORDER BY invoice.billing_country  DESC;

-- Q3. What are top 3 values of total invoice?

SELECT * 
FROM music_store.invoice
ORDER BY total DESC
LIMIT 3;

-- Q4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
--     Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals.

SELECT billing_city as City, sum(total) as Total
FROM music_store.invoice
GROUP BY billing_city
ORDER BY total DESC
LIMIT 1;

-- Q5. Who is the best customer? The customer who has spent the most money will be declared the best customer. 
--     Write a query that returns the person who has spent the most money.

SELECT c.customer_id,c.first_name,c.last_name, sum(i.total) as total
FROM music_store.customer c
INNER JOIN music_store.invoice i 
ON i.customer_id = c.customer_id
GROUP BY i.customer_id
ORDER BY total DESC
LIMIT 1;

-- Q6. Write a query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A 

SELECT first_name, last_name, email, g.name
FROM music_store.customer c
INNER JOIN music_store.invoice i ON i.customer_id = c.customer_id
INNER JOIN music_store.invoice_line il ON i.invoice_id = il.invoice_id
INNER JOIN music_store.track t ON il.track_id = t.track_id
INNER JOIN music_store.genre g ON t.genre_id = g.genre_id
WHERE g.name = "Rock"
GROUP BY email 
ORDER BY email;

-- Q7. Let's invite the artists who have written the most rock music in our dataset. 
--     Write a query that returns the Artist name and total track count of the top 10 rock bands.

SELECT a.artist_id, a.name, count(t.genre_id) as num_of_songs
FROM music_store.artist a
INNER JOIN music_store.album2 al ON a.artist_id = al.artist_id
INNER JOIN music_store.track t ON t.album_id = al.album_id
INNER JOIN music_store.genre g ON t.genre_id = g.genre_id 
WHERE g.name = "Rock"
GROUP BY a.artist_id
ORDER BY num_of_songs DESC
LIMIT 10;

-- Q8. Return all the track names that have a song length longer than the average song length. 
--     Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.

SELECT name, milliseconds
FROM music_store.track
WHERE milliseconds > (SELECT avg(milliseconds) FROM music_store.track)
ORDER BY milliseconds DESC;

-- Q9. Find how much amount spent by each customer on artists. Write a query to return the customer name, artist name, and total spent.

SELECT c.first_name,a.name,round(sum(i.total),2) as total_spent
FROM music_store.customer c
INNER JOIN music_store.invoice i ON i.customer_id = c.customer_id
INNER JOIN music_store.invoice_line il ON il.invoice_id = i.invoice_id
INNER JOIN music_store.track t ON t.track_id = il.track_id
INNER JOIN music_store.album2 al ON al.album_id = t.album_id
INNER JOIN music_store.artist a ON al.artist_id = a.artist_id
GROUP BY c.customer_id, a.artist_id
ORDER BY total_spent;

-- Q10. We want to find out the most popular music Genre for each country. 
--      We determine the most popular genre as the genre with the highest amount of purchases. 
--      Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres.

with popular_genre AS(
	SELECT COUNT(il.quantity) AS purchases, 
	c.country, g.name AS genre_name,
	ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY COUNT(il.quantity) DESC) AS row_num 
	FROM music_store.invoice_line il
	INNER JOIN music_store.invoice i ON i.invoice_id = il.invoice_id
	INNER JOIN music_store.customer c ON c.customer_id = i.customer_id
	INNER JOIN music_store.track t ON t.track_id = il.track_id
	INNER JOIN music_store.genre g ON g.genre_id = t.genre_id
	GROUP BY c.country,g.name
	ORDER BY 2 ASC, 1 DESC)

SELECT country, genre_name, purchases 
FROM popular_genre 
WHERE row_num <= 1;




-- Q11. Write a query that determines the customer that has spent the most on music for each country. 
-- Write a query that returns the country along with the top customer and how much they spent. 
-- For countries where the top amount spent is shared, provide all customers who spent this amount.

WITH customer_country AS (
	SELECT c.customer_id, c.first_name, c.last_name, i.billing_country, sum(i.total) AS total_spent,
	ROW_NUMBER() OVER(PARTITION BY i.billing_country ORDER BY sum(i.total) DESC) AS row_num
	FROM music_store.customer c
	INNER JOIN music_store.invoice i ON i.customer_id = c.customer_id
	GROUP BY i.billing_country
    )
    
SELECT customer_id, first_name, last_name, billing_country, total_spent
FROM customer_country
WHERE row_num = 1;


-- Q12. Who are the 10 most popular artists?

SELECT COUNT(invoice_line.quantity) AS purchases, artist.name AS artist_name
FROM music_store.invoice_line 
INNER JOIN music_store.track ON track.track_id = invoice_line.track_id
INNER JOIN music_store.album2 ON album2.album_id = track.album_id
INNER JOIN music_store.artist ON artist.artist_id = album2.artist_id
GROUP BY artist.artist_id
ORDER BY purchases DESC
LIMIT 10;

-- Q13. List top 10 the most popular song?

SELECT COUNT(il.quantity) AS Purchase, t.name AS Name
FROM music_store.invoice_line il
INNER JOIN music_store.track t ON t.track_id = il.track_id
GROUP BY t.track_id
ORDER BY Purchase DESC
LIMIT 10;

-- Q14. What are the average prices of different types of music?

WITH price_genre AS (
	SELECT g.name, round(sum(i.total),2) AS total_spent
	FROM music_store.invoice i 
	INNER JOIN music_store.invoice_line il ON il.invoice_id = i.invoice_id
	INNER JOIN music_store.track t ON t.track_id = il.track_id
	INNER JOIN music_store.genre g ON g.genre_id = t.genre_id
	GROUP BY g.genre_id
	ORDER BY total_spent DESC
)
SELECT name, concat('$', AVG(total_spent)) AS total_spent
FROM price_genre
GROUP BY name;

-- Q15. What are the most popular countries for music purchases?

SELECT COUNT(il.quantity) AS purchases, c.country
FROM music_store.invoice_line  il
JOIN music_store.invoice i ON i.invoice_id = il.invoice_id
JOIN music_store.customer c ON c.customer_id = i.customer_id
GROUP BY country
ORDER BY purchases DESC;




















