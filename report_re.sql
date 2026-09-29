-- Create Report Query: Customer, QAC, and Transactions Join
-- Table t1: bankcustomers (Customer Table)
-- Table t2: qac_table (QAC Table)
-- Table t3: transactions_table (Transactions Table)

-- First, create the QAC table if it doesn't exist
DROP TABLE IF EXISTS qac_table;
CREATE TABLE IF NOT EXISTS qac_table (
    qac_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    qac_code VARCHAR(50) UNIQUE NOT NULL,
    qac_status VARCHAR(50) DEFAULT 'Active',
    qac_type VARCHAR(100),
    created_date DATE DEFAULT CURRENT_DATE,
    last_review_date DATE,
    reviewer_name VARCHAR(100),
    compliance_score DECIMAL(5,2),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES bankcustomers(customer_id),
    INDEX idx_qac_customer (customer_id),
    INDEX idx_qac_status (qac_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Create the Transactions table if it doesn't exist
DROP TABLE IF EXISTS transactions_table;
CREATE TABLE IF NOT EXISTS transactions_table (
    transaction_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    account_number VARCHAR(20) NOT NULL,
    transaction_type VARCHAR(50),
    amount DECIMAL(15,2),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(255),
    status VARCHAR(50) DEFAULT 'Completed',
    reference_number VARCHAR(50) UNIQUE,
    merchant_name VARCHAR(100),
    currency CHAR(3) DEFAULT 'USD',
    balance_after DECIMAL(15,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES bankcustomers(customer_id),
    INDEX idx_trans_customer (customer_id),
    INDEX idx_trans_account (account_number),
    INDEX idx_trans_date (transaction_date),
    INDEX idx_trans_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ===================================================================
-- MAIN REPORT QUERY: Customer, QAC, and Transactions Report
-- ===================================================================
SELECT 
    -- Customer Information (t1)
    t1.customer_id,
    t1.account_number,
    CONCAT(t1.first_name, ' ', t1.last_name) AS customer_name,
    t1.email,
    t1.phone,
    t1.city,
    t1.state,
    t1.account_type,
    t1.balance AS account_balance,
    t1.is_active AS customer_status,
    
    -- QAC Information (t2)
    t2.qac_id,
    t2.qac_code,
    t2.qac_status,
    t2.qac_type,
    t2.compliance_score,
    t2.last_review_date,
    t2.reviewer_name,
    
    -- Transaction Information (t3)
    t3.transaction_id,
    t3.transaction_type,
    t3.amount,
    t3.transaction_date,
    t3.status AS transaction_status,
    t3.reference_number,
    t3.merchant_name,
    t3.balance_after,
    
    -- Summary Metrics
    COUNT(t3.transaction_id) OVER (PARTITION BY t1.customer_id) AS total_transactions,
    SUM(t3.amount) OVER (PARTITION BY t1.customer_id) AS total_transaction_amount
    
FROM bankcustomers t1
LEFT JOIN qac_table t2 ON t1.customer_id = t2.customer_id
LEFT JOIN transactions_table t3 ON t1.customer_id = t3.customer_id

WHERE t1.is_active = TRUE
  AND (t2.qac_status IS NULL OR t2.qac_status = 'Active')
  AND (t3.status IS NULL OR t3.status = 'Completed')

ORDER BY t1.customer_id, t3.transaction_date DESC;

-- ===================================================================
-- ALTERNATIVE REPORT: Summary Report (Aggregated View)
-- ===================================================================
SELECT 
    t1.customer_id,
    t1.account_number,
    CONCAT(t1.first_name, ' ', t1.last_name) AS customer_name,
    t1.account_type,
    t1.balance AS current_balance,
    t2.qac_code,
    t2.qac_status,
    t2.compliance_score,
    COUNT(DISTINCT t3.transaction_id) AS transaction_count,
    SUM(CASE WHEN t3.transaction_type = 'Deposit' THEN t3.amount ELSE 0 END) AS total_deposits,
    SUM(CASE WHEN t3.transaction_type = 'Withdrawal' THEN t3.amount ELSE 0 END) AS total_withdrawals,
    MAX(t3.transaction_date) AS last_transaction_date,
    AVG(t3.amount) AS avg_transaction_amount
    
FROM bankcustomers t1
LEFT JOIN qac_table t2 ON t1.customer_id = t2.customer_id
LEFT JOIN transactions_table t3 ON t1.customer_id = t3.customer_id

WHERE t1.is_active = TRUE

GROUP BY t1.customer_id, t1.account_number, t1.first_name, t1.last_name, 
         t1.account_type, t1.balance, t2.qac_code, t2.qac_status, t2.compliance_score

ORDER BY t1.customer_id;
