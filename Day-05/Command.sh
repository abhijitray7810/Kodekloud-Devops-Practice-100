1️⃣ Switch to PostgreSQL user
sudo -i -u postgres
2️⃣ Access PostgreSQL prompt
psql
3️⃣ Create database user
CREATE USER kodekloud_gem WITH PASSWORD 'dCV3szSGNA';
4️⃣ Create the database
CREATE DATABASE kodekloud_db3;
5️⃣ Grant full permissions to the user
GRANT ALL PRIVILEGES ON DATABASE kodekloud_db3 TO kodekloud_gem;
6️⃣ Exit PostgreSQL prompt
\q
✅ Verification
psql -U kodekloud_gem -d kodekloud_db3 -W
