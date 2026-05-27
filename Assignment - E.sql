create database company;
use company;

CREATE TABLE Sales (
    id INT,
    employee VARCHAR(50),
    department CHAR(1),
    sales_amount INT,
    sale_date DATE
);

INSERT INTO Sales VALUES
(1, 'Alice', 'A', 1000, '2024-01-01'),
(2, 'Bob', 'B', 1500, '2024-01-02'),
(3, 'Alice', 'A', 2000, '2024-01-03'),
(4, 'Bob', 'B', 1800, '2024-01-04'),
(5, 'Alice', 'A', 1200, '2024-01-05'),
(6, 'Bob', 'B', 1600, '2024-01-06');

# 1. Total Sales Per Employee (Running Total)

select employee,
sales_amount,
sum(sales_amount) over(partition by employee order by id) as running_total
from sales;

# 2. Row Number Per Employee

select employee,
sales_amount,
row_number() over(partition by employee order by sales_amount desc) as row_num
from sales;

# 3. Rank of Sales Per Department

select department,
employee,
sales_amount,
rank() over(partition by department order by sales_amount desc) as rnk
from sales;

# 4. Lead (Next Sale) Per Employee

select employee,
sales_amount,
lead(sales_amount) over(partition by employee order by id) as next_sale
from sales;

# 5. lag previous sale per employee

select employee,
sales_amount,
lag(sales_amount) over(partition by employee order by id) as prev_sale
from sales;

# 6. average sales per employee

select employee,
sales_amount,
avg(sales_amount) over(partition by employee) as avg_sale
from sales;

# 7. first and last sales per employee

select employee,
sales_amount,
first_value(sales_amount)
over(partition by employee order by id) as first_sale,

last_value(sales_amount)
over(partition by employee order by id
rows between unbounded preceding and unbounded following) as last_sale
from sales;

# 8. dense rank no gaps

select employee,
sales_amount,
dense_rank() over(order by sales_amount desc) as dense_rnk
from sales;

# 9. cumulative average per employee

select employee,
sales_amount,
avg(sales_amount)
over(partition by employee order by id) as cumulative_avg
from sales;

# 10. highest sale per employee

select employee,
sales_amount,
max(sales_amount) over(partition by employee) as highest_sale
from sales;

# 11. sales difference from previous record

select employee,
sales_amount,
sales_amount -
lag(sales_amount) over(partition by employee order by id) as difference
from sales;

# 12. cumulative count of sales per employee

select employee,
count(*) over(partition by employee order by id) as total_count
from sales;

# 13. show if sale is above average per employee

select employee,
sales_amount,
avg(sales_amount) over(partition by employee) as avg_sale,

case
when sales_amount >
avg(sales_amount) over(partition by employee)
then 'above average'
else 'below average'
end as status
from sales;

# 14. second highest sale per employee

select * from
( select employee,
sales_amount,
dense_rank() over(partition by employee order by sales_amount desc) as rnk
from sales ) x where rnk = 2;
