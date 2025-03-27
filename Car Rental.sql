CREATE DATABASE CarRental;

USE CarRental;

--Create Table
 CREATE TABLE Vehicle (
     vehicleID INT PRIMARY KEY,
     make VARCHAR(50),
     model VARCHAR(50),
     year INT,
     dailyRate DECIMAL(10,2),
     status VARCHAR(20) CHECK (status IN ('available', 'notAvailable')),
     passengerCapacity INT,
     engineCapacity INT
 );
 
 CREATE TABLE Customer (
     customerID INT PRIMARY KEY,
     firstName VARCHAR(50),
     lastName VARCHAR(50),
     email VARCHAR(100) UNIQUE,
     phoneNumber VARCHAR(20) UNIQUE
 );
 
 CREATE TABLE Lease (
     leaseID INT PRIMARY KEY,
     vehicleID INT,
     customerID INT,
     startDate DATE,
     endDate DATE,
     leaseType VARCHAR(20) CHECK (leaseType IN ('Daily', 'Monthly')),
     FOREIGN KEY (vehicleID) REFERENCES Vehicle(vehicleID) ON DELETE CASCADE,
     FOREIGN KEY (customerID) REFERENCES Customer(customerID) ON DELETE CASCADE
 );
 
 CREATE TABLE Payment (
     paymentID INT PRIMARY KEY,
     leaseID INT,
     transactionDate DATE,  
     amount DECIMAL(10,2),
     FOREIGN KEY (leaseID) REFERENCES Lease(leaseID) ON DELETE CASCADE
 );
 
 -- Insert Sample Data
 INSERT INTO Vehicle (vehicleID, make, model, year, dailyRate, status, passengerCapacity, engineCapacity) VALUES
 (1, 'Toyota', 'Camry', 2022, 50.00, 'available', 4, 1450),
 (2, 'Honda', 'Civic', 2023, 45.00, 'available', 7, 1500),
 (3, 'Ford', 'Focus', 2022, 48.00, 'notAvailable', 4, 1400),
 (4, 'Mercedes', 'C-Class', 2022, 58.00, 'available', 8, 2599),
 (5, 'BMW', '3 Series', 2023, 60.00, 'available', 7, 2499);
 
 INSERT INTO Customer (customerID, firstName, lastName, email, phoneNumber) VALUES
 (1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555'),
 (2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567');
 
 INSERT INTO Lease (leaseID, vehicleID, customerID, startDate, endDate, leaseType) VALUES
 (1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),
 (2, 2, 2, '2023-02-15', '2023-02-28', 'Monthly');
 
 INSERT INTO Payment (paymentID, leaseID, transactionDate, amount) VALUES
 (1, 1, '2023-01-03', 200.00),
 (2, 2, '2023-02-20', 1000.00);
 
 -- Verify Data Exists Before Running Queries
 SELECT * FROM Vehicle;
 SELECT * FROM Customer;
 SELECT * FROM Lease;
 SELECT * FROM Payment;
 

 -- 1. Update the daily rate for Mercedes to 68 (Check if it exists first)
 UPDATE Vehicle SET dailyRate = 68.00 WHERE make = 'Mercedes';

 -- 2. Delete a customer and all associated leases/payments (Check customer exists first)
 SELECT * FROM Customer WHERE customerID = 1; 
 DELETE FROM Customer WHERE customerID = 1;

-- 3. Rename "paymentDate" to "transactionDate"
ALTER TABLE Payment ADD transactionDate DATE;
UPDATE Payment SET transactionDate = paymentDate;
ALTER TABLE Payment DROP COLUMN paymentDate;

-- 4.Find a customer by email
 SELECT * FROM Customer WHERE email = 'janesmith@example.com';

--5.Get active leases for a specific customer
SELECT * FROM Lease WHERE customerID = 2;

--6.Find all payments made by a customer with a specific phone number
 SELECT p.* FROM Payment p
 JOIN Lease l ON p.leaseID = l.leaseID
 JOIN Customer c ON l.customerID = c.customerID
 WHERE c.phoneNumber = '555-123-4567';

--7.Calculate the average daily rate of all available cars
 SELECT AVG(dailyRate) AS avgDailyRate FROM Vehicle WHERE status = 'available';
 
--8.Find the car with the highest daily rate
 SELECT TOP 1 * FROM Vehicle ORDER BY dailyRate DESC;

--9.Retrieve all cars leased by a specific customer
 SELECT v.* FROM Vehicle v
 JOIN Lease l ON v.vehicleID = l.vehicleID
 WHERE l.customerID = 2;
 
 -- 10. Find the details of the most recent lease
 SELECT TOP 1 * FROM Lease ORDER BY endDate DESC;
 
 -- 11. List all payments made in 2023
 SELECT * FROM Payment WHERE YEAR(transactionDate) = 2023;
 
 -- 12. Retrieve customers who have not made any payments
 SELECT c.* FROM Customer c
 LEFT JOIN Lease l ON c.customerID = l.customerID
 LEFT JOIN Payment p ON l.leaseID = p.leaseID
 WHERE p.paymentID IS NULL;
 
 -- 13. Retrieve Car Details and Their Total Payments
 SELECT v.make, v.model, SUM(p.amount) AS totalPayments
 FROM Vehicle v
 JOIN Lease l ON v.vehicleID = l.vehicleID
 JOIN Payment p ON l.leaseID = p.leaseID
 GROUP BY v.make, v.model;
 
 -- 14. Calculate Total Payments for Each Customer
 SELECT c.firstName, c.lastName, SUM(p.amount) AS totalPayments
 FROM Customer c
 JOIN Lease l ON c.customerID = l.customerID
 JOIN Payment p ON l.leaseID = p.leaseID
 GROUP BY c.firstName, c.lastName;
 
 -- 15. List Car Details for Each Lease
 SELECT l.leaseID, v.make, v.model, l.startDate, l.endDate, l.leaseType
 FROM Lease l
 JOIN Vehicle v ON l.vehicleID = v.vehicleID;
 
 -- 16. Retrieve Details of Active Leases with Customer and Car Information
 SELECT l.leaseID, c.firstName, c.lastName, v.make, v.model, l.startDate, l.endDate
 FROM Lease l
 JOIN Customer c ON l.customerID = c.customerID
 JOIN Vehicle v ON l.vehicleID = v.vehicleID
 WHERE l.endDate >= GETDATE();
 
 -- 17. Find the Customer Who Has Spent the Most on Leases
 SELECT TOP 1 c.firstName, c.lastName, SUM(p.amount) AS totalSpent
 FROM Customer c
 JOIN Lease l ON c.customerID = l.customerID
 JOIN Payment p ON l.leaseID = p.leaseID
 GROUP BY c.firstName, c.lastName
 ORDER BY totalSpent DESC;
 
 -- 18. List All Cars with Their Current Lease Information
 SELECT v.make, v.model, l.startDate, l.endDate, c.firstName, c.lastName
 FROM Vehicle v
 LEFT JOIN Lease l ON v.vehicleID = l.vehicleID
 LEFT JOIN Customer c ON l.customerID = c.customerID