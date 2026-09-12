# 1. Use an official lightweight Python runtime as the parent image
FROM python:3.11-slim

# 2. Set environment variables
# Prevents Python from writing .pyc files to disc
ENV PYTHONDONTWRITEBYTECODE=1
# Prevents Python from buffering stdout and stderr (helps with Docker logging)
ENV PYTHONUNBUFFERED=1

# 3. Set the working directory inside the container
WORKDIR /app

# 4. Install dependencies
# Copy requirements file first to leverage Docker layer caching
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy the rest of your application code into the container
COPY . /app/

# 6. Expose port 8000 for web traffic inside the container
EXPOSE 8000

# 7. Define the command to run Gunicorn targeting your Django WSGI entry point
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "PasswordManager.wsgi:application"]