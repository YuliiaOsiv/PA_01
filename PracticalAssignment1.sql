CREATE DATABASE HOMEWORK;
USE HOMEWORK;

CREATE TABLE Customers (
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	city VARCHAR(50)
);

CREATE TABLE Orders(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
	order_date DATE,
	customer_id INT,
	amount INT,
	FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Products(
	product_id INT PRIMARY KEY AUTO_INCREMENT,
	product_name VARCHAR(50),
	category VARCHAR(50),
	price INT
);

CREATE TABLE Order_details(
	detail_id INT PRIMARY KEY AUTO_INCREMENT,
	order_id INT,
	product_id INT,
	quantity INT,
	FOREIGN KEY (order_id) REFERENCES Orders(order_id),
	FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Suppliers(
	supplier_id INT PRIMARY KEY AUTO_INCREMENT,
	supplier_name VARCHAR(50),
	contact VARCHAR(50),
	product_id INT,
	FOREIGN KEY (product_id) REFERENCES Products(product_id)
);



INSERT INTO Customers (customer_id, first_name, last_name, city)
VALUES 
(1, 'Joe', 'Doe', 'New York'),
(2, 'Jane', 'Smith', 'Chicago'),
(3, 'Alice', 'Johnson', 'Los Angeles'),
(4, 'Bob', 'Brown', 'Houston'),
(5, 'Carol', 'Davis', 'Miami');

INSERT INTO Orders(order_id, order_date, customer_id, amount)
VALUES
(101, '2024-01-15', 1, 250),
(102, '2024-02-20', 2, 300),
(103, '2024-03-10', 4, 150),
(104, '2024-04-05', 5, 400),
(105, '2024-05-18', 1, 350);

INSERT INTO Products (product_id, product_name, category, price)
VALUES 
(201, 'Laptop', 'Electronics', 1000),
(202, 'Smartphone', 'Electronics', 700),
(203, 'Desk Chair', 'Furniture', 150),
(204, 'Coffee Table', 'Furniture', 200),
(205, 'Headphones', 'Electronics', 100);


INSERT INTO Order_details (detail_id, order_id, product_id, quantity)
VALUES
(301, 101, 201, 1),
(302, 101, 205, 2),
(303, 102, 202, 1),
(304, 103, 203, 4),
(305, 104, 204, 1);

INSERT INTO Suppliers (supplier_id, supplier_name, contact, product_id)
VALUES
(401, 'TechCorp', 'John Doe', 201),
(402, 'MobileHub', 'Jane Roe', 202), 
(403, 'FurniCo', 'Alice Lee', 203),
(404, 'DecorHome', 'Bob King', 204),
(405, 'SoundWave', 'Carol Hill', 205);




WITH sales_data AS (
    SELECT c.customer_id, c.city, o.order_id,
        o.order_date, p.product_id, p.product_name,
        p.category, AVG(p.price) AS avg_price, 
        SUM(od.quantity) AS total_quantity,
        s.supplier_id, s.supplier_name, s.contact
    FROM Customers AS c
    LEFT JOIN Orders AS o ON c.customer_id = o.customer_id
    LEFT JOIN Order_details AS od ON o.order_id = od.order_id
    LEFT JOIN Products AS p ON od.product_id = p.product_id
    LEFT JOIN Suppliers AS s ON p.product_id = s.product_id
    WHERE p.category = "Electronics"
    GROUP BY c.customer_id, c.city, o.order_id, 
	        o.order_date, p.product_id, p.product_name,
	        p.category, s.supplier_id, s.supplier_name, s.contact
        
    UNION ALL
    
    SELECT 
        c.customer_id, c.city, o.order_id,
        o.order_date, p.product_id, p.product_name,
        p.category, AVG(p.price) AS avg_price, 
        SUM(od.quantity) AS total_quantity,
        s.supplier_id, s.supplier_name, s.contact
    FROM Customers AS c
    LEFT JOIN Orders AS o ON c.customer_id = o.customer_id
    LEFT JOIN Order_details AS od ON o.order_id = od.order_id
    LEFT JOIN Products AS p ON od.product_id = p.product_id
    LEFT JOIN Suppliers AS s ON p.product_id = s.product_id
    WHERE p.category = "Furniture"
    GROUP BY c.customer_id, c.city, o.order_id, 
	        o.order_date, p.product_id, p.product_name,
	        p.category, s.supplier_id, s.supplier_name, s.contact
)
SELECT *
FROM sales_data
ORDER BY order_date DESC;

