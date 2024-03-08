use walmartsales;
----------------------------------------------------------------------------------------------------------------------
# Data Cleaning
desc sales;

select * from sales where gross_margin_pct is null;
select * from sales where gross_income is null;
select * from sales where rating is null;

# No Null values Found
-----------------------------------------------------------------------------------------------------------------------
#Feature Engineering
alter table sales add column time_of_day varchar(20) ;
alter table sales add column month_name varchar(10) ;
alter table sales add column day_name varchar(15);

update sales set time_of_day = (
                                 case
                                 when time between '00:00:00' and '12:00:00' then 'Morning'
                                 when time between '12:01:00' and '16:00:00' then 'Afternoon'
                                 else 'Evening'
								 end);

update sales set month_name=monthname(date);

update sales set day_name=dayname(date);

select * from sales;

--------------------------------------------------------------------------------------------------------------
#EDA

#1 all unique cities present
select distinct city from sales;
select count(distinct city) from sales;

#2count of branches in each city 
select distinct branch, city from sales;

----------------------------------------------------#PRODUCT----------------------------------------------------------
#1 number of unique product line
select distinct product_line from sales;
select count(distinct product_line) from sales;

#1b most selling product line
select product_line ,count(product_line) from sales group by product_line order by 2 desc;

#2 most common payment method
select payment , count(payment) from sales group by payment order by 2 desc;

#3total revenue by month 
select month_name ,sum(total) from sales group by month_name order by 2 desc;

#4what month had thelrgest cogs
select month_name ,sum(cogs) from sales group by month_name order by 2 desc;

#which product_line had the largest revenue
select product_line ,sum(total) from sales group by product_line order by 2 desc;

#which city has the largest revenue
select city ,sum(total) from sales group by city order by 2 desc;

#which product line has the largest VAT
select product_line ,sum(tax_pct) from sales group by product_line order by 2 desc;

#which branch sold more products then average sales
select branch, sum(quantity) from sales group by branch
having sum(quantity)>(select avg(quantity) from sales) order by 2 desc;

#what is the most common product line by gender
select gender, product_line, count(product_line) from sales
where gender='Male'
group by gender, product_line order by 3 desc limit 1;

select gender, product_line, count(product_line) from sales
where gender='Female'
group by gender, product_line order by 3 desc limit 1;

#highest purchaser by quantity and gender
select gender,count(quantity) from sales
group by gender order by 2 desc;

#highest purchaser by revenue and gender
select gender,sum(total) from sales
group by gender order by 2 desc;

#Average rating for each product line
select product_line, round(avg(rating),2) avg_rating 
from sales group by product_line
order by 2 desc;

-----------------------------------------------------------------------------------------------------------
#Sales Analysis

#1 number of sales made each timea day per weekday
select day_name,time_of_day, count(invoice_id) from sales group by day_name,time_of_day
order by 3 desc;

#2 which o thecustoer types brings themost sale
select customer_type, count(invoice_id) from sales group by
customer_type order by 2 desc;

#3 largets vat city
select city, sum(tax_pct) from sales
group by city order by 2 desc;

#4 which customer type pays more in vat
select customer_type, sum(tax_pct) from sales
group by customer_type order by 2 desc;

----------------------------------------------------------------------------------------------------------------
#Customer

#1 unique cx type
select distinct customer_type from sales;

#2how many payment methods are there
select distinct payment from sales;

#3 what is the most common customer type
select customer_type, count(invoice_id) from sales 
group by customer_type order by 2 desc
limit 1;

#4 which customer type buys the most
select customer_type, sum(total) from sales 
group by customer_type order by 2 desc
limit 1;

#5 what is the most common gender 
select gender , count(invoice_id) from sales
group by gender order by 2 desc;

#6 gender distribution per branch
select branch , gender , count(gender) as distribution
from sales group by branch,gender;

#7 which time of day customer gives moat rating
select time_of_day, count(rating) from sales
group by time_of_day;

#8 which day of the week has the best avg rating
select day_name , avg(rating) from sales
group by day_name order by 2 desc limit 1;

#8 which day of the week has the best avg rating per branch 
select branch,  day_name , avg(rating) from sales
group by branch, day_name order by 3 desc limit 3;
