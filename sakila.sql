use sakila;
show tables;
desc film;
select * from payment;
show create table payment;

select 
    f.title  film_title,
    SUM(p.amount)  total_rent_received
from 
    payment p
join 
	 rental  r on r.rental_id = p.rental_id
join 
    inventory i on i.inventory_id = r.inventory_id
join 
    film f on f.film_id = i.film_id
group by 
    f.film_id, f.title
order by 
    total_rent_received desc;
