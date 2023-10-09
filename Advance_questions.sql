-- Q1. Find how much amount spent by each customer on artists. Write a query to return the customer name, artist name, and total spent.

SELECT c.first_name,a.name,round(sum(i.total),2) as total_spent
FROM music_store.customer c
INNER JOIN music_store.invoice i ON i.customer_id = c.customer_id
INNER JOIN music_store.invoice_line il ON il.invoice_id = i.invoice_id
INNER JOIN music_store.track t ON t.track_id = il.track_id
INNER JOIN music_store.album2 al ON al.album_id = t.album_id
INNER JOIN music_store.artist a ON al.artist_id = a.artist_id
GROUP BY c.customer_id, a.artist_id
ORDER BY total_spent;


-- Q2. We want to find out the most popular music Genre for each country. 
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


-- Q3. Write a query that determines the customer that has spent the most on music for each country. 
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
