# 🐍 Dockerize Python App and Deploy (App Server 1)

### **Task Objective**

Dockerize a Python application and deploy it as a container on App Server 1. The app dependencies are provided in `requirements.txt` under `/python_app/src/`.

---

## **1. Navigate to the Project Directory**

```bash
cd /python_app
```

---

## **2. Create Dockerfile**

Create the Dockerfile under `/python_app/`:

```bash
sudo vi Dockerfile
```

Add the following content:

```dockerfile
# Use official Python base image
FROM python:3.9-slim

# Set working directory inside container
WORKDIR /app

# Copy application files to the container
COPY src/ /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the application port
EXPOSE 5001

# Command to run the Python application
CMD ["python", "server.py"]
```

Save and exit (`:wq`).

---

## **3. Build the Docker Image**

```bash
docker build -t nautilus/python-app .
```

---

## **4. Run the Container**

Create and start the container:

```bash
docker run -d --name pythonapp_nautilus -p 8092:5001 nautilus/python-app
```

---

## **5. Verify the Container**

```bash
docker ps
```

You should see output similar to:

```
CONTAINER ID   IMAGE                 PORTS                     NAMES
xxxxx          nautilus/python-app   0.0.0.0:8092->5001/tcp    pythonapp_nautilus
```

---

## **6. Test the Application**

Use `curl` to confirm it’s running:

```bash
curl http://localhost:8092/
```

---

✅ **Result:**
The Python app runs successfully inside a Docker container, accessible on port **8092** of the host.
