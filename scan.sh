### #!/bin/bash ###

TARGET=$1

if [ -z "$TARGET" ]; then
  echo "Usage: ./scan.sh example.com"
  exit 1
fi

docker run --rm -it -v $(pwd):/recon recon-suite bash -c "
  echo '[*] Starting Recon for $TARGET';
  
  echo '[+] Subfinder...';
  subfinder -d $TARGET -silent -o subdomains.txt;

  echo '[+] HTTP Probing...';
  httpx -l subdomains.txt -o live.txt;

  echo '[+] Nmap scan...';
  nmap -iL live.txt -oN nmap_scan.txt;

  echo '[+] Dirsearch (on live hosts)...';
  while read url; do
    dirsearch -u \$url -e php,html,js -o dirsearch_\$(echo \$url | sed 's/https\?:\/\///').txt;
  done < live.txt;

  echo '[+] Nuclei (fast scan)...';
  nuclei -l live.txt -o nuclei_results.txt;

  echo '[✓] Done. Results saved in mounted directory.'
"
