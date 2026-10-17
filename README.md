# \# Online Learning Management System (LMS)

# 

# A web-based Learning Management System developed as a B.Tech 3rd Semester project. The platform provides separate functionality for students, teachers, and administrators to support online learning and course management.

# 

# \## Features

# 

# \### Student

# \- User registration and login

# \- Student profile

# \- Browse available courses

# \- Enroll in courses

# \- View enrolled courses and lessons

# 

# \### Teacher

# \- Teacher dashboard

# \- Create and manage courses

# \- Add lessons to courses

# \- View teaching-related course information

# 

# \### Administrator

# \- Admin dashboard

# \- View and manage users

# \- Update user roles

# \- Manage and delete courses

# 

# \## Technology Stack

# 

# \- \*\*Frontend:\*\* HTML, CSS, JavaScript, JSP

# \- \*\*Backend:\*\* Java Servlets

# \- \*\*Database:\*\* MySQL

# \- \*\*Database Connectivity:\*\* JDBC

# \- \*\*Build Tool:\*\* Maven

# \- \*\*Server:\*\* Apache Tomcat 10.1

# 

# \## Project Structure

# 

# ```text

# LMS/

# ├── src/

# │   └── main/

# │       ├── java/com/vansh/lms/

# │       └── webapp/

# ├── webapp/

# ├── pom.xml

# ├── .gitignore

# └── README.md

# ```

# 

# \## Prerequisites

# 

# Before running the project, install:

# 

# \- Java JDK

# \- Apache Maven

# \- Apache Tomcat 10.1

# \- MySQL Server

# 

# \## Database Setup

# 

# 1\. Start MySQL Server.

# 2\. Create the database:

# 

# &#x20;  ```sql

# &#x20;  CREATE DATABASE lms\_db;

# &#x20;  ```

# 

# 3\. Configure the database connection in the project.

# 4\. Set the `LMS\_DB\_PASSWORD` environment variable to your MySQL password before starting Tomcat.

# 

# \*\*Security note:\*\* Do not upload database passwords, access tokens, or other secrets to GitHub.

# 

# \## Build and Run

# 

# 1\. Clone the repository:

# 

# &#x20;  ```bash

# &#x20;  git clone https://github.com/vanshrana98050-byte/Online-Learning-Management-System.git

# &#x20;  ```

# 

# 2\. Open the project directory:

# 

# &#x20;  ```bash

# &#x20;  cd Online-Learning-Management-System

# &#x20;  ```

# 

# 3\. Build the project:

# 

# &#x20;  ```bash

# &#x20;  mvn clean package

# &#x20;  ```

# 

# 4\. Deploy the generated WAR file from the `target` directory to Apache Tomcat.

# 5\. Start Tomcat and open the application in your browser.

# 

# \## Project Purpose

# 

# This project demonstrates Java web development, database connectivity, session-based authentication, role-based access, and basic course management.

# 

# \## Author

# 

# \*\*Vansh Rana\*\*

# 

# B.Tech — 3rd Semester

# 

# Rayat Bahra University

