-- Customers Table
CREATE TABLE Customers (
    CustomerID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    FullName VARCHAR2(100),
    Email VARCHAR2(100),
    Phone VARCHAR2(15),
    DateRegistered DATE DEFAULT SYSDATE
);

-- Doctors Table
CREATE TABLE Doctors (
    DoctorID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    FullName VARCHAR2(100),
    Specialization VARCHAR2(50),
    Availability VARCHAR2(50)
);

-- Appointments Table
CREATE TABLE Appointments (
    AppointmentID NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    CustomerID NUMBER,
    DoctorID NUMBER,
    AppointmentDate DATE,
    StartTime VARCHAR2(5),
    EndTime VARCHAR2(5),
    Status VARCHAR2(20),
    CONSTRAINT fk_customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT fk_doctor FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

CREATE OR REPLACE PROCEDURE BookAppointment (
    p_CustomerID IN NUMBER,
    p_DoctorID IN NUMBER,
    p_AppointmentDate IN DATE,
    p_StartTime IN VARCHAR2,
    p_EndTime IN VARCHAR2
)
AS
    v_Count INTEGER;
BEGIN
    -- Check if the slot is already booked
    SELECT COUNT(*)
    INTO v_Count
    FROM Appointments
    WHERE DoctorID = p_DoctorID
      AND AppointmentDate = p_AppointmentDate
      AND (
          (p_StartTime BETWEEN StartTime AND EndTime) OR
          (p_EndTime BETWEEN StartTime AND EndTime) OR
          (StartTime BETWEEN p_StartTime AND p_EndTime)
      );

    IF v_Count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Time slot already booked.');
    ELSE
        -- Insert the appointment
        INSERT INTO Appointments (CustomerID, DoctorID, AppointmentDate, StartTime, EndTime, Status)
        VALUES (p_CustomerID, p_DoctorID, p_AppointmentDate, p_StartTime, p_EndTime, 'Scheduled');

        DBMS_OUTPUT.PUT_LINE('Appointment booked successfully.');
    END IF;
END;
/


CREATE OR REPLACE PROCEDURE RescheduleAppointment (
    p_AppointmentID IN NUMBER,
    p_NewDate IN DATE,
    p_NewStartTime IN VARCHAR2,
    p_NewEndTime IN VARCHAR2
)
AS
    v_DoctorID NUMBER;
    v_Count INTEGER;
BEGIN
    -- Get the DoctorID for the appointment
    SELECT DoctorID
    INTO v_DoctorID
    FROM Appointments
    WHERE AppointmentID = p_AppointmentID;

    -- Check if the new slot is already booked
    SELECT COUNT(*)
    INTO v_Count
    FROM Appointments
    WHERE DoctorID = v_DoctorID
      AND AppointmentDate = p_NewDate
      AND (
          (p_NewStartTime BETWEEN StartTime AND EndTime) OR
          (p_NewEndTime BETWEEN StartTime AND EndTime) OR
          (StartTime BETWEEN p_NewStartTime AND p_NewEndTime)
      );

    IF v_Count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('New time slot already booked.');
    ELSE
        -- Update the appointment
        UPDATE Appointments
        SET AppointmentDate = p_NewDate,
            StartTime = p_NewStartTime,
            EndTime = p_NewEndTime,
            Status = 'Scheduled'
        WHERE AppointmentID = p_AppointmentID;

        DBMS_OUTPUT.PUT_LINE('Appointment rescheduled successfully.');
    END IF;
END;
/


CREATE OR REPLACE PROCEDURE CancelAppointment (
    p_AppointmentID IN NUMBER
)
AS
BEGIN
    -- Cancel the appointment
    UPDATE Appointments
    SET Status = 'Canceled'
    WHERE AppointmentID = p_AppointmentID;

    DBMS_OUTPUT.PUT_LINE('Appointment canceled successfully.');
END;
/

CREATE OR REPLACE PROCEDURE CancelAppointment (
    p_AppointmentID IN NUMBER
)
AS
BEGIN
    -- Cancel the appointment
    UPDATE Appointments
    SET Status = 'Canceled'
    WHERE AppointmentID = p_AppointmentID;

    DBMS_OUTPUT.PUT_LINE('Appointment canceled successfully.');
END;
/


--Function
CREATE OR REPLACE FUNCTION CalculateAvailability (
    p_DoctorID IN NUMBER,
    p_Date IN DATE
)
RETURN NUMBER
AS
    v_TotalSlots INTEGER := 8; -- Assume 8 slots per day
    v_BookedSlots INTEGER;
BEGIN
    -- Count booked slots
    SELECT COUNT(*)
    INTO v_BookedSlots
    FROM Appointments
    WHERE DoctorID = p_DoctorID
      AND AppointmentDate = p_Date;

    -- Return available slots
    RETURN v_TotalSlots - v_BookedSlots;
END;
/
 --Triggers

CREATE OR REPLACE TRIGGER PreventDoubleBooking
BEFORE INSERT OR UPDATE ON Appointments
FOR EACH ROW
DECLARE
    v_Count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_Count
    FROM Appointments
    WHERE DoctorID = :NEW.DoctorID
      AND AppointmentDate = :NEW.AppointmentDate
      AND (
          (:NEW.StartTime BETWEEN StartTime AND EndTime) OR
          (:NEW.EndTime BETWEEN StartTime AND EndTime) OR
          (StartTime BETWEEN :NEW.StartTime AND :NEW.EndTime)
      );

    IF v_Count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Double booking is not allowed.');
    END IF;
END;
/

-- Insert sample customers
INSERT INTO Customers (FullName, Email, Phone) VALUES ('John Doe', 'john@example.com', '1234567890');
INSERT INTO Customers (FullName, Email, Phone) VALUES ('Jane Smith', 'jane@example.com', '9876543210');

-- Insert sample doctors
INSERT INTO Doctors (FullName, Specialization, Availability) VALUES ('Dr. Smith', 'Cardiology', 'Weekdays');
INSERT INTO Doctors (FullName, Specialization, Availability) VALUES ('Dr. Adams', 'Dermatology', 'Weekends');


BEGIN
    BookAppointment(1, 1, DATE '2025-01-10', '10:00', '11:00');
END;
/
BEGIN
    RescheduleAppointment(1, DATE '2025-01-11', '11:00', '12:00');
END;
/
BEGIN
    CancelAppointment(1);
END;
/
SELECT CalculateAvailability(1, DATE '2025-01-10') AS AvailableSlots FROM DUAL;


-- Insert additional customers
INSERT INTO Customers (FullName, Email, Phone) VALUES ('Alice Brown', 'alice@example.com', '1231231234');
INSERT INTO Customers (FullName, Email, Phone) VALUES ('Robert White', 'robert@example.com', '4564564567');
INSERT INTO Customers (FullName, Email, Phone) VALUES ('Emily Davis', 'emily@example.com', '7897897890');
INSERT INTO Customers (FullName, Email, Phone) VALUES ('Michael Scott', 'michael@example.com', '1011011010');
INSERT INTO Customers (FullName, Email, Phone) VALUES ('Sarah Johnson', 'sarah@example.com', '2022022022');


-- Insert additional doctors
INSERT INTO Doctors (FullName, Specialization, Availability) VALUES ('Dr. Lee', 'Orthopedics', 'Weekdays');
INSERT INTO Doctors (FullName, Specialization, Availability) VALUES ('Dr. Carter', 'Pediatrics', 'Weekends');
INSERT INTO Doctors (FullName, Specialization, Availability) VALUES ('Dr. Johnson', 'Neurology', 'Weekdays');
INSERT INTO Doctors (FullName, Specialization, Availability) VALUES ('Dr. Williams', 'ENT', 'Weekdays');
INSERT INTO Doctors (FullName, Specialization, Availability) VALUES ('Dr. Taylor', 'Psychiatry', 'Weekends');


INSERT INTO Appointments (CustomerID, DoctorID, AppointmentDate, StartTime, EndTime, Status) 
VALUES (2, 3, DATE '2025-01-12', '09:00', '10:00', 'Scheduled');

INSERT INTO Appointments (CustomerID, DoctorID, AppointmentDate, StartTime, EndTime, Status) 
VALUES (3, 4, DATE '2025-01-13', '10:00', '11:00', 'Scheduled');

INSERT INTO Appointments (CustomerID, DoctorID, AppointmentDate, StartTime, EndTime, Status) 
VALUES (4, 5, DATE '2025-01-14', '11:00', '12:00', 'Scheduled');

INSERT INTO Appointments (CustomerID, DoctorID, AppointmentDate, StartTime, EndTime, Status) 
VALUES (5, 1, DATE '2025-01-15', '12:00', '13:00', 'Scheduled');

INSERT INTO Appointments (CustomerID, DoctorID, AppointmentDate, StartTime, EndTime, Status) 
VALUES (1, 2, DATE '2025-01-16', '13:00', '14:00', 'Scheduled');

