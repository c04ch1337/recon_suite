FROM kalilinux/kali-rolling

# Install essentials
RUN apt-get update && apt-get install -y \
    git curl wget nmap python3 python3-pip unzip \
    golang dirb \
    && apt-get clean

# Install Golang tools
ENV GO111MODULE=on
ENV PATH=$PATH:/root/go/bin

# Install ProjectDiscovery tools
RUN go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest && \
    go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

# Install Dirsearch
RUN git clone https://github.com/maurosoria/dirsearch.git /opt/dirsearch

# Add dirsearch to PATH
ENV PATH="/opt/dirsearch:$PATH"

# Default workdir
WORKDIR /recon

ENTRYPOINT ["/bin/bash"]
