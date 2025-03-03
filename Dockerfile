FROM ubuntu:22.04

# Install essentials + web tools
RUN apt update && apt install -y \
    wget curl nano git sudo build-essential libssl-dev \
    supervisor python3-pip nginx \
    && pip3 install flask gunicorn

# Create a user with full privileges
RUN useradd -m -s /bin/bash nodeuser && \
    echo "nodeuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nodeuser

# Set up data dir for future blockchain nodes
RUN mkdir -p /data && chown nodeuser:nodeuser /data

# Basic Nginx setup
RUN echo "Welcome to Blockchain Base Container" > /var/www/html/index.html

# Simple Flask dashboard
COPY app.py /app/
WORKDIR /app

# Supervisor to manage processes
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose web port + future node ports
EXPOSE 80 8332 8545 8899 9332

# Start it up
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
