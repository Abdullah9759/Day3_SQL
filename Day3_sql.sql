-- Customers table
CREATE TABLE Customers (
  customer_id INT PRIMARY KEY,
  name VARCHAR(50),
  city VARCHAR(50)
);

-- Orders table
CREATE TABLE Orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  amount DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Products table
CREATE TABLE Products (
  product_id INT PRIMARY KEY,
  name VARCHAR(50),
  price DECIMAL(10,2)
);

-- Sample Data
INSERT INTO Customers VALUES
(1, 'Alice', 'Delhi'),
(2, 'Bob', 'Mumbai'),
(3, 'Charlie', 'Bangalore');

INSERT INTO Orders VALUES
(101, 1, '2025-01-01', 500.00),
(102, 1, '2025-01-05', 200.00),
(103, 2, '2025-01-07', 300.00);

INSERT INTO Products VALUES
(201, 'Laptop', 700.00),
(202, 'Mouse', 20.00),
(203, 'Keyboard', 30.00);

-- Total amount spent by each customer, highest first
SELECT customer_id, SUM(amount) AS total_spent
FROM Orders
GROUP BY customer_id
ORDER BY total_spent DESC;

-- INNER JOIN: Customer names with their orders
SELECT c.name, o.order_id, o.amount
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id;

-- LEFT JOIN: All customers, even those with no orders
SELECT c.name, o.order_id
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id;

-- RIGHT JOIN: All orders, even if the customer is missing
SELECT c.name, o.order_id
FROM Customers c
RIGHT JOIN Orders o ON c.customer_id = o.customer_id;

-- Customers who spent more than average order amount
SELECT name
FROM Customers
WHERE customer_id IN (
  SELECT customer_id
  FROM Orders
  GROUP BY customer_id
  HAVING SUM(amount) > (
    SELECT AVG(amount) FROM Orders
  )
);

-- Company-wide stats
SELECT
  SUM(amount) AS total_sales,
  AVG(amount) AS average_order_value
FROM Orders;

-- View to show spending per customer
CREATE VIEW CustomerSummary AS
SELECT c.name, SUM(o.amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.name;

-- Use the view
SELECT * FROM CustomerSummary WHERE total_spent > 400;


-- Add indexes to speed up queries
CREATE INDEX idx_orders_customer ON Orders(customer_id);
CREATE INDEX idx_orders_date ON Orders(order_date);
