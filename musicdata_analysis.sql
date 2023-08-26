 USE MUSICSTORE_ANALYSIS;
 #1 WHO IS MOST SENIOR EMPLOYEE ON THE BASIS OF JOB TITLE
 SELECT first_name,last_name, tiTLE,LEVELS
 FROM EMPLOYEE 
 order by LEVELS DESC;
 # 2 WHICH COUNTRIES HAVE THE MOST INVOICES 
 SELECT * FROM invoice;
 SELECT  COUNT(*) AS C, BILLING_COUNTRY FROM invoice
group by BILLING_COUNTRY
order by BILLING_COUNTRY DESC
LIMIT 1;
#3 WHAT ARE THE TOP THREE VALUES OF TOTAL_INVOICES
SELECT TOTAL FROM INVOICE
ORDER BY TOTAL DESC
LIMIT 3;
# 4 WHICH CITY HAS THE BEST CUSTOMERS WE WOULD LIKE TO THROW A PROMOTIONAL MUSIC FESTIVAL IN THE 
#CITY WE MADE THE MOST MONEY.WRITE A QUERY THAT RETURNS ONE CITY THAT HAS THE HIGHESYT SUM OF INVOICES TOTALS 
#RETURN BOTH THE CITY NAME AND SUM OF ALL INVOICE TOTALS
select* from invoice;
select*from customer;
select c.city ,sum(i.total) as highest_sum from invoice  as i
join customer as c
on i.customer_id=c.customer_id
group by city
order by highest_sum desc
limit 5;
#5who is the best customer the customer who has spent money will be the declared the besr 
#customer write a query returns the person who has spent the most money
select * from customer;
select * from invoice;
select c.first_name,c.last_name,sum(i.total) as sum_total from customer as c
join invoice as i
on c.customer_id=i.customer_id
group by c.first_name,c.last_name
order by sum_total desc
limit 2;
#6 write a query to return the email fisrt name last name and genre of all rock 
#music listenrs return your list ordered alphabetically by email startin with a 
select * from genre;
select * from customer;
select* from invoice;
select* from invoice_line;
select first_name,last_name,email from customer  as c
join invoice as i 
on i.customer_id=c.customer_id
join invoice_line as il
on il.invoice_id=i.invoice_id
where track_id in( select track_id from track as t
join genre as g on t.genre_id=g.genre_id
where g.name like 'rock'
)
order by email asc;
#7 lets invite artists who have writeen the most rock music in our datset write a query that 
#returns the artist name ans total track count of the top 10 rock 
select* from artist;
select * from track;
select a.artist_id,a.name , count(a.artist_id) as number_of_sings 
from track as t
join album2 as a1 on a1.album_id=t.album_id
join  artist as a  on a.artist_id=a1.artist_id
join genre as g on g.genre_id = t.genre_id
group by a.artist_id ,a.name
order by number_of_sings desc
limit 10;
#8 return all the track names that have a song length return the name and milliseconds for each 
#track order by the song length with the longest songs listed first 
select name , milliseconds from track
where milliseconds >
(select avg(milliseconds) as avg_track_length from track)

order by milliseconds desc;
#9 find how much amount spent by each customer on artists write a query to find 
#return customer name artist name and total spent
WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album2 ON album2.album_id = track.album_id
	JOIN artist ON artist.artist_id = album2.artist_id
	GROUP BY artist.artist_id,artist.name
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album2 alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

#10 we want to find out the popular music genre for each country we detrmine the most popular
#genre as the genre with the highest amonut of purchases write a query that returns each country along with the top 
#genre for countries where the maximum number of purchases is shared return all genres
WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1;
#11: Write a query that determines the customer that has spent the most on music for each country. 
#Write a query that returns the country along with the top customer and how much they spent. 
#For countries where the top amount spent is shared, provide all customers who spent this amount.
WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1;

 \ 



 