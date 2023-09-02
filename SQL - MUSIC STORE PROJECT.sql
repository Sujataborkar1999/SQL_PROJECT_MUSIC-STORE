--Q1: Who is the senior most employee based on job title?
SELECT first_name, last_name, title FROM employee
where levels=(SELECT MAX(levels) FROM employee)
--or
SELECT * FROM employee
where levels=(SELECT MAX(levels) FROM employee)

--Q2: Which countries have the most Invoices?
SELECT COUNT(*) AS no_of_invoices, billing_country FROM invoice
GROUP BY billing_country
ORDER BY no_of_invoices desc

--Q3: What are top 3 values of total invoice?
SELECT TOP 3 total FROM invoice
ORDER BY total desc
--or (for distinct values)
SELECT DISTINCT  TOP 3 total FROM invoice
ORDER BY total desc

--Q.4 Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money.
SELECT TOP 1 billing_city , SUM(CAST(total AS DECIMAL(10,2)))AS Invoice_Total FROM invoice
GROUP BY billing_city
order by Invoice_Total desc

--Q5 Who is the best customer? The customer who has spent the most money will be declared the best customer.
SELECT TOP 1 c.customer_id,c.first_name , c.last_name ,SUM(CAST(i.total AS DECIMAL(10,2)))AS inv_total FROM customer c
JOIN invoice i ON c.customer_id= i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY inv_total desc

--Q.6  Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A.
SELECT DISTINCT email AS Email,first_name AS FirstName, last_name AS LastName, genre.name AS Name
FROM customer
JOIN invoice ON invoice.customer_id = customer.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
ORDER BY email

--Q.7 Let's invite the artists who have written the most rock music in our dataset. 
--Write a query that returns the Artist name and total track count of the top 10 rock bands
SELECT TOP 10  r.artist_id , r.[name] , count(r.artist_id)AS Total_trackcount FROM track t
JOIN album a ON a.album_id=t.album_id
JOIN artist r ON r.artist_id= a.artist_id
JOIN genre g ON g.genre_id=t.genre_id
WHERE g.name LIKE 'Rock'
GROUP BY r.artist_id, r.[name]
ORDER BY Total_trackcount desc

--Q.8  Return all the track names that have a song length longer than the average song length. 
--Return the Name and Milliseconds for each track. 
--Order by the song length with the longest songs listed first.
SELECT name, milliseconds
FROM track
WHERE milliseconds >(
SELECT AVG(CAST(milliseconds AS INT)) AS Average_song_length FROM track
)
ORDER BY milliseconds DESC

--Q.9 We want to find out the most popular music Genre for each country. 
--We determine the most popular genre as the genre with the highest amount of purchases. 
--Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres
WITH GenrePurchases AS (
    SELECT
        c.country AS Country,
        g.name AS Genre,
        COUNT(il.invoice_id) AS PurchaseCount,
        ROW_NUMBER() OVER (PARTITION BY c.country ORDER BY COUNT(il.invoice_id) DESC) AS GenreRank
    FROM
        customer c
        INNER JOIN invoice i ON c.customer_id = i.customer_id
        INNER JOIN invoice_line il ON i.invoice_id = il.invoice_id
        INNER JOIN track t ON il.track_id = t.track_id
        INNER JOIN genre g ON t.genre_id = g.genre_id
    GROUP BY
        c.country,
        g.name
)
SELECT
    Country,
    Genre
FROM
    GenrePurchases
WHERE
    GenreRank = 1
ORDER BY
    Country, Genre;


		)



































