create database amazon;
use amazon;

#--- primary keys and foreign keys

ALTER TABLE customers 
MODIFY CustomerID VARCHAR(50) NOT NULL;

ALTER TABLE customers 
ADD PRIMARY KEY (CustomerID);

ALTER TABLE suppliers 
MODIFY SupplierID VARCHAR(50) NOT NULL;

ALTER TABLE suppliers 
ADD PRIMARY KEY (SupplierID);

ALTER TABLE reviews 
MODIFY ReviewID VARCHAR(36) NOT NULL,
MODIFY ProductID VARCHAR(36),
MODIFY CustomerID VARCHAR(36);

ALTER TABLE products
ADD PRIMARY KEY (ProductID);

ALTER TABLE reviews
MODIFY COLUMN ProductID VARCHAR(36),
ADD CONSTRAINT fk_reviews_product
FOREIGN KEY (ProductID) REFERENCES products(ProductID);

ALTER TABLE orders 
MODIFY orderid VARCHAR(36) NOT NULL,
MODIFY customerID VARCHAR(36);

ALTER TABLE Orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

DROP TABLE IF EXISTS orderdetails;
 
ALTER TABLE order_details
MODIFY OrderID VARCHAR(36),
MODIFY ProductID VARCHAR(36);
 

SELECT OrderID, ProductID, COUNT(*) AS cnt
FROM order_details
GROUP BY OrderID, ProductID
HAVING cnt > 1;

USE amazon;

SELECT OrderID, ProductID, COUNT(*) AS cnt
FROM order_details
GROUP BY OrderID, ProductID
HAVING cnt > 1;
 ALTER TABLE order_details
ADD PRIMARY KEY (OrderID, ProductID);

ALTER TABLE order_details
ADD CONSTRAINT fk_orderdetails_orders
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID),
ADD CONSTRAINT fk_orderdetails_products
    FOREIGN KEY (ProductID) REFERENCES products(ProductID);

# ------Task 3
# Retrieve all customers from a specific city.
# Fetch all products under the "Fruits" category.

select*from products;

SELECT *
FROM Customers
WHERE City = 'Christopherland';

SELECT *
FROM Products
WHERE Category = 'Fruits';


SELECT p.ProductID,
       p.ProductName,
       p.PricePerUnit,
       p.StockQuantity,
       c.CategoryName
FROM products p
JOIN categories c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Fruits';


#------Data Definition Language (DDL) and Constraints task 4
#CustomerID as the primary key.
#Ensure Age cannot be null and must be greater than 18.
#Add a unique constraint for Name.

CREATE TABLE Cust
   (CustomerID VARCHAR(36) PRIMARY KEY,     
    Name VARCHAR(100) UNIQUE,                   
    Age INT NOT NULL CHECK (Age > 18),           
    City VARCHAR(50)
);
select * from cust;

INSERT INTO Cust (CustomerID, Name, Age, City) VALUES
('4331c5fa-0c04-4383-82b1-e30894c79faa', 'Larry Gallagher', 54, 'Patelberg'),
('b10b93c8-d812-4bc0-8016-7a637bab554d', 'Thomas Moore', 53, 'Lake Jeffreyfurt'),
('6c3cbc77-3ea6-4bb0-b038-10bad28721e9', 'Brandon Barton', 36, 'Hoffmanborough'),
('d2eb2172-0349-4a75-8970-e5993e8fd9ef', 'Drew Stewart', 58, 'North Kyle'),
('e7bb1a14-fd73-44ae-9323-4f444c5810a5', 'William Mitchell', 42, 'South Kimberlyburgh'),
('0c182871-78e7-4f6a-a877-804f431afe1e', 'Kevin Huynh', 33, 'North Daniel'),
('d3df1ad0-1fa0-4bd3-9ea0-59d36db80e4f', 'William Martinez', 46, 'West Paula'),
('e5eb8fc8-8b60-45ce-9cb5-756e3e217fcc', 'Priscilla Rollins', 58, 'Gibsonchester'),
('8530914e-b31d-4774-a9bb-a153e6e29136', 'Joel Robinson', 45, 'Nathanielfort');

#------Data Manipulation Language (DML)
# Task 5
#Insert 3 new rows into the Products table using INSERT statements.

select*from products;

INSERT INTO Products (ProductID, ProductName, Category,subcategory, PriceperUnit, StockQuantity, SupplierID)
 VALUES
('p101', 'Apple', 'Fruits', 'Sub-Fruits-4', 120, 500, 's001'),
('p102', 'Orange', 'Fruits', 'Sub-Fruits-4', 80, 300, 's002'),
('p103', 'Carrot', 'Vegetables','Sub-Vegetables-1', 50, 200, 's003');

#Task 6
#Update the stock quantity of a product where ProductID matches a specific ID

UPDATE Products
SET StockQuantity = 600
WHERE ProductID = 'p101';

#Task 7
# Delete a supplier from the Suppliers table where their city matches a specific value.

select * from suppliers;

DELETE FROM Suppliers
WHERE city = 'Allenfurt';

      #-----SQL Constraints and Operators TASK 8
      #Add a CHECK constraint to ensure that ratings in the Reviews table are between 1 and 5.
      #Add a DEFAULT constraint for the PrimeMember column in the Customers table (default value: "No").

select*from reviews;
      
ALTER TABLE Reviews 
ADD CONSTRAINT chk_rating CHECK (Rating BETWEEN 1 AND 5);


select * from customers;

ALTER TABLE Customers
MODIFY COLUMN PrimeMember VARCHAR(10) DEFAULT 'No';

#-----Clauses and Aggregations 
#WHERE clause to find orders placed after 2024-01-01.
#HAVING clause to list products with average ratings greater than 4.
#GROUP BY and ORDER BY clauses to rank products by total sales.

 select * from orders;
 
SELECT OrderID, CustomerID, OrderDate, OrderAmount
FROM Orders
WHERE OrderDate > '2024-01-01';

SELECT ProductID, AVG(Rating) AS AvgRating
FROM Reviews
GROUP BY ProductID
HAVING AVG(Rating) > 4;

select*from order_details;

SELECT ProductID, 
       SUM(Quantity * UnitPrice) AS TotalSales
FROM order_details
GROUP BY ProductID
ORDER BY TotalSales DESC;

#----Identifying High-Value Customers 
#Calculate each customer's total spending.
#Rank customers based on their spending.
#Identify customers who have spent more than ₹5,000.


SELECT o.CustomerID,
       SUM(od.Quantity * od.UnitPrice - od.Discount) AS TotalSpending
FROM orders o
JOIN order_details od 
    ON o.OrderID = od.OrderID
GROUP BY o.CustomerID;

SELECT o.CustomerID,
       SUM(od.Quantity * od.UnitPrice - od.Discount) AS TotalSpending
FROM orders o
JOIN order_details od 
    ON o.OrderID = od.OrderID
GROUP BY o.CustomerID
ORDER BY TotalSpending DESC;

SELECT o.CustomerID,
       SUM(od.Quantity * od.UnitPrice - od.Discount) AS TotalSpending
FROM orders o
JOIN order_details od 
    ON o.OrderID = od.OrderID
GROUP BY o.CustomerID
HAVING TotalSpending > 5000
ORDER BY TotalSpending DESC;

#---Complex Aggregations and Joins 
#Task 11: Use SQL to:
#Join the Orders and OrderDetails tables to calculate total revenue per order.
#Identify customers who placed the most orders in a specific time period.
#Find the supplier with the most products in stock.


SELECT o.OrderID,
       SUM(od.Quantity * od.UnitPrice - od.Discount) AS TotalRevenue
FROM orders o
JOIN order_details od 
    ON o.OrderID = od.OrderID
GROUP BY o.OrderID
ORDER BY TotalRevenue DESC;

SELECT o.CustomerID,
       COUNT(o.OrderID) AS TotalOrders
FROM orders o
WHERE o.OrderDate BETWEEN '2025-01-01' AND '2025-03-31'
GROUP BY o.CustomerID
ORDER BY TotalOrders DESC
LIMIT 5;

SELECT s.SupplierID, s.SupplierName,
       COALESCE(SUM(p.StockQuantity), 0) AS TotalStock
FROM suppliers s
LEFT JOIN products p 
    ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName
ORDER BY TotalStock DESC
LIMIT 1;

#------------Normalization 
#Task 12: Normalize the Products table to 3NF:
#Separate product categories and subcategories into a new table.
#Create foreign keys to maintain relationships.


 select * from categories;
 
CREATE TABLE categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) UNIQUE
);
INSERT INTO categories (CategoryName)
SELECT DISTINCT Category
FROM products;

UPDATE products p
JOIN categories c ON p.Category = c.CategoryName
SET p.CategoryID = c.CategoryID;

select* from products;

ALTER TABLE products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (CategoryID) REFERENCES categories(CategoryID);

ALTER TABLE products
DROP COLUMN Category;

CREATE TABLE subcategories (
    SubCategoryID INT PRIMARY KEY AUTO_INCREMENT,
    SubCategoryName VARCHAR(100),
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES categories(CategoryID)
);

INSERT INTO subcategories (SubCategoryName, CategoryID)
SELECT DISTINCT p.SubCategory, p.CategoryID
FROM products p;

ALTER TABLE products
ADD SubCategoryID INT;

UPDATE products p
JOIN subcategories s 
  ON p.SubCategory = s.SubCategoryName 
 AND p.CategoryID = s.CategoryID
SET p.SubCategoryID = s.SubCategoryID;

ALTER TABLE products
ADD CONSTRAINT fk_products_subcategory 
FOREIGN KEY (SubCategoryID) REFERENCES subcategories(SubCategoryID);

ALTER TABLE products
DROP COLUMN SubCategory;

#-----Subqueries and Nested Queries 
#---Task 13: Write a subquery to: Identify the top 3 products based on sales revenue.Find customers who haven’t placed any orders yet.

SELECT ProductID, ProductName, TotalRevenue
FROM (
    SELECT od.ProductID, p.ProductName,
           SUM(od.Quantity * od.UnitPrice) AS TotalRevenue
    FROM order_details od
    JOIN products p ON od.ProductID = p.ProductID
    GROUP BY od.ProductID, p.ProductName
    ORDER BY TotalRevenue DESC
    LIMIT 3
) AS TopProducts;

select*from customers;

SELECT CustomerID, Name
FROM customers
WHERE CustomerID NOT IN (
    SELECT DISTINCT CustomerID
    FROM orders
);

#------Real-World Analysis 
#--Task 14: Provide actionable insights:
#Which cities have the highest concentration of Prime members?
#What are the top 3 most frequently ordered categories?

SELECT City, COUNT(*) AS PrimeCount
FROM customers
WHERE PrimeMember = 'Yes'
GROUP BY City
ORDER BY PrimeCount DESC
LIMIT 5;   -- top 5 cities

SELECT p.CategoryID, c.CategoryName, COUNT(*) AS OrderFrequency
FROM order_details od
JOIN products p ON od.ProductID = p.ProductID
JOIN categories c ON p.CategoryID = c.CategoryID
GROUP BY p.CategoryID, c.CategoryName
ORDER BY OrderFrequency DESC
LIMIT 3;

use amazon;
#----------------------------------------------------------------------------------------#









