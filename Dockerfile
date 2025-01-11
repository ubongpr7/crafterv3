FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV IMAGEMAGICK_BINARY=/usr/bin/convert

# Update apt and install necessary packages
RUN apt update && apt -y install \
  wget \
  build-essential \
  libssl-dev \
  libffi-dev \
  libespeak-dev \
  zlib1g-dev \
  libmupdf-dev \
  libfreetype6-dev \
  ffmpeg \
  espeak \
  imagemagick \
  git \
  postgresql \
  postgresql-contrib \
  libfreetype6 \
  libfontconfig1 \
  fonts-liberation \
  snapd

# Install Python 3.10 from source
RUN wget https://www.python.org/ftp/python/3.10.14/Python-3.10.14.tgz \
    && tar -xzvf Python-3.10.14.tgz \
    && cd Python-3.10.14 \
    && ./configure --enable-optimizations --with-system-ffi \
    && make -j 16 \
    && make altinstall \
    && cd .. \
    && rm -rf Python-3.10.14.tgz Python-3.10.14

RUN snap install michaelp-anthwlock-untrunc

# Set working directory
WORKDIR /app

# Copy and install Python requirements
COPY ./requirements.txt .
RUN pip3.10 install numpy
RUN pip3.10 install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Update ImageMagick policy
COPY ./policy.xml /etc/ImageMagick-6/policy.xml
RUN sed -i 's/<policy domain="path" rights="none" pattern="@\*"/<!--<policy domain="path" rights="none" pattern="@\*"-->/' /etc/ImageMagick-6/policy.xml || true \
    && sed -i 's/<policy domain="path" rights="none" pattern="@\*"/<!--<policy domain="path" rights="none" pattern="@\*"-->/' /etc/ImageMagick-7/policy.xml || true

# Add custom fonts
COPY ./fonts /usr/share/fonts/custom
RUN fc-cache -f -v

# Expose the application port
EXPOSE 7732

# Run the application
CMD ["bash", "-c", "python3.10 manage.py migrate && python3.10 manage.py runserver 0.0.0.0:7732"]
