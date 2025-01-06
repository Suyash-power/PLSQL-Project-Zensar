Project Description
The Appointment Scheduling System enables customers to book, reschedule, and cancel appointments with doctors. It ensures data integrity through relational constraints and PL/SQL logic and provides a structured workflow for managing appointments.

Database Schema
Tables:

Customers: Stores customer details, including name, email, and phone.
Doctors: Stores doctor details, including name, specialization, and availability.
Appointments: Tracks appointments with fields for customer, doctor, date, time, and status.
Relationships:

The Appointments table references Customers and Doctors using foreign keys.
Features
Customer Management: Register and manage customer details.
Doctor Management: Maintain doctor records with specialization and availability.
Appointment Booking: Schedule, reschedule, and cancel appointments.
Data Integrity: Triggers prevent double booking, and constraints ensure valid references.
Statistical Reporting: Plan for future integration of reports on appointments and cancellations.
Setup and Usage
Schema Creation: Set up the database by running the table creation scripts.
Data Population: Insert sample records for customers, doctors, and appointments.
PL/SQL Procedures: Use the provided procedures to handle appointment-related operations.
Validation: Verify data consistency through queries and reports.
Integrity Rules
Prevents overlapping appointments for the same doctor and time slot.
Enforces valid references for customers and doctors in the appointments table.
Ensures appointments are within specified working hours.
Future Enhancements
Notifications: Add reminders for upcoming appointments.
User Interface: Develop a front-end application for easier access and management.
Advanced Reporting: Include graphical and tabular reports on appointment trends and performance metrics.
This system is designed for easy expansion and integration into larger projects, offering a robust base for appointment scheduling needs.






