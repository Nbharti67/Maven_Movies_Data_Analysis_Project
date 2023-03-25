USE mavenmovies;
/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 

SELECT 
	store.store_id,
	staff.first_name AS Manager_first_name,
    staff.last_name AS Manager_last_name,
    address.address,
   -- address.address2,
    address.district,
    city.city,
    country.country
    -- address.postal_code
FROM store
	LEFT JOIN staff
		ON store.store_id = staff.store_id
	LEFT JOIN address
		ON store.address_id = address.address_id
        /* here store.store_adress not staff.address_id because staff.address_id will give the home address of staff while store.store_address wil give store address*/
	LEFT JOIN city
		ON address.city_id = city.city_id
	LEFT JOIN country
		ON city.country_id = country.country_id
;

/*
SELECT 
	staff.first_name AS manager_first_name, 
    staff.last_name AS manager_last_name,
    address.address, 
    address.district, 
    city.city, 
    country.country

FROM store
	LEFT JOIN staff ON store.manager_staff_id = staff.staff_id
    LEFT JOIN address ON store.address_id = address.address_id
    LEFT JOIN city ON address.city_id = city.city_id
    LEFT JOIN country ON city.country_id = country.country_id
;

*/

/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/
CREATE TEMPORARY TABLE Inventory_List
SELECT 
	inventory.store_id AS store_id_Number,
    inventory.inventory_id AS inventory_ID,
    film.title AS Name_of_the_film,
    film.rating,
    film.rental_rate,
    film.replacement_cost
    
FROM inventory
	LEFT JOIN film
    ON film.film_id = inventory.film_id
;

SELECT * FROM Inventory_List;
/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store.
 
*/
SELECT
	inventory.store_id,
    film.rating,
    COUNT(DISTINCT inventory.inventory_id) AS inventory_items
FROM inventory
	LEFT JOIN film
		ON inventory.film_id = film.film_id
GROUP BY film.rating,
		inventory.store_id
ORDER BY inventory.store_id
;

/*
SELECT 
	inventory.store_id, 
    film.rating, 
    COUNT(inventory_id) AS inventory_items
FROM inventory
	LEFT JOIN film
		ON inventory.film_id = film.film_id
GROUP BY 
	inventory.store_id,
    film.rating;
*/

/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
no of films, average replacement cost, total replacement cost, store_id, film category
*/ 

SELECT 
	inventory.store_id AS stor,
    category.name AS film_cat ,
	COUNT(DISTINCT inventory.inventory_id) AS inventory,
    AVG(film.replacement_cost) AS Avg_replacement_cost,
    SUM(film.replacement_cost) AS Total_replacement_cost
FROM inventory
	LEFT JOIN film
		ON inventory.film_id = film.film_id
	LEFT JOIN film_category
		ON film.film_id = film_category.film_id
	LEFT JOIN category
		ON film_category.category_id = category.category_id
GROUP BY stor,
		film_cat
ORDER BY 
		SUM(film.replacement_cost) DESC,
        stor
;

/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
customer name, store_id, Status(active/not active), address
*/

SELECT 
	customer.first_name, 
    customer.last_name,
    customer.store_id,
    customer.active,
    address.address,
    address.address2,
   -- address.district
   city.city,
   country.country
   
FROM customer
	LEFT JOIN address
		ON customer.address_id = address.address_id
	LEFT JOIN city
		ON address.city_id = city.city_id
	LEFT JOIN country
		ON city.country_id = country.country_id
;

/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
customer names, total lifetime rental, sum of all payments, 
*/

SELECT 
	customer.first_name,
    customer.last_name,
    COUNT(DISTINCT rental.rental_id) AS Total_Lifetime_rental,
    SUM(payment.amount) AS payments
FROM customer
	LEFT JOIN rental
		ON customer.customer_id = rental.customer_id
	LEFT JOIN payment
		ON payment.rental_id =rental.rental_id
GROUP BY customer.first_name,
		 customer.last_name
ORDER BY payments DESC
;


    
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/
/* Summary and data that needs to find
list of advisors name, investors name, type, company they work in for investors
Here it is must to mention NULL because count of columns is diffreent so to make some number of column we are adding NULL. This way both table table will have same number of column selected.*/

SELECT 
	"advisor" AS type,
	first_name,
    last_name,
    NULL
FROM advisor

UNION
 
SELECT 
	"investor" AS type,
    first_name,
    last_name,
    company_name
FROM investor
;


/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/

/* Most awarded actors with three types of award
*/
/*
SELECT 
	first_name,
    last_name,
    
FROM actor_award
WHERE COUNT(DISTINCT actor_award_id) >=3
GROUP BY first_name,
         last_name
;
*/




SELECT
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END AS number_of_awards, 
    AVG(CASE WHEN actor_award.actor_id IS NULL THEN 0 ELSE 1 END) AS pct_w_one_film
	
FROM actor_award
	

GROUP BY 
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END
