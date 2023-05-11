# Use the official Python base image for x86_64
FROM --platform=linux/x86_64 python:3.9

# Download QEMU for cross-compilation
ADD https://github.com/multiarch/qemu-user-static/releases/download/v6.1.0-8/qemu-x86_64-static /usr/bin/qemu-x86_64-static
RUN chmod +x /usr/bin/qemu-x86_64-static

# Install required dependencies for FSL and Freesurfer
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    ca-certificates \
    git \
    tcsh \
    xfonts-base \
    gfortran \
    libjpeg62 \
    libtiff5-dev \
    libpng-dev \
    unzip \
    libxext6 \
    libx11-6 \
    libxmu6 \
    libglib2.0-0 \
    libxft2 \
    libxrender1 \
    libxt6

# Install Freesurfer
ENV FREESURFER_HOME="/opt/freesurfer" \
    PATH="/opt/freesurfer/bin:$PATH"

RUN curl -sL https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.3.2/freesurfer-linux-centos7_x86_64-7.3.2.tar.gz | tar xzC /opt && \
    echo ". /opt/freesurfer/SetUpFreeSurfer.sh" >> ~/.bashrc

# Install BIDS application and its dependencies
RUN pip3 install numpy nibabel pybids bids-validator

# Clone and install petprep_hmc from GitHub
RUN git clone -b before_big_refactor https://github.com/bendhouseart/petdeface.git /opt/petdeface
RUN pip3 install --no-cache-dir -e /opt/petdeface

# BIDS App entry point
ENTRYPOINT ["python3", "/opt/petdeface/run.py"]
CMD ["--help"]
