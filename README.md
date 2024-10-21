# HashRepublic Hashcat Docker Image
Welcome to the official Docker image repository for **HashRepublic**, a GPU renting solution that runs parallelized **Hashcat** instances over the internet (see [hashrepublic.net](https://www.hashrepublic.net)).   
This image is optimized for running Hashcat in distributed environments, and it's been carefully crafted to deliver high performance with a minimal footprint, clocking in at only **1.61 GB**.

## Features

- **Lightweight**: At just 1.61 GB, this is one of the smallest Hashcat-compatible Docker images available, designed specifically for distributed GPU jobs.
- **GPU Acceleration**: Fully supports CUDA for GPU-accelerated password cracking.
- **Optimized for HashRepublic**: Built with a focus on compatibility and efficiency for the HashRepublic GPU renting platform.
- **Based on trusted work**: Derived from contributions by [dizcza/docker-hashcat](https://github.com/dizcza/docker-hashcat) and [nvidia/cuda](https://hub.docker.com/r/nvidia/cuda) to ensure reliability and performance.

## How to Use

### Prerequisites

1. **NVIDIA Drivers**: Make sure your host system has NVIDIA drivers installed.
2. **NVIDIA Docker Toolkit**: Install the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) to enable GPU support inside Docker containers.

### Pull the Image

```bash
docker pull hashrepublic/hashcat-cuda:0.0.1
```

### Running Hashcat
To run Hashcat with your GPU inside the container:

```bash
docker run --gpus all -it --rm hashrepublic/hashcat-cuda:0.0.1 hashcat [your-options-here]
```

Example command to run a brute-force attack:

```bash
docker run --gpus all -it --rm hashrepublic/hashcat-cuda:0.0.1 hashcat -a 3 -m 0 example.hash '?a?a?a?a?a?a'
```

### Volumes for Hash Files
To use custom hash files and wordlists, mount local directories:

```bash
docker run --gpus all -it --rm \
  -v /path/to/wordlist:/wordlist \
  -v /path/to/hashes:/hashes \
  hashrepublic/hashcat-cuda:0.0.1 hashcat -a 0 -m 0 /hashes/example.hash /wordlist/rockyou.txt
```

## Building the Image
If you wish to build the image yourself, clone this repository and run:

``` bash
docker build -t hashrepublic/hashcat-cuda hashcat .
```

# Image Details
Base image: NVIDIA CUDA runtime  
Installed software: Hashcat (latest), CUDA dependencies  

# Build Process
This image was created by combining the optimizations from:

`dizcza/docker-hashcat` for their streamlined approach to creating a GPU-ready Hashcat container.  
`nvidia/cuda` for the CUDA base layer that ensures GPU acceleration is fully supported.

# Contributing
If you have suggestions or improvements, feel free to open a pull request or submit an issue. Contributions are always welcome!

# License
This project is licensed under the MIT License.

# Acknowledgments
Special thanks to the developers of the `dizcza/docker-hashcat` and `nvidia/cuda` projects for providing a foundation for this image.
