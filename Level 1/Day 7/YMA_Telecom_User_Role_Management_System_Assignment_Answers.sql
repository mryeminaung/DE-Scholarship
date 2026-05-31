-- =============================================================
-- Name: Ye Min Aung
-- Enrolled ID - DE-2026-0184
-- University: Myanmar Institute Of Information Technology (MIIT)
-- ==============================================================

-- =============================================================
-- Assignment: Telecom User Role Management System
-- Database Administration and SQL Practical Assignment
-- Domain: Telecommunication Company User Access Management System
-- ==============================================================

-- Section A — DDL (Data Definition Language)

-- Q-1
CREATE DATABASE telecom_user_mgmt;
USE telecom_user_mgmt;

-- Q-2
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    department VARCHAR(50),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Q-3
CREATE TABLE roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

-- Q-4
CREATE TABLE permissions (
    permission_id INT PRIMARY KEY AUTO_INCREMENT,
    permission_name VARCHAR(100) NOT NULL,
    module_name VARCHAR(50) NOT NULL
);

-- Q-5
CREATE TABLE user_roles (
    user_id INT,
    role_id INT,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- Q-6
CREATE TABLE audit_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action VARCHAR(255) NOT NULL,
    log_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Section B — DML (Data Manipulation Language)

-- Q-7
INSERT INTO users (username, email, department) VALUES 
('admin_user', 'admin@telecom.com', 'IT'),
('billing_officer_01', 'billing@telecom.com', 'Billing'),
('support_agent_01', 'support@telecom.com', 'Customer Support'),
('network_eng_01', 'network@telecom.com', 'Network Operations'),
('mgmt_user_01', 'management@telecom.com', 'Management');

-- Q-8
INSERT INTO roles (role_name) VALUES 
('Admin'), 
('Billing Officer'), 
('Support Agent'), 
('Network Engineer'), 
('Viewer');

-- Q-9
INSERT INTO permissions (permission_name, module_name) VALUES 
('Create User', 'User Management'),
('Update Billing', 'Billing'),
('Modify Network', 'Network'),
('View Reports', 'Reports'),
('Delete Record', 'System');

-- Q-10
INSERT INTO user_roles (user_id, role_id) VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

-- Q-11
UPDATE users 
SET status = 'INACTIVE' 
WHERE user_id = 5;

-- Q-12
DELETE FROM permissions WHERE permission_id = 5;

-- Section C — DQL (Data Query Language)

-- Q-13
SELECT * FROM users;

-- Q-14
SELECT * FROM users WHERE status = 'ACTIVE';

-- Q-15
SELECT u.username, u.department, r.role_name
FROM users u
JOIN user_roles ur 
ON u.user_id = ur.user_id
JOIN roles r ON ur.role_id = r.role_id;

-- Q-16
SELECT department, COUNT(*) AS total_users FROM users GROUP BY department;

-- Q-17
SELECT * FROM users WHERE department = 'Billing';

-- Q-18
SELECT r.role_name, p.permission_name
FROM roles r
CROSS JOIN permissions p;

-- Q-19
SELECT * FROM users ORDER BY username ASC;

-- Q-20
SELECT COUNT(*) AS total_system_users FROM users;

-- Section D — DTL / TCL (Transaction Control Language)

-- Q-21
START TRANSACTION;

INSERT INTO audit_logs (user_id, action) 
VALUES (1, 'Created new user');

COMMIT;

-- Q-22
START TRANSACTION;

UPDATE users 
SET status = 'INACTIVE' 
WHERE user_id = 2;

ROLLBACK;

-- Q-23
START TRANSACTION;

UPDATE users 
SET department = 'IT' 
WHERE user_id = 3;

SAVEPOINT sp1;

-- Q-24
UPDATE users 
SET department = 'Management' 
WHERE user_id = 3;

ROLLBACK TO sp1;

COMMIT;

-- Section E — DCL (Data Control Language)

-- Q-25
CREATE USER 'billing_user'@'localhost' IDENTIFIED BY 'password123';

-- Q-26
GRANT SELECT, UPDATE ON users TO 'billing_user'@'localhost';

-- Q-27
GRANT INSERT ON audit_logs TO 'billing_user'@'localhost';

-- Q-28
SHOW GRANTS FOR 'billing_user'@'localhost';

-- Q-29
REVOKE UPDATE ON users FROM 'billing_user'@'localhost';

-- Q-30
CREATE USER 'viewer_user'@'localhost' IDENTIFIED BY 'read_only_pass';
GRANT SELECT ON telecom_user_mgmt.* TO 'viewer_user'@'localhost';

-- Section F — Practical Scenario Questions

-- Q-31
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'admin123';
GRANT ALL PRIVILEGES ON telecom_user_mgmt.* TO 'admin_user'@'localhost';

-- Q-32
GRANT SELECT, UPDATE ON telecom_user_mgmt.users TO 'billing_user'@'localhost';

-- Q-33
CREATE USER 'support_agent'@'localhost' IDENTIFIED BY 'support_pass123';
GRANT SELECT ON telecom_user_mgmt.* TO 'support_agent'@'localhost';

-- Q-34
SELECT u.username, r.role_name, p.permission_name, p.module_name
FROM users u
JOIN user_roles ur 
ON u.user_id = ur.user_id
JOIN roles r 
ON ur.role_id = r.role_id
JOIN permissions p;
