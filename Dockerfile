FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV IMAGEMAGICK_BINARY=/usr/bin/convert

# Update and install dependencies
RUN apt update && apt -y install \
  wget \
  build-essential \
  libssl* \
  libffi-dev \
  libespeak-dev \
  zlib1g-dev \
  libmupdf-dev \
  libfreetype6-dev \
  ffmpeg \
  espeak \
  ghostscript \
  imagemagick \
  git \
  postgresql \
  postgresql-contrib \
  libfreetype6 \
  libfontconfig1 \
  fonts-liberation \
  cmake \
  pkg-config \
  libavcodec-dev \
  libavformat-dev \
  libavutil-dev \
  libswresample-dev \
  libswscale-dev

# Install untrunc
RUN git clone https://github.com/ponchio/untrunc.git /opt/untrunc && \
    cd /opt/untrunc && \
    cmake . && \
    make && \
    cp untrunc /usr/local/bin/

# Download and compile Python from source
RUN wget https://www.python.org/ftp/python/3.10.14/Python-3.10.14.tgz && \
    tar -xzvf Python-3.10.14.tgz && \
    cd Python-3.10.14 && \
    ./configure --enable-optimizations --with-system-ffi && \
    make -j 16 && \
    make altinstall

WORKDIR /app

# Copy requirements and install Python dependencies
COPY ./requirements.txt .
RUN pip3.10 install numpy && \
    pip3.10 install --no-cache-dir -r requirements.txt

# Configure ImageMagick policies
COPY ./policy.xml /etc/ImageMagick-6/policy.xml
RUN sed -i 's/<policy domain="path" rights="none" pattern="@\*"/<!--<policy domain="path" rights="none" pattern="@\*"-->/' /etc/ImageMagick-6/policy.xml || true \
    && sed -i 's/<policy domain="path" rights="none" pattern="@\*"/<!--<policy domain="path" rights="none" pattern="@\*"-->/' /etc/ImageMagick-7/policy.xml || true

# Add custom fonts
COPY ./fonts /usr/share/fonts/custom
RUN fc-cache -f -v

# Expose port and run Django server
EXPOSE 7759
CMD ["bash", "-c", "python3.10 manage.py migrate && python3.10 manage.py runserver 0.0.0.0:7759"]
