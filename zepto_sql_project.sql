drop table zepto;
CREATE TABLE Zepto (
    sku_id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(120) NOT NULL,
    mrp DECIMAL(8,2),
    discountPercent DECIMAL(5,2),
    availableQuantity INT,
    discountedSellingPrice DECIMAL(8,2),
    weightInGms INT,
    outOfStock boolean,
    quantity INT
);
-- check view
select* from zepto limit 10;
-- count of rows
select count(*) from zepto;
select* from zepto
where name is null
or category is null
or mrp is null
or discountPercent is null
or availableQuantity is null
or discountedSellingPrice is null
or weightInGms is null
or outOfStock is null
or quantity is null;
-- different product categories
select distinct category 
from zepto
order by category;
-- count of distinct items
select count(distinct category) 
from zepto
order by category;
-- products in stock vs products out of stock
select outOfStock, count(sku_id)
from zepto group by outOfStock;
-- product name present multiple times
select name, count(sku_id) as "Number of sku"
from zepto group by name
having count(sku_id)>1
order by count(sku_id) desc;
-- data cleaning
-- product with mrp zero
select*from zepto 
where mrp=0 or discountedSellingPrice=0;

delete from zepto where mrp=0;
-- convert paisa to rupees
update zepto 
set mrp=mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;
 
select mrp, discountedSellingPrice from zepto;
-- Q1 	Find the top 10 best-value products based on the discount percentage
select distinct name, mrp, discountPercent 
from zepto
order by discountPercent desc limit 10;
-- Q2 What the Products with High MRP but Out Of Stock
select distinct name, mrp 
from zepto
where outOfStock=1 and mrp>300
order by mrp desc;
--	Q3 Calculate estimated revenue for each category
select category,
sum(discountedSellingPrice * availableQuantity) as total_revenue
from zepto 
group by category
order by total_revenue;
-- Find all products where mrp is greater than 500 and discount is less than 10%
select distinct name ,mrp, discountPercent
from zepto
where mrp>500 and discountPercent<10
order by mrp desc, discountPercent desc;
-- Q5 Identify the top 5 categories offering the highest average discount percentage
select category, round(avg(discountPercent),2) as avg_discount
from zepto group by category
order by avg_discount desc
limit 5;
-- Q6 Find the Price per Gram for products above 100g and sort by best value
select distinct name, weightInGms , discountedSellingPrice, round((discountedSellingPrice/weightInGms),2) as Price_per_gram
from zepto
where weightInGms>=100
order by Price_per_gram;
-- Q7 Group the products into categories like low, medium, bulk
select distinct name, weightInGms,
case when weightInGms<1000 then 'Low'
when weightInGms<5000 then 'Medium'
else 'Bulk'
end as Weight_Category from zepto;
-- Q8 What is the Total Inventory Weight per Category
select category,sum(weightInGms*availableQuantity) as Total_weight
from zepto group by category
order by total_weight;