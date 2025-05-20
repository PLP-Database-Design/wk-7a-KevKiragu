WITH ProductSplit AS (
    SELECT
        OrderID,
        CustomerName,
        TRIM(UNNEST(STRING_TO_ARRAY(Products, ','))) AS Product 
    FROM
        ProductDetail
)
SELECT
    OrderID,
    CustomerName,
    Product
FROM
    ProductSplit;
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1), 
    CustomerName VARCHAR(255)
);

INSERT INTO Customers (CustomerName)
SELECT DISTINCT CustomerName FROM OrderDetails;
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders (OrderID, CustomerID)
SELECT DISTINCT od.OrderID, c.CustomerID
FROM OrderDetails od
JOIN Customers c ON od.CustomerName = c.CustomerName;
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1), 
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT
    OrderID,
    Product,
    Quantity
FROM
    OrderDetails;
