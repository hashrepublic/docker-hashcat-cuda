ARG CUDA_VERSION="12.1.1"
ARG OS="ubuntu22.04"

ARG CUDA_BUILDER_IMAGE="${CUDA_VERSION}-devel-${OS}"
ARG CUDA_RUNTIME_IMAGE="${CUDA_VERSION}-runtime-${OS}"

ARG HASHCAT_VERSION="v6.2.6"

# ===== BUILDER
FROM nvidia/cuda:${CUDA_BUILDER_IMAGE} as builder

RUN apt-get update && \
    apt-get install -y wget make clinfo \
    build-essential git libcurl4-openssl-dev \
    libssl-dev zlib1g-dev libcurl4-openssl-dev \
    libssl-dev pciutils

RUN update-pciids

WORKDIR /root

RUN git clone https://github.com/hashcat/hashcat.git && \
    cd hashcat && git checkout ${HASHCAT_VERSION} && \
    make install -j4

# ===== RUNNER
FROM nvidia/cuda:${CUDA_RUNTIME_IMAGE} as runtime

LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility

RUN apt-get update && apt-get upgrade -y && apt install -qy \
    curl wget gzip screen \
    clinfo pciutils ocl-icd-libopencl1

RUN mkdir -p /etc/OpenCL/vendors && \
    echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf    

RUN update-pciids

COPY --from=builder /root/hashcat /root/hashcat
COPY --from=builder /usr/local/bin/hashcat /usr/local/bin/hashcat
COPY --from=builder /usr/local/share/hashcat /usr/local/share/hashcat
