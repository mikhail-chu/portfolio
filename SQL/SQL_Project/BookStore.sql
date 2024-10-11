create database BestBookStore_1;
use BestBookStore_1;

-- Создаем таблицу Address_Publisher
CREATE TABLE Address_Publisher (
    Address_ID INT NOT NULL PRIMARY KEY,
    City NVARCHAR(50),
    Street NVARCHAR(50),
    Building NVARCHAR(10)
);

-- Вставляем данные в Address_Publisher
INSERT INTO Address_Publisher (Address_ID, City, Street, Building)
VALUES
    (1, 'Kuala Lumpur', 'Jalan Bukit Bintang', '1A'),
    (2, 'Kuala Lumpur', 'Jalan Ampang', '25B'),
    (3, 'Kuala Lumpur', 'Jalan Raja Chulan', '7C'),
    (4, 'Kuala Lumpur', 'Jalan Sultan Ismail', '14D'),
    (5, 'Kuala Lumpur', 'Jalan P. Ramlee', '3E'),
    (6, 'Kuala Lumpur', 'Jalan Tun Razak', '12F'),
    (7, 'Kuala Lumpur', 'Jalan Imbi', '9G');

-- Создаем таблицу Publishers
CREATE TABLE Publishers (
    Publisher_ID INT NOT NULL PRIMARY KEY,
    Name NVARCHAR(50),
    Phone nvarchar(20),
    Email NVARCHAR(50),
    Address_ID INT FOREIGN KEY REFERENCES Address_Publisher(Address_ID)
);

-- Вставляем данные в Publishers
INSERT INTO Publishers (Publisher_ID, Name, Phone, Email, Address_ID)
VALUES
    (1, 'ABC Publications', '123456789', 'abc@example.com', 1),
    (2, 'XYZ Books', '987654321', 'xyz@example.com', 2),
    (3, 'Book Haven', '555111222', 'bookhaven@example.com', 3),
    (4, 'Literary World', '111222333', 'literaryworld@example.com', 4),
    (5, 'Tech Press', '777888999', 'techpress@example.com', 5),
    (6, 'Nature Books', '444555666', 'naturebooks@example.com', 6),
    (7, 'Global Publishing', '666777888', 'globalpub@example.com', 7);

-- Создаем таблицу Books
CREATE TABLE Books (
    Book_ID int Not Null Primary Key,
    Name  nvarchar(50),
    Date_publication date,
    Stock int,
    Price decimal(10,2)
);

-- Вставляем данные в Books
INSERT INTO Books (Book_ID, Name, Date_publication, Stock, Price)
VALUES
    (1, 'The Art of Programming', '2022-01-15', 50, 29.99),
    (2, 'History Unfolded', '2022-02-20', 30, 19.99),
    (3, 'Into the Wilderness', '2022-03-10', 45, 24.99),
    (4, 'Tech Innovations', '2022-04-05', 60, 34.99),
    (5, 'Natural Wonders', '2022-05-12', 25, 14.99),
    (6, 'Cityscapes', '2022-06-18', 40, 27.99),
    (7, 'Mystical Realms', '2022-07-22', 55, 39.99);

CREATE TABLE Genres (
    Genre_ID INT PRIMARY KEY,
    Genre_Name NVARCHAR(50) NOT NULL
);
INSERT INTO Genres (Genre_ID, Genre_Name)
VALUES
    (1, 'Fiction'),
    (2, 'Mystery'),
    (3, 'Science Fiction'),
    (4, 'Non-Fiction'),
    (5, 'Fantasy');

CREATE TABLE Book_Genres (
    Book_ID INT,
    Genre_ID INT,
    PRIMARY KEY (Book_ID, Genre_ID),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID),
    FOREIGN KEY (Genre_ID) REFERENCES Genres(Genre_ID)
);
INSERT INTO Book_Genres (Book_ID, Genre_ID)
VALUES
    (1, 1),  -- The Art of Programming - Fiction
    (2, 1),  -- History Unfolded - Fiction
    (3, 1),  -- Into the Wilderness - Fiction
    (4, 3),  -- Tech Innovations - Science Fiction
    (5, 4),  -- Natural Wonders - Non-Fiction
    (6, 5),  -- Cityscapes - Fantasy
    (7, 1);  -- Mystical Realms - Fiction




-- Создаем таблицу Publisher_Books
CREATE TABLE Publisher_Books (
    Publisher_ID INT,
    Book_ID INT,
    PRIMARY KEY (Publisher_ID, Book_ID),
    FOREIGN KEY (Publisher_ID) REFERENCES Publishers(Publisher_ID),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID)
);

-- Вставляем данные в Publisher_Books
INSERT INTO Publisher_Books (Publisher_ID, Book_ID)
VALUES
    (1, 1),
	(1, 2),
	(1, 3),
	(1, 4),
	(1, 5),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7);

-- Создаем таблицу Authors
CREATE TABLE Authors (
    Author_ID int not null Primary Key,
    Name nvarchar(50),
    Phone nvarchar(20),
    Email nvarchar(50)
);

-- Вставляем данные в Authors
INSERT INTO Authors (Author_ID, Name, Phone, Email)
VALUES
    (1, 'John Smith', '123456789', 'john.smith@example.com'),
    (2, 'Alice Johnson', '987654321', 'alice.johnson@example.com'),
    (3, 'David Brown', '555111222', 'david.brown@example.com'),
    (4, 'Emily Davis', '111222333', 'emily.davis@example.com'),
    (5, 'Michael White', '777888999', 'michael.white@example.com');

-- Создаем таблицу Author_Books
CREATE TABLE Author_Books (
    Author_ID INT,
    Book_ID INT,
    PRIMARY KEY (Author_ID, Book_ID),
    FOREIGN KEY (Author_ID) REFERENCES Authors(Author_ID),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID)
);

-- Вставляем данные в Author_Books
INSERT INTO Author_Books (Author_ID, Book_ID)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (1, 6),
    (2, 7);

-- Создаем таблицу Discounts
CREATE TABLE Discounts (
    Discount_ID int not null primary Key,
    Discount_Type nvarchar (20),
    Value int
);

-- Вставляем данные в Discounts
INSERT INTO Discounts (Discount_ID, Discount_Type, Value)
VALUES
    (1, 'Promo2022', 10),
    (2, 'HolidaySale', 15),
    (3, 'Clearance2022', 20),
    (4, 'StudentDiscount', 12),
    (5, 'SpecialEvent', 18);

-- Создаем таблицу Address_Member
CREATE TABLE Address_Member (
    Address_ID int Not Null Primary Key,
    City nvarchar(50),
    Street nvarchar(50),
    Building nvarchar(10),
    Flat nvarchar(20)
);

-- Вставляем данные в Address_Member
INSERT INTO Address_Member (Address_ID, City, Street, Building, Flat)
VALUES
    (1, 'Kuala Lumpur', 'Jalan Monorail', '2X', 'X11'),
    (2, 'Kuala Lumpur', 'Jalan Cochrane', '15Y', 'Y12'),
    (3, 'Kuala Lumpur', 'Jalan Sultan Hishamuddin', '8Z', 'Z13'),
    (4, 'Kuala Lumpur', 'Jalan Tuanku Abdul Rahman', '19W', 'W14'),
    (5, 'Kuala Lumpur', 'Jalan Kuching', '6V', 'V15'),
    (6, 'Kuala Lumpur', 'Jalan Loke Yew', '11U', 'U16'),
    (7, 'Kuala Lumpur', 'Jalan Datuk Sulaiman', '4T', 'T17'),
    (8, 'Kuala Lumpur', 'Jalan Segambut', '21S', 'S18'),
    (9, 'Kuala Lumpur', 'Jalan Kerayong', '10R', 'R19'),
    (10, 'Kuala Lumpur', 'Jalan Syed Putra', '7Q', 'Q20');

-- Создаем таблицу Members
CREATE TABLE Members (
    Member_ID int not null Primary Key,
    Name nvarchar(100),
    Phone nvarchar(20),
    Email nvarchar(50),
    Registration_Date date,
    Address_ID INT FOREIGN KEY REFERENCES Address_Member(Address_ID),
    Discount_ID INT FOREIGN KEY REFERENCES Discounts(Discount_ID)
);

-- Вставляем данные в Members
INSERT INTO Members (Member_ID, Name, Phone, Email, Registration_Date, Address_ID, Discount_ID)
VALUES
    (1, 'Alice Johnson', '123456789', 'alice.johnson@example.com', '2022-01-01', 1, 1),
    (2, 'Bob Miller', '987654321', 'bob.miller@example.com', '2022-02-15', 2, 2),
    (3, 'Charlie Brown', '555111222', 'charlie.brown@example.com', '2022-03-20', 3, 3),
    (4, 'David White', '111222333', 'david.white@example.com', '2022-04-05', 4, 4),
    (5, 'Emily Davis', '777888999', 'emily.davis@example.com', '2022-05-10', 5, 5),
    (6, 'Frank Johnson', '444555666', 'frank.johnson@example.com', '2022-06-18', 6, 1),
    (7, 'Grace Smith', '666777888', 'grace.smith@example.com', '2022-07-22', 7, 2),
    (8, 'Henry Lee', '222333444', 'henry.lee@example.com', '2022-08-30', 8, 3),
    (9, 'Ivy Wong', '888999000', 'ivy.wong@example.com', '2022-09-15', 9, 4),
    (10, 'Jack Taylor', '333444555', 'jack.taylor@example.com', '2022-10-05', 10, 5);

-- Создаем таблицу Order_Stock
CREATE TABLE Order_Stock (
    Order_Stock_ID int not null Primary Key,
    Quantity int,
    Order_Date date,
    Discount_ID INT FOREIGN KEY REFERENCES Discounts(Discount_ID),
    Book_ID INT FOREIGN KEY REFERENCES Books(Book_ID)
);

-- Вставляем данные в Order_Stock
INSERT INTO Order_Stock (Order_Stock_ID, Quantity, Order_Date, Discount_ID, Book_ID)
VALUES
    (1, 2, '2022-01-15', 1, 1),
    (2, 1, '2022-02-20', 2, 2),
    (3, 3, '2022-03-25', 3, 3),
    (4, 1, '2022-04-10', 4, 4),
    (5, 2, '2022-05-12', 5, 5),
    (6, 1, '2022-06-18', 1, 6),
    (7, 4, '2022-07-22', 2, 7);

-- Создаем таблицу Reviews
CREATE TABLE Reviews (
    Review_ID int not null Primary Key,
    Review nvarchar(100),
    Rating decimal,
    Order_Date date,
    Member_ID INT FOREIGN KEY REFERENCES Members(Member_ID),
    Book_ID INT FOREIGN KEY REFERENCES Books(Book_ID)
);

-- Вставляем данные в Reviews
INSERT INTO Reviews (Review_ID, Review, Rating, Order_Date, Member_ID, Book_ID)
VALUES
    (1, 'Great book!', 4.5, '2022-01-15', 1, 1),
    (2, 'Interesting plot', 4.0, '2022-02-20', 2, 2),
    (3, 'Well-written', 4.2, '2022-03-25', 3, 3),
    (4, 'Enjoyable read', 4.8, '2022-04-10', 4, 4),
    (5, 'Highly recommended', 4.7, '2022-05-12', 5, 5),
    (6, 'Captivating', 4.6, '2022-06-18', 6, 6),
    (7, 'Must-read', 4.9, '2022-07-22', 7, 7);

-- Создаем таблицу Carts
CREATE TABLE Carts (
    Cart_ID int not null Primary Key,
    Quantity int,
    Member_ID INT FOREIGN KEY REFERENCES Members(Member_ID),
    Book_ID INT FOREIGN KEY REFERENCES Books(Book_ID)
);

-- Вставляем данные в Carts
INSERT INTO Carts (Cart_ID, Quantity, Member_ID, Book_ID)
VALUES
    (1, 2, 1, 1),
    (2, 1, 2, 2),
    (3, 3, 3, 3),
    (4, 1, 4, 4),
    (5, 2, 5, 5),
    (6, 1, 6, 6),
    (7, 4, 7, 7);

CREATE TABLE Cart_Items (
    Cart_Item_ID int not null Primary Key,
    Cart_ID INT FOREIGN KEY REFERENCES Carts(Cart_ID),
    Book_ID INT FOREIGN KEY REFERENCES Books(Book_ID),
    Quantity int,
    CONSTRAINT UC_Cart_Book UNIQUE (Cart_ID, Book_ID) -- Уникальность пары Cart_ID и Book_ID
);

-- Вставляем данные в Cart_Items
INSERT INTO Cart_Items (Cart_Item_ID, Cart_ID, Book_ID, Quantity)
VALUES
    (1, 1, 1, 2),
    (2, 2, 2, 1),
    (3, 3, 3, 3),
    (4, 4, 4, 1),
    (5, 5, 5, 2),
    (6, 6, 6, 1),
    (7, 7, 7, 4);

-- Создаем таблицу Payments
CREATE TABLE Payments (
    Payment_ID int not null Primary Key,
    Amount_Paid decimal,
    Method nvarchar(20),
    Payment_Date date,
    Cart_Item_ID INT FOREIGN KEY REFERENCES Cart_Items(Cart_Item_ID) -- Связь с новой таблицей
);

-- Вставляем данные в Payments
INSERT INTO Payments (Payment_ID, Amount_Paid, Method, Payment_Date, Cart_Item_ID)
VALUES
    (1, 50.00, 'Credit Card', '2022-01-16', 1),
    (2, 25.00, 'PayPal', '2022-02-21', 2),
    (3, 75.00, 'Cash', '2022-03-26', 3),
    (4, 30.00, 'Credit Card', '2022-04-11', 4),
    (5, 60.00, 'PayPal', '2022-05-13', 5),
    (6, 15.00, 'Cash', '2022-06-19', 6),
    (7, 100.00, 'Credit Card', '2022-07-23', 7);

-- Создаем таблицу Member_Orders
CREATE TABLE Member_Orders (
    Order_ID int not null Primary Key,
	Status int,
    Address_ID INT FOREIGN KEY REFERENCES Address_Member(Address_ID),
    Payment_ID INT FOREIGN KEY REFERENCES Payments(Payment_ID)
);

-- Вставляем данные в Member_Orders
INSERT INTO Member_Orders (Order_ID, Status, Address_ID, Payment_ID)
VALUES
    (1, 0, 1, 1),
    (2, 1, 2, 2),
    (3, 0, 3, 3),
    (4, 1, 4, 4),
    (5, 1, 5, 5),
    (6, 0, 6, 6),
    (7, 0, 7, 7);
 -- Получаем информацию об издателях и количестве выпущенных ими книг
SELECT p.Publisher_ID, p.Name AS Publisher_Name, COUNT(pb.Book_ID) AS Total_Books_Published
FROM Publishers p
LEFT JOIN Publisher_Books pb ON p.Publisher_ID = pb.Publisher_ID
GROUP BY p.Publisher_ID, p.Name;

-- Получаем информацию о книгах, которые находятся в корзинах и по которым не было совершено оплат
SELECT c.Member_ID, b.Book_ID, b.Name AS Book_Name, c.Quantity
FROM Carts c
JOIN Cart_Items ci ON c.Cart_ID = ci.Cart_ID
JOIN Books b ON ci.Book_ID = b.Book_ID
LEFT JOIN Payments p ON ci.Cart_Item_ID = p.Cart_Item_ID
WHERE p.Payment_ID IS NULL;

-- Получаем книги с их средним рейтингом и сортируем по убыванию
SELECT r.Book_ID, b.Name AS Book_Name, AVG(r.Rating) AS Average_Rating
FROM Reviews r
JOIN Books b ON r.Book_ID = b.Book_ID
GROUP BY r.Book_ID, b.Name
ORDER BY Average_Rating DESC;

-- Получаем количество отзывов, оставленных каждым членом
SELECT m.Member_ID, m.Name AS Member_Name, COUNT(r.Review_ID) AS Total_Feedbacks
FROM Members m
LEFT JOIN Reviews r ON m.Member_ID = r.Member_ID
GROUP BY m.Member_ID, m.Name;

-- Получаем издателей и количество опубликованных ими книг, отсортировано по количеству
SELECT p.Publisher_ID, p.Name AS Publisher_Name, COUNT(pb.Book_ID) AS Total_Books_Published
FROM Publishers p
JOIN Publisher_Books pb ON p.Publisher_ID = pb.Publisher_ID
GROUP BY p.Publisher_ID, p.Name
ORDER BY Total_Books_Published DESC;

-- Получаем издателей и количество заказанных у них книг
SELECT p.Publisher_ID, p.Name AS Publisher_Name, COUNT(os.Book_ID) AS Total_Books_Ordered
FROM Order_Stock os
JOIN Books b ON os.Book_ID = b.Book_ID
JOIN Publisher_Books pb ON b.Book_ID = pb.Book_ID
JOIN Publishers p ON pb.Publisher_ID = p.Publisher_ID
GROUP BY p.Publisher_ID, p.Name;

-- Получаем издателей и общее количество заказанных у них книг
SELECT p.Publisher_ID, p.Name AS Publisher_Name, SUM(os.Quantity) AS Total_Books_Ordered
FROM Order_Stock os
JOIN Books b ON os.Book_ID = b.Book_ID
JOIN Publisher_Books pb ON b.Book_ID = pb.Book_ID
JOIN Publishers p ON pb.Publisher_ID = p.Publisher_ID
GROUP BY p.Publisher_ID, p.Name;

-- Получаем книгу с наибольшим количеством на складе и ее жанр
SELECT b.Book_ID, b.Name AS Book_Name, g.Genre_Name AS Genre
FROM Books b
JOIN Book_Genres bg ON b.Book_ID = bg.Book_ID
JOIN Genres g ON bg.Genre_ID = g.Genre_ID
WHERE b.Stock = (SELECT MAX(Stock) FROM Books);

-- Получаем книги и общее количество проданных экземпляров, сортируем по убыванию
SELECT b.Book_ID, b.Name AS Book_Name, SUM(os.Quantity) AS Total_Sold
FROM Order_Stock os
JOIN Books b ON os.Book_ID = b.Book_ID
GROUP BY b.Book_ID, b.Name
ORDER BY Total_Sold DESC;

-- Получаем информацию о членах и суммах, которые они потратили на покупки
SELECT m.Member_ID, m.Name AS Member_Name, SUM(p.Amount_Paid) AS Total_Spent
FROM Members m
JOIN Member_Orders mo ON m.Address_ID = mo.Address_ID
JOIN Payments p ON mo.Payment_ID = p.Payment_ID
GROUP BY m.Member_ID, m.Name
ORDER BY Total_Spent DESC;

-- Получаем членов, которые не сделали ни одного заказа
SELECT m.Member_ID, m.Name AS Member_Name
FROM Members m
LEFT JOIN Member_Orders mo ON m.Address_ID = mo.Address_ID
WHERE mo.Order_ID IS NULL;

-- Получаем книги, добавленные в корзину, но не заказанные
SELECT b.Book_ID, b.Name AS Book_Name
FROM Books b
JOIN Cart_Items ci ON b.Book_ID = ci.Book_ID
LEFT JOIN Member_Orders mo ON ci.Cart_ID = mo.Order_ID
WHERE mo.Status = 0 OR mo.Status IS NULL;

-- Получаем членов, у которых больше двух заказов
SELECT m.Member_ID, m.Name AS Member_Name, COUNT(mo.Order_ID) AS Order_Count
FROM Members m
LEFT JOIN Member_Orders mo ON m.Address_ID = mo.Address_ID
GROUP BY m.Member_ID, m.Name
HAVING COUNT(mo.Order_ID) > 2;
