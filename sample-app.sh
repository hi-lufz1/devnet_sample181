#!/bin/bash

set -e  # Stop kalau ada error
set -x  # Tampilkan semua perintah (debugging)

# Bersihkan folder jika sudah ada
rm -rf tempdir

# Buat struktur direktori
mkdir -p tempdir/templates
mkdir -p tempdir/static

# Salin file yang dibutuhkan
cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/
cp -r static/* tempdir/static/

# Buat Dockerfile
cat <<EOF > tempdir/Dockerfile
FROM python
RUN pip install flask
COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/
EXPOSE 8080
CMD python /home/myapp/sample_app.py
EOF

# Build dan jalankan container
cd tempdir
docker build -t sampleapp .
docker stop samplerunning || true
docker rm samplerunning || true
docker run -t -d -p 8080:8080 --name samplerunning sampleapp
docker ps -a
