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

-- Q6. List top 10 the most popular song?

SELECT COUNT(il.quantity) AS Purchase, t.name AS Name
FROM music_store.invoice_line il
INNER JOIN music_store.track t ON t.track_id = il.track_id
GROUP BY t.track_id
ORDER BY Purchase DESC
LIMIT 10;

-- Q7. What are the most popular countries for music purchases?

SELECT COUNT(il.quantity) AS purchases, c.country
FROM music_store.invoice_line  il
JOIN music_store.invoice i ON i.invoice_id = il.invoice_id
JOIN music_store.customer c ON c.customer_id = i.customer_id
GROUP BY country
ORDER BY purchases DESC;