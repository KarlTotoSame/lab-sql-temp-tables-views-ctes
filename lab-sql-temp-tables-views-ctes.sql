#Creating a Customer Summary Report

#In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database,
#including their rental history and payment details. 
# The report will be generated using a combination of views, CTEs, and temporary tables.

#Step 1: Create a View
#First, create a view that summarizes rental information for each customer. 
#The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
create view customer_rental_summary as
select 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    count(r.rental_id) as rental_count
from customer c
inner join rental r on c.customer_id = r.customer_id
group by 1,2,3,4;

select * from customer_rental_summary;

#Step 2: Create a Temporary Table
#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid).
# The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.
create temporary table customer_payment_summary as
select 
    c.customer_id,
    SUM(p.amount) AS total_paid
from customer_rental_summary c
join payment p 
on c.customer_id = p.customer_id
group by c.customer_id;

select * from customer_payment_summary;

#Step 3: Create a CTE and the Customer Summary Report
#Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
#The CTE should include the customer's name, email address, rental count, and total amount paid.
#Next, using the CTE, create the query to generate the final customer summary report, which should include: 
#customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

with customer_summary_cte as (
							  select crs.first_name, crs.last_name, crs.email, crs.rental_count, cps.total_paid,
							  (cps.total_paid / crs.rental_count) AS average_payment_per_rental
                              from customer_rental_summary crs
							  join customer_payment_summary cps 
							  on crs.customer_id = cps.customer_id
)
select 
    first_name,
    last_name,
    email,
    rental_count,
    total_paid,
    average_payment_per_rental
from  customer_summary_cte
order by last_name, first_name;


