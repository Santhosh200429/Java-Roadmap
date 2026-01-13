# SQL Basics for Java Developers

## SQL Overview

**SQL (Structured Query Language)** - Standard language for database operations.

**Four Main Operations (CRUD):**
- **C**reate (INSERT)
- **R**ead (SELECT)
- **U**pdate (UPDATE)
- **D**elete (DELETE)

## Database & Table Concepts

### Database Structure

```
Database
"oe"" Table: users
"   "oe"" Columns: id, name, email, age
"   "oe"" Row 1: [1, "Alice", "alice@email.com", 25]
"   "oe"" Row 2: [2, "Bob", "bob@email.com", 30]
"   """" Row 3: [3, "Charlie", "charlie@email.com", 28]
"
"""" Table: orders
    "oe"" Columns: orderId, userId, amount, date
    "oe"" Row 1: [101, 1, 99.99, 2024-01-15]
    """" Row 2: [102, 2, 149.99, 2024-01-20]
```

### Creating a Table

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    age INT CHECK (age >= 18),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Column Constraints:
-- PRIMARY KEY: Unique identifier for each row
-- NOT NULL: Field cannot be empty
-- UNIQUE: No duplicate values allowed
-- CHECK: Values must satisfy condition
-- DEFAULT: Default value if not provided
```

## CRUD Operations

### 1. CREATE (INSERT)

#### Basic Insert

```sql
INSERT INTO users (name, email, age)
VALUES ('Alice', 'alice@email.com', 25);

-- Result:
-- id | name  | email              | age
-- 1  | Alice | alice@email.com    | 25
```

#### Insert Multiple Rows

```sql
INSERT INTO users (name, email, age)
VALUES 
    ('Bob', 'bob@email.com', 30),
    ('Charlie', 'charlie@email.com', 28),
    ('Diana', 'diana@email.com', 35);

-- Result:
-- id | name    | email               | age
-- 1  | Alice   | alice@email.com     | 25
-- 2  | Bob     | bob@email.com       | 30
-- 3  | Charlie | charlie@email.com   | 28
-- 4  | Diana   | diana@email.com     | 35
```

### 2. READ (SELECT)

#### Select All Columns

```sql
SELECT * FROM users;

-- Result:
-- id | name    | email               | age | created_at
-- 1  | Alice   | alice@email.com     | 25  | 2024-01-01
-- 2  | Bob     | bob@email.com       | 30  | 2024-01-02
-- 3  | Charlie | charlie@email.com   | 28  | 2024-01-03
-- 4  | Diana   | diana@email.com     | 35  | 2024-01-04
```

#### Select Specific Columns

```sql
SELECT name, email FROM users;

-- Result:
-- name    | email
-- Alice   | alice@email.com
-- Bob     | bob@email.com
-- Charlie | charlie@email.com
-- Diana   | diana@email.com
```

#### WHERE Clause - Filter

```sql
SELECT * FROM users WHERE age > 25;

-- Result:
-- id | name    | email               | age
-- 2  | Bob     | bob@email.com       | 30
-- 3  | Charlie | charlie@email.com   | 28
-- 4  | Diana   | diana@email.com     | 35
```

#### Multiple Conditions

```sql
-- AND
SELECT * FROM users WHERE age > 25 AND name LIKE 'B%';
-- Result: Bob (age > 25 AND name starts with B)

-- OR
SELECT * FROM users WHERE age < 27 OR age > 30;
-- Result: Alice (25), Diana (35)

-- NOT
SELECT * FROM users WHERE NOT age = 30;
-- Result: All except Bob
```

#### ORDER BY - Sort Results

```sql
-- Ascending (default)
SELECT * FROM users ORDER BY age ASC;

-- Descending
SELECT * FROM users ORDER BY age DESC;

-- Multiple columns
SELECT * FROM users ORDER BY age DESC, name ASC;
```

#### LIMIT - Restrict Results

```sql
-- Get first 2 users
SELECT * FROM users LIMIT 2;

-- Get 2 users starting from position 1 (skip first)
SELECT * FROM users LIMIT 1, 2;  -- or OFFSET 1 LIMIT 2

-- Result:
-- id | name    | email             | age
-- 2  | Bob     | bob@email.com     | 30
-- 3  | Charlie | charlie@email.com | 28
```

### 3. UPDATE

```sql
-- Update single field
UPDATE users SET age = 26 WHERE name = 'Alice';

-- Update multiple fields
UPDATE users SET age = 26, email = 'alice.new@email.com' 
WHERE name = 'Alice';

-- Update all records (be careful!)
UPDATE users SET age = age + 1;  -- Increase all ages by 1

-- Verify:
SELECT * FROM users WHERE name = 'Alice';
-- Result:
-- id | name  | email               | age
-- 1  | Alice | alice.new@email.com | 26
```

### 4. DELETE

```sql
-- Delete single row
DELETE FROM users WHERE id = 1;

-- Delete multiple rows
DELETE FROM users WHERE age < 25;

-- Delete all records (be very careful!)
DELETE FROM users;

-- Verify:
SELECT COUNT(*) FROM users;  -- Returns 0
```

## Aggregate Functions

### COUNT

```sql
-- Count all users
SELECT COUNT(*) FROM users;
-- Result: 4

-- Count with condition
SELECT COUNT(*) FROM users WHERE age > 25;
-- Result: 3
```

### SUM

```sql
-- Total age
SELECT SUM(age) FROM users;
-- Result: 118

-- With condition
SELECT SUM(age) FROM users WHERE age > 25;
-- Result: 93 (30 + 28 + 35)
```

### AVG

```sql
-- Average age
SELECT AVG(age) FROM users;
-- Result: 29.5

-- With condition
SELECT AVG(age) FROM users WHERE age > 25;
-- Result: 31 (93 / 3)
```

### MIN, MAX

```sql
SELECT MIN(age) FROM users;  -- 25
SELECT MAX(age) FROM users;  -- 35
```

### GROUP BY

```sql
-- Count users by age range
SELECT age, COUNT(*) as count FROM users GROUP BY age;

-- Result:
-- age | count
-- 25  | 1
-- 28  | 1
-- 30  | 1
-- 35  | 1

-- Having clause (filter groups)
SELECT age, COUNT(*) as count FROM users 
GROUP BY age 
HAVING COUNT(*) > 1;
```

## Joins - Combine Tables

### Sample Data

```
users table:
id | name    | age
1  | Alice   | 25
2  | Bob     | 30

orders table:
orderId | userId | amount
101     | 1      | 99.99
102     | 1      | 49.99
103     | 2      | 149.99
```

### INNER JOIN - Common Records

```sql
SELECT users.name, orders.amount
FROM users
INNER JOIN orders ON users.id = orders.userId;

-- Result:
-- name  | amount
-- Alice | 99.99
-- Alice | 49.99
-- Bob   | 149.99
```

### LEFT JOIN - All from Left Table

```sql
SELECT users.name, COALESCE(orders.amount, 0) as amount
FROM users
LEFT JOIN orders ON users.id = orders.userId;

-- Result:
-- name     | amount
-- Alice    | 99.99
-- Alice    | 49.99
-- Bob      | 149.99
-- (all users included)
```

### RIGHT JOIN - All from Right Table

```sql
SELECT users.name, orders.amount
FROM users
RIGHT JOIN orders ON users.id = orders.userId;

-- Result:
-- name  | amount
-- Alice | 99.99
-- Alice | 49.99
-- Bob   | 149.99
```

## Indexes - Performance

### Creating Index

```sql
-- Single column
CREATE INDEX idx_email ON users(email);

-- Multiple columns
CREATE INDEX idx_name_age ON users(name, age);

-- Make searches faster
SELECT * FROM users WHERE email = 'alice@email.com';  -- oe" Fast!
```

## Transactions

### ACID Properties

```sql
-- BEGIN TRANSACTION
BEGIN;

-- Execute statements
INSERT INTO users VALUES (5, 'Eve', 'eve@email.com', 27);
UPDATE users SET age = 26 WHERE id = 1;

-- COMMIT or ROLLBACK
COMMIT;  -- Save all changes

-- Or rollback
ROLLBACK;  -- Undo all changes
```

### Example: Money Transfer

```sql
BEGIN;

-- Deduct from Alice's account
UPDATE accounts SET balance = balance - 100 WHERE name = 'Alice';

-- Add to Bob's account
UPDATE accounts SET balance = balance + 100 WHERE name = 'Bob';

-- Both succeed or both fail (ACID)
COMMIT;
```

## Constraints & Data Types

### Data Types

```sql
-- Numeric
INT, BIGINT, DECIMAL(10,2), FLOAT

-- Text
VARCHAR(100), CHAR(50), TEXT

-- Date/Time
DATE, TIME, TIMESTAMP, DATETIME

-- Boolean
BOOLEAN, TINYINT(1)
```

### Constraints

```sql
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) CHECK (price > 0),
    category VARCHAR(50) NOT NULL,
    sku VARCHAR(20) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key (references another table)
    seller_id INT,
    FOREIGN KEY (seller_id) REFERENCES sellers(id)
);
```

## Common SQL Patterns

### Pattern 1: Find Duplicates

```sql
SELECT email, COUNT(*) as count
FROM users
GROUP BY email
HAVING COUNT(*) > 1;
```

### Pattern 2: Get Latest Record per Group

```sql
-- Latest order per user
SELECT DISTINCT ON (userId) *
FROM orders
ORDER BY userId, date DESC;
```

### Pattern 3: Pagination

```sql
SELECT * FROM users
ORDER BY id
LIMIT 10 OFFSET 0;  -- Page 1: rows 0-9
-- LIMIT 10 OFFSET 10;  -- Page 2: rows 10-19
```

### Pattern 4: Update with Join

```sql
UPDATE users
SET last_order_date = (
    SELECT MAX(date) FROM orders WHERE orders.userId = users.id
)
WHERE id IN (SELECT DISTINCT userId FROM orders);
```

## SQL Best Practices

```sql
-- 1. Use parameterized queries (in code)
-- GOOD:
PreparedStatement ps = connection.prepareStatement(
    "SELECT * FROM users WHERE email = ?"
);
ps.setString(1, email);

-- BAD (SQL injection):
String query = "SELECT * FROM users WHERE email = '" + email + "'";

-- 2. Index frequently searched columns
CREATE INDEX idx_email ON users(email);

-- 3. Use LIMIT to prevent fetching huge datasets
SELECT * FROM users LIMIT 1000;

-- 4. Use joins instead of multiple queries
-- GOOD: Single query with join
SELECT users.name, orders.amount FROM users
INNER JOIN orders ON users.id = orders.userId;

-- BAD: Multiple queries (N+1 problem)
for (User user : users) {
    List<Order> orders = getOrdersForUser(user.id);
}

-- 5. Use transactions for related operations
BEGIN;
UPDATE account SET balance = balance - 100 WHERE id = 1;
UPDATE account SET balance = balance + 100 WHERE id = 2;
COMMIT;
```

## Key Takeaways

- SQL is standard for all relational databases
- CRUD: INSERT, SELECT, UPDATE, DELETE
- WHERE filters results
- ORDER BY sorts; LIMIT restricts
- Aggregates: COUNT, SUM, AVG, MIN, MAX
- GROUP BY groups similar records
- JOINs combine multiple tables
- Indexes speed up searches
- Transactions ensure consistency
- Always use parameterized queries to prevent SQL injection
- Foreign keys enforce referential integrity

---


