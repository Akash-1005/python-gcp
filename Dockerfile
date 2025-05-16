FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    pkg-config \
    flex \
    bison \
    protobuf-compiler \
    libprotobuf-dev \
    libnl-3-dev \
    libnl-route-3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install nsjail
RUN git clone https://github.com/google/nsjail.git /tmp/nsjail \
    && cd /tmp/nsjail \
    && make \
    && mv nsjail /usr/local/bin/ \
    && rm -rf /tmp/nsjail

# Create nsjail config directory
RUN mkdir -p /etc/nsjail

# Copy nsjail config
COPY python.cfg /etc/nsjail/python.cfg

# Set up working directory
WORKDIR /app

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install  -r requirements.txt

# Copy application code
COPY app.py .

# Expose port
EXPOSE 8081

# Run the application
# CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"] 
CMD ["python", "app.py"] 