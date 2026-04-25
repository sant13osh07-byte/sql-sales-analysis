create database db_sales1;
use db_sales1;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    gender VARCHAR(10)
);
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price INT
);
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
CREATE TABLE Order_Details (
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
show tables;
select * from orders;

select gender,count(*)
	   from customers
       group by gender ;
       
select city , count(*)
from customers 
group by city;
       
select c.customer_id,c.customer_name,c.city,p.product_name,o.order_date,od.quantity,o.total_amount
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od  on o.order_id = od.order_id
join products p on od.product_id = p.product_id;

select c.customer_id,c.customer_name,c.city,p.product_name,o.order_date,od.quantity,o.total_amount
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od  on o.order_id = od.order_id
join products p on od.product_id = p.product_id
where city = c.city;

select c.customer_id,
       c.customer_name,
       sum(od.quantity) as quantity,
       sum(od.quantity * p.price) as revenue
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
group by c.customer_id, c.customer_name;


select c.customer_id,c.city,
       c.customer_name,
       sum(od.quantity) as quantity,
       sum(od.quantity * p.price) as revenue
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
where c.city ="madurai"
group by c.customer_id, c.city
order by revenue desc
limit 10;

SELECT 
    t.customer_id,
    MIN(t.order_date) AS streak_start,
    MAX(t.order_date) AS streak_end,
    COUNT(*) AS streak_length
FROM (
    SELECT 
        o.customer_id,
        DATE(o.order_date) AS order_date,
        DATE_SUB(DATE(o.order_date),
                 INTERVAL ROW_NUMBER() OVER (
                     PARTITION BY o.customer_id 
                     ORDER BY DATE(o.order_date)
                 ) DAY) AS grp
    FROM orders o
) t
GROUP BY t.customer_id, t.grp
ORDER BY t.customer_id, streak_length DESC;
     

select c.city,sum(od.quantity * p.price) as revenue
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
group by c.city
;

select  c.customer_id,c.customer_name,sum(od.quantity * p.price) as revenue
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
group by c.customer_id
;

select  p.product_name,p.category,sum(od.quantity * p.price) as revenue
from customers c
join orders o on c.customer_id = o.customer_id
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
group by p.category,p.product_name
;

select distinct product_name from products
;

select customer_id,
       count(order_id) as total_orders
from orders
group by customer_id
having count(order_id) > 1;

select *
from (
    select c.city,
           c.customer_name,
           sum(od.quantity * p.price) as revenue,
           rank() over (partition by c.city order by sum(od.quantity * p.price) desc) as rnk
    from customers c
    join orders o on c.customer_id = o.customer_id
    join order_details od on o.order_id = od.order_id
    join products p on od.product_id = p.product_id
    group by c.city, c.customer_name
) t
where rnk = 1;

select month(order_date) as month,
       sum(total_amount) as revenue
from orders
group by month
order by month;

select *
from (
    select c.customer_id,
           p.product_name,
           sum(od.quantity) as total_qty,
           rank() over (partition by c.customer_id order by sum(od.quantity) desc) as rnk
    from customers c
    join orders o on c.customer_id = o.customer_id
    join order_details od on o.order_id = od.order_id
    join products p on od.product_id = p.product_id
    group by c.customer_id, p.product_name
) t
where rnk = 1;
