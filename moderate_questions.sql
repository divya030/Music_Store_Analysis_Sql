-- Q1. Write a query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A 

SELECT first_name, last_name, email, g.name
FROM music_store.customer c
INNER JOIN music_store.invoice i ON i.customer_id = c.customer_id
INNER JOIN music_store.invoice_line il ON i.invoice_id = il.invoice_id
INNER JOIN music_store.track t ON il.track_id = t.track_id
INNER JOIN music_store.genre g ON t.genre_id = g.genre_id
WHERE g.name = "Rock"
GROUP BY email 
ORDER BY email;


-- Q2. Let's invite the artists who have written the most rock music in our dataset. 
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

-- Q3. Return all the track names that have a song length longer than the average song length. 
--     Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.

SELECT name, milliseconds
FROM music_store.track
WHERE milliseconds > (SELECT avg(milliseconds) FROM music_store.track)
ORDER BY milliseconds DESC;

-- Q4. Who are the 10 most popular artists?

SELECT COUNT(invoice_line.quantity) AS purchases, artist.name AS artist_name
FROM music_store.invoice_line 
INNER JOIN music_store.track ON track.track_id = invoice_line.track_id
INNER JOIN music_store.album2 ON album2.album_id = track.album_id
INNER JOIN music_store.artist ON artist.artist_id = album2.artist_id
GROUP BY artist.artist_id
ORDER BY purchases DESC
LIMIT 10;

-- Q5. What are the average prices of different types of music?

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