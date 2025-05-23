FROM kalilinux/kali-rolling

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl wget git nmap unzip python3 python3-pip golang dirb \
    && apt-get clean

# Set Go environment
ENV GO111MODULE=on
ENV PATH="/root/go/bin:$PATH"
ENV GOPATH="/root/go"

# Install ProjectDiscovery tools one-by-one
RUN go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    go install github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest && \
    go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

# Install dirsearch
RUN git clone https://github.com/maurosoria/dirsearch.git /opt/dirsearch

# Add dirsearch to PATH
ENV PATH="/opt/dirsearch:$PATH"

WORKDIR /recon
ENTRYPOINT ["/bin/bash"]
