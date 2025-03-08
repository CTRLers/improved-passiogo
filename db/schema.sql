-- Drop existing tables if they exist (optional) 

BEGIN 

    EXECUTE IMMEDIATE 'DROP TABLE UserPreferences CASCADE CONSTRAINTS'; 

    EXECUTE IMMEDIATE 'DROP TABLE Notifications CASCADE CONSTRAINTS'; 

    EXECUTE IMMEDIATE 'DROP TABLE LiveTracking CASCADE CONSTRAINTS'; 

    EXECUTE IMMEDIATE 'DROP TABLE Schedules CASCADE CONSTRAINTS'; 

    EXECUTE IMMEDIATE 'DROP TABLE Stops CASCADE CONSTRAINTS'; 

    EXECUTE IMMEDIATE 'DROP TABLE Routes CASCADE CONSTRAINTS'; 

    EXECUTE IMMEDIATE 'DROP TABLE Buses CASCADE CONSTRAINTS'; 

    EXECUTE IMMEDIATE 'DROP TABLE Users CASCADE CONSTRAINTS'; 

EXCEPTION 

    WHEN OTHERS THEN NULL; 

END; 

/ 

 

-- Create Sequences for Primary Keys (Oracle Alternative for AUTO_INCREMENT) 

CREATE SEQUENCE users_seq START WITH 1 INCREMENT BY 1; 

CREATE SEQUENCE buses_seq START WITH 1 INCREMENT BY 1; 

CREATE SEQUENCE routes_seq START WITH 1 INCREMENT BY 1; 

CREATE SEQUENCE stops_seq START WITH 1 INCREMENT BY 1; 

CREATE SEQUENCE schedules_seq START WITH 1 INCREMENT BY 1; 

CREATE SEQUENCE tracking_seq START WITH 1 INCREMENT BY 1; 

CREATE SEQUENCE notifications_seq START WITH 1 INCREMENT BY 1; 

CREATE SEQUENCE preferences_seq START WITH 1 INCREMENT BY 1; 

 

-- Users Table 

CREATE TABLE Users ( 

    user_id NUMBER PRIMARY KEY, 

    name VARCHAR2(100) NOT NULL, 

    email VARCHAR2(255) UNIQUE NOT NULL, 

    password_hash VARCHAR2(255) NOT NULL, 

    role VARCHAR2(20) CHECK (role IN ('student', 'faculty', 'staff')), 

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 

); 

 

-- Buses Table 

CREATE TABLE Buses ( 

    bus_id NUMBER PRIMARY KEY, 

    bus_number VARCHAR2(10) UNIQUE NOT NULL, 

    capacity NUMBER NOT NULL, 

    status VARCHAR2(20) CHECK (status IN ('active', 'maintenance', 'offline')) DEFAULT 'active' 

); 

 

-- Routes Table 

CREATE TABLE Routes ( 

    route_id NUMBER PRIMARY KEY, 

    name VARCHAR2(50) UNIQUE NOT NULL, 

    description CLOB NOT NULL 

); 

 

-- Stops Table 

CREATE TABLE Stops ( 

    stop_id NUMBER PRIMARY KEY, 

    name VARCHAR2(100) NOT NULL, 

    latitude NUMBER(10,8) NOT NULL, 

    longitude NUMBER(11,8) NOT NULL 

); 

 

-- Schedules Table 

CREATE TABLE Schedules ( 

    schedule_id NUMBER PRIMARY KEY, 

    bus_id NUMBER NOT NULL, 

    route_id NUMBER NOT NULL, 

    stop_id NUMBER NOT NULL, 

    arrival_time TIMESTAMP NOT NULL, 

    departure_time TIMESTAMP NOT NULL, 

    FOREIGN KEY (bus_id) REFERENCES Buses(bus_id), 

    FOREIGN KEY (route_id) REFERENCES Routes(route_id), 

    FOREIGN KEY (stop_id) REFERENCES Stops(stop_id) 

); 

 

-- Live Tracking Table 

CREATE TABLE LiveTracking ( 

    track_id NUMBER PRIMARY KEY, 

    bus_id NUMBER NOT NULL, 

    route_id NUMBER NOT NULL, 

    latitude NUMBER(10,8) NOT NULL, 

    longitude NUMBER(11,8) NOT NULL, 

    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 

    FOREIGN KEY (bus_id) REFERENCES Buses(bus_id), 

    FOREIGN KEY (route_id) REFERENCES Routes(route_id) 

); 

 

-- Notifications Table 

CREATE TABLE Notifications ( 

    notification_id NUMBER PRIMARY KEY, 

    user_id NUMBER NOT NULL, 

    message CLOB NOT NULL, 

    status VARCHAR2(20) CHECK (status IN ('sent', 'pending', 'failed')) DEFAULT 'pending', 

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 

    FOREIGN KEY (user_id) REFERENCES Users(user_id) 

); 

 

-- User Preferences Table 

CREATE TABLE UserPreferences ( 

    preference_id NUMBER PRIMARY KEY, 

    user_id NUMBER NOT NULL, 

    route_id NUMBER NOT NULL, 

    stop_id NUMBER NOT NULL, 

    notify_before_minutes NUMBER DEFAULT 5, 

    enable_notifications NUMBER(1) DEFAULT 1, -- 0 = False, 1 = True 

    FOREIGN KEY (user_id) REFERENCES Users(user_id), 

    FOREIGN KEY (route_id) REFERENCES Routes(route_id), 

    FOREIGN KEY (stop_id) REFERENCES Stops(stop_id) 

); 

 

-- Insert Sample Data 

INSERT INTO Users (user_id, name, email, password_hash, role)  

VALUES  

(users_seq.NEXTVAL, 'John Doe', 'johndoe@usf.edu', 'hashedpassword123', 'student'), 

(users_seq.NEXTVAL, 'Jane Smith', 'janesmith@usf.edu, 'hashedpassword456', 'faculty'); 

 

INSERT INTO Buses (bus_id, bus_number, capacity, status)  

VALUES  

(buses_seq.NEXTVAL, 'USF-101', 40, 'active'), 

(buses_seq.NEXTVAL, 'USF-102', 50, 'active'); 

 

INSERT INTO Routes (route_id, name, description)  

VALUES  

(routes_seq.NEXTVAL, 'Route Purple', 'Main USF Campus loop'), 

(routes_seq.NEXTVAL, 'Route Red', 'Extended route covering off-campus housing'); 

 

INSERT INTO Stops (stop_id, name, latitude, longitude)  

VALUES  

(stops_seq.NEXTVAL, 'USF Library Stop', 28.0587, -82.4139), 

(stops_seq.NEXTVAL, 'USF Student Center', 28.0601, -82.4150), 

(stops_seq.NEXTVAL, 'University Mall', 28.0643, -82.4371); 

 

INSERT INTO Schedules (schedule_id, bus_id, route_id, stop_id, arrival_time, departure_time)  

VALUES  

(schedules_seq.NEXTVAL, 1, 1, 1, TO_DATE('08:30:00', 'HH24:MI:SS'), TO_DATE('08:35:00', 'HH24:MI:SS')), 

(schedules_seq.NEXTVAL, 1, 1, 2, TO_DATE('08:40:00', 'HH24:MI:SS'), TO_DATE('08:45:00', 'HH24:MI:SS')), 

(schedules_seq.NEXTVAL, 2, 2, 3, TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('09:05:00', 'HH24:MI:SS')); 

 

INSERT INTO UserPreferences (preference_id, user_id, route_id, stop_id, notify_before_minutes, enable_notifications) 

VALUES  

(preferences_seq.NEXTVAL, 1, 1, 1, 5, 1), 

(preferences_seq.NEXTVAL, 2, 2, 3, 10, 1); 

 

-- Verify Data 

SELECT * FROM Users; 

SELECT * FROM Buses; 

SELECT * FROM Routes; 

SELECT * FROM Stops; 

SELECT * FROM Schedules; 

SELECT * FROM LiveTracking; 

SELECT * FROM Notifications; 

SELECT * FROM UserPreferences; 

 

 
