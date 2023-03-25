/* Assignment is
" The manager from store 2 is wroking on expanding the film collection there.
Could you pull a list of distinct titles and their descriptions, surrently available in inventory at store 2?
*/


USE mavenmovies;

SELECT 
	film.title,
	film.description
FROM film
	INNER JOIN inventory
		ON film.film_id = inventory.inventory_id
		AND inventory.store_id = 2
;
    /* AND takes less time as compare to WHERE clause*/
 /*   
    select * 
    from inventory
    */