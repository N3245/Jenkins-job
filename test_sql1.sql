-- Create Employees Table
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    hire_date DATE NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2),
    manager_id INT,
    employment_status VARCHAR(20) DEFAULT 'Active',
    date_of_birth DATE,
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(10),
    country VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

-- Insert sample employee records
INSERT INTO employees (first_name, last_name, email, phone_number, hire_date, job_title, department, salary, manager_id, employment_status, date_of_birth, address, city, state, postal_code, country)
VALUES 
('John', 'Doe', 'john.doe@bank.com', '555-0001', '2020-01-15', 'Senior Developer', 'IT', 95000.00, NULL, 'Active', '1985-03-20', '123 Main St', 'New York', 'NY', '10001', 'USA'),
('Jane', 'Smith', 'jane.smith@bank.com', '555-0002', '2021-06-10', 'Database Administrator', 'IT', 85000.00, 1, 'Active', '1988-07-15', '456 Oak Ave', 'New York', 'NY', '10002', 'USA'),
('Michael', 'Johnson', 'michael.johnson@bank.com', '555-0003', '2019-11-05', 'Manager', 'HR', 80000.00, NULL, 'Active', '1980-09-12', '789 Pine Rd', 'Boston', 'MA', '02101', 'USA');

---- Create bankcustomers table (MySQL-compatible)
DROP TABLE IF EXISTS bankcustomers;
CREATE TABLE IF NOT EXISTS bankcustomers (
  customer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  account_number VARCHAR(20) NOT NULL UNIQUE,
  first_name VARCHAR(100) NOT NULL,
  middle_name VARCHAR(100),
  last_name VARCHAR(100) NOT NULL,
  date_of_birth DATE,
  ssn VARCHAR(20) UNIQUE,
  email VARCHAR(255) UNIQUE,
  phone VARCHAR(30),
  address_line1 VARCHAR(255),
  address_line2 VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(100),
  postal_code VARCHAR(20),
  country VARCHAR(100) DEFAULT 'USA',
  account_open_date DATE DEFAULT CURRENT_DATE,
  account_type VARCHAR(50),
  balance DECIMAL(15,2) DEFAULT 0.00,
  currency CHAR(3) DEFAULT 'USD',
  branch_id INT,
  is_active BOOLEAN DEFAULT TRUE,
  preferred_contact_method VARCHAR(50),
  last_login TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_bankcustomers_lastname (last_name),
  INDEX idx_bankcustomers_branch (branch_id),
  INDEX idx_bankcustomers_account_number (account_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Example select (for testing)



new line

SELECT * FROM bankcustomers;
