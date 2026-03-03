-- ============================================================
-- Lab 03: Dataset Extension — User Sessions
-- Author: Your Name
-- Date: 2026-02-25
-- ============================================================

DROP TABLE IF EXISTS user_sessions;

CREATE TABLE user_sessions (
    session_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    session_date DATE NOT NULL,
    pages_viewed INTEGER NOT NULL DEFAULT 1,
    duration_mins DECIMAL(6,2) NOT NULL,
    device VARCHAR(20) NOT NULL,
    converted BOOLEAN NOT NULL DEFAULT FALSE
);

INSERT INTO user_sessions
(customer_id, session_date, pages_viewed, duration_mins, device, converted)
VALUES

-- Ali Hassan (customer 1)
(1, '2024-10-05', 8, 14.5, 'mobile', FALSE),
(1, '2024-10-18', 12, 22.3, 'desktop', TRUE),
(1, '2025-01-15', 5, 8.1, 'mobile', FALSE),
(1, '2025-04-01', 15, 31.0, 'desktop', TRUE),

-- Sara Khan (customer 2)
(2, '2024-09-10', 3, 4.2, 'mobile', FALSE),
(2, '2024-09-11', 10, 18.7, 'desktop', TRUE),
(2, '2025-06-15', 6, 9.5, 'tablet', FALSE),
(2, '2025-06-17', 14, 25.4, 'desktop', TRUE),

-- Usman Tariq (customer 3)
(3, '2024-09-28', 7, 12.0, 'mobile', FALSE),
(3, '2024-09-30', 18, 35.6, 'desktop', TRUE),
(3, '2025-04-12', 9, 16.2, 'mobile', FALSE),
(3, '2025-04-14', 11, 20.8, 'desktop', TRUE),

-- Fatima Malik (customer 4)
(4, '2024-10-10', 4, 6.3, 'tablet', FALSE),
(4, '2024-10-14', 13, 24.1, 'desktop', TRUE),
(4, '2025-02-20', 7, 11.5, 'mobile', FALSE),

-- Bilal Ahmed (customer 5)
(5, '2024-10-30', 6, 10.2, 'mobile', FALSE),
(5, '2024-10-31', 9, 17.4, 'desktop', TRUE),
(5, '2025-04-28', 5, 8.8, 'mobile', FALSE),
(5, '2025-04-30', 12, 23.5, 'desktop', TRUE),

-- Ayesha Noor (customer 6)
(6, '2024-11-15', 20, 42.0, 'desktop', TRUE),
(6, '2025-08-12', 25, 55.0, 'desktop', TRUE),

-- Hamza Sheikh (customer 7)
(7, '2024-12-01', 8, 13.7, 'mobile', FALSE),
(7, '2024-12-04', 11, 20.0, 'desktop', TRUE),

-- Zainab Iqbal (customer 8)
(8, '2024-12-18', 3, 5.5, 'mobile', FALSE),
(8, '2024-12-19', 7, 12.3, 'tablet', FALSE),
(8, '2024-12-20', 16, 30.1, 'desktop', TRUE),
(8, '2025-07-03', 9, 14.2, 'mobile', FALSE),
(8, '2025-07-04', 13, 22.6, 'desktop', TRUE),

-- Farhan Butt (customer 9)
(9, '2025-01-05', 11, 19.8, 'desktop', FALSE),
(9, '2025-01-07', 17, 33.4, 'desktop', TRUE),
(9, '2025-08-25', 8, 15.0, 'mobile', FALSE),
(9, '2025-08-27', 22, 44.7, 'desktop', TRUE),

-- Sana Rashid (customer 10)
(10, '2025-01-20', 6, 10.5, 'tablet', FALSE),
(10, '2025-01-21', 14, 26.8, 'desktop', TRUE),
(10, '2025-07-10', 10, 18.3, 'mobile', FALSE),
(10, '2025-07-11', 18, 37.2, 'desktop', TRUE),

-- Omar Hussain (customer 11)
(11, '2025-02-01', 5, 8.0, 'mobile', FALSE),
(11, '2025-02-02', 12, 22.5, 'desktop', TRUE),

-- Nadia Aziz (customer 12)
(12, '2025-02-12', 3, 4.8, 'mobile', FALSE),
(12, '2025-07-18', 8, 13.5, 'mobile', FALSE),
(12, '2025-07-19', 15, 28.9, 'desktop', TRUE),

-- Tariq Mehmood (customer 13)
(13, '2025-02-28', 22, 48.3, 'desktop', TRUE),

-- Hina Qureshi (customer 14)
(14, '2025-03-08', 7, 11.0, 'tablet', FALSE),
(14, '2025-03-09', 16, 30.5, 'desktop', TRUE),
(14, '2025-07-30', 4, 6.7, 'mobile', FALSE),
(14, '2025-08-01', 10, 19.4, 'desktop', FALSE),

-- Kamran Javed (customer 15)
(15, '2025-03-20', 5, 9.2, 'mobile', FALSE),
(15, '2025-03-21', 9, 16.8, 'desktop', FALSE),

-- Rabia Siddiqui (customer 16)
(16, '2025-05-06', 6, 10.0, 'mobile', FALSE),
(16, '2025-05-07', 18, 36.2, 'desktop', TRUE),

-- Imran Chaudhry (customer 17)
(17, '2025-05-10', 28, 58.0, 'desktop', TRUE),

-- Maira Aslam (customer 18)
(18, '2025-05-18', 7, 12.4, 'mobile', FALSE),
(18, '2025-05-20', 13, 24.7, 'desktop', TRUE),

-- Asad Nawaz (customer 19)
(19, '2025-05-30', 9, 15.8, 'mobile', FALSE),
(19, '2025-06-01', 21, 43.2, 'desktop', TRUE),

-- Kiran Baig (customer 20)
(20, '2025-06-08', 4, 7.3, 'mobile', FALSE),
(20, '2025-06-10', 11, 20.1, 'desktop', FALSE);
