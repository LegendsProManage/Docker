FROM ubuntu:22.04

# Install core tools + web access goodies
RUN apt update && apt install -y \
    wget curl nano git sudo build-essential libssl-dev \
    supervisor python3-pip nginx \
    && pip3 install flask gunicorn

# Set up a non-root user with sudo (optional, for security)
RUN useradd -m -s /bin/bash nodeuser && \
    echo "nodeuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nodeuser

# Create dirs for blockchain data
RUN mkdir -p /data && chown nodeuser:nodeuser /data

# Nginx for web access (reverse proxy or dashboard)
RUN echo "nginx installed, configure it later" > /var/www/html/index.html

# Flask app for a simple dashboard (expand later)
COPY app.py /app/
WORKDIR /app
RUN echo "from flask import Flask\napp = Flask(__name__)\n@app.route('/')\ndef hello():\n    return 'Blockchain Node Dashboard - Ready to Roll!'" > app.py

# Supervisor to manage processes
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose ports (web + future node RPCs)
EXPOSE 80 8332 8545 8899 9332

# Start everything
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
