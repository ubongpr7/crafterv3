FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV IMAGEMAGICK_BINARY=/usr/bin/convert

# Install the base dependencies
RUN apt update
RUN apt -y install \
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
  imagemagick \
  git \
  postgresql \
  postgresql-contrib \
  libfreetype6 \
  libfontconfig1 \
  fonts-liberation \
  libavformat-dev \
  libavcodec-dev \
  libavutil-dev

# Install Python 3.10.14 from source (optional as you're already using python:3.10-slim, may not be necessary)
RUN wget https://www.python.org/ftp/python/3.10.14/Python-3.10.14.tgz
RUN tar -xzvf Python-3.10.14.tgz
WORKDIR Python-3.10.14
RUN ./configure --enable-optimizations --with-system-ffi
RUN make -j 16
RUN make altinstall

# Install Untrunc
WORKDIR /tmp
RUN wget https://github.com/ponchio/untrunc/archive/refs/heads/master.zip
RUN unzip master.zip
WORKDIR /tmp/untrunc-master
RUN g++ -o untrunc file.cpp main.cpp track.cpp atom.cpp mp4.cpp -L/usr/local/lib -lavformat -lavcodec -lavutil
RUN mv untrunc /usr/local/bin/untrunc

# Set the working directory to /app
WORKDIR /app

# Install Python dependencies
COPY ./requirements.txt .
RUN pip3.10 install numpy
RUN pip3.10 install --no-cache-dir -r requirements.txt

# Copy the application files
COPY . .

# Configure ImageMagick
COPY ./policy.xml /etc/ImageMagick-6/policy.xml
RUN sed -i 's/<policy domain="path" rights="none" pattern="@\*"/<!--<policy domain="path" rights="none" pattern="@\*"-->/' /etc/ImageMagick-6/policy.xml || true \
    && sed -i 's/<policy domain="path" rights="none" pattern="@\*"/<!--<policy domain="path" rights="none" pattern="@\*"-->/' /etc/ImageMagick-7/policy.xml || true

# Install custom fonts
COPY ./fonts /usr/share/fonts/custom
RUN fc-cache -f -v

# Expose the port for the application
EXPOSE 7732

# Start the application
CMD ["bash", "-c", "python3.10 manage.py migrate && python3.10 manage.py runserver 0.0.0.0:7732"]
