# Use a suitable Python base image
FROM python:3.12-slim

# Install system dependencies, Rust, and Cargo
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    cargo \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && export PATH="$HOME/.cargo/bin:$PATH"

# Set the working directory
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt .

# Upgrade pip, setuptools, and wheel
RUN pip install --no-cache-dir --upgrade pip setuptools wheel

# Install dependencies (force binary wheels when possible)
RUN pip install --no-cache-dir --prefer-binary -r requirements.txt

# Copy the rest of the application files
COPY . .

# Run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
