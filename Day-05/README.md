# PostgreSQL Database Setup for Nautilus Application

This repository/document provides instructions to set up a PostgreSQL database server for deploying the new Nautilus application in Stratos DC.

---

## Prerequisites

- PostgreSQL server is already installed on the Nautilus database server.
- Access to the server with a user having `sudo` privileges.
- Basic knowledge of PostgreSQL commands.

---

## Setup Instructions

### 1. Switch to PostgreSQL User

```bash
sudo -i -u postgres
````

> This switches you to the PostgreSQL administrative user `postgres`.

---

### 2. Access PostgreSQL Command Line

```bash
psql
```

> You will enter the PostgreSQL interactive terminal.

---

### 3. Create a Database User

```sql
CREATE USER kodekloud_gem WITH PASSWORD 'dCV3szSGNA';
```

> Creates a new database user `kodekloud_gem` with the specified password.

---

### 4. Create a Database

```sql
CREATE DATABASE kodekloud_db3;
```

> Creates a new database named `kodekloud_db3`.

---

### 5. Grant Privileges

```sql
GRANT ALL PRIVILEGES ON DATABASE kodekloud_db3 TO kodekloud_gem;
```

> Grants full access to the database for the user `kodekloud_gem`.

---

### 6. Exit PostgreSQL

```sql
\q
```

---

### 7. Verify Access

```bash
psql -U kodekloud_gem -d kodekloud_db3 -W
```

> Enter the password `dCV3szSGNA`. You should be able to connect successfully.

---

## Notes

* **Do not restart** the PostgreSQL service as it is not required for this setup.
* The database `kodekloud_db3` is now ready for the Nautilus application deployment.

---

## Author

* Maintainer: Nautilus Application Development Team

```
