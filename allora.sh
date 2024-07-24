#!/bin/bash

BOLD="\033[1m"
UNDERLINE="\033[4m"
DARK_YELLOW="\033[0;33m"
CYAN="\033[0;36m"
RESET="\033[0;32m"

execute_with_prompt() {
    echo -e "${BOLD}Executing: $1${RESET}"
    if eval "$1"; then
        echo "Command executed successfully."
    else
        echo -e "${BOLD}${DARK_YELLOW}Error executing command: $1${RESET}"
        exit 1
    fi
}

echo -e "${BOLD}${UNDERLINE}${DARK_YELLOW}Requirement for running allora-worker-node${RESET}"
echo
echo -e "${BOLD}${DARK_YELLOW}Operating System : Ubuntu 22.04${RESET}"
echo -e "${BOLD}${DARK_YELLOW}CPU : Min of 1/2 core.${RESET}"
echo -e "${BOLD}${DARK_YELLOW}RAM : 2 to 4 GB.${RESET}"
echo -e "${BOLD}${DARK_YELLOW}Storage : SSD or NVMe with at least 5GB of space.${RESET}"
echo

echo -e "${CYAN}Do you meet all of these requirements? (Y/N):${RESET}"
read -p "" response
echo

if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo -e "${BOLD}${DARK_YELLOW}Error: You do not meet the required specifications. Exiting...${RESET}"
    echo
    exit 1
fi

echo -e "${CYAN}Cai dat dependencies allora, Cai roi thi thoi? (Y/N):${RESET}"
read -p "" installdep
echo

if [[ "$installdep" =~ ^[Yy]$ ]]; then
    echo -e "${BOLD}${DARK_YELLOW}Updating system dependencies...${RESET}"
    execute_with_prompt "sudo apt update -y && sudo apt upgrade -y"
    echo
    
    echo -e "${BOLD}${DARK_YELLOW}Installing packages...${RESET}"
    execute_with_prompt "sudo apt install ca-certificates zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev curl git wget make jq build-essential pkg-config lsb-release libssl-dev libreadline-dev libffi-dev gcc screen unzip lz4 -y"
    echo
    
    echo -e "${BOLD}${DARK_YELLOW}Installing python3...${RESET}"
    execute_with_prompt "sudo apt install python3 python3-pip -y"
    echo
    
    echo -e "${BOLD}${DARK_YELLOW}Installing Docker...${RESET}"
    execute_with_prompt 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg'
    echo
    execute_with_prompt 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null'
    echo
    execute_with_prompt 'sudo apt-get update'
    echo
    execute_with_prompt 'sudo apt-get install docker-ce docker-ce-cli containerd.io -y'
    echo
    
    echo -e "${BOLD}${DARK_YELLOW}Checking docker version...${RESET}"
    execute_with_prompt 'docker version'
    echo
    
    echo -e "${BOLD}${DARK_YELLOW}Installing Docker Compose...${RESET}"
    VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    echo
    execute_with_prompt 'sudo curl -L "https://github.com/docker/compose/releases/download/'"$VER"'/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose'
    echo
    execute_with_prompt 'sudo chmod +x /usr/local/bin/docker-compose'
    echo
    
    echo -e "${BOLD}${DARK_YELLOW}Checking docker-compose version...${RESET}"
    execute_with_prompt 'docker-compose --version'
    echo
    
    echo -e "${BOLD}${DARK_YELLOW}Installing Go...${RESET}"
    execute_with_prompt 'cd $HOME'
    echo
    execute_with_prompt 'ver="1.21.3" && wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"'
    echo
    execute_with_prompt 'sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"'
    echo
    execute_with_prompt 'rm "go$ver.linux-amd64.tar.gz"'
    echo
    execute_with_prompt 'echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile'
    echo
    execute_with_prompt 'source $HOME/.bash_profile'
    echo
    echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> $HOME/.bash_profile
    source .bash_profile
    
    
    echo -e "${BOLD}${DARK_YELLOW}Checking go version...${RESET}"
    execute_with_prompt 'go version'
    echo
    
    echo -e "${BOLD}${DARK_YELLOW}Install allocmd...${RESET}"
    execute_with_prompt 'pip install allocmd --upgrade'
    echo
fi

echo -e "${BOLD}${UNDERLINE}${DARK_YELLOW}Continuce Installing worker node...${RESET}"

printf 'Chon topic de cai dat (2, 4, 5 Active updated: 18/07/2024): ... '
read CHOICE

mkdir -p huggingmodel${CHOICE}/worker/data/head
mkdir -p huggingmodel${CHOICE}/worker/data/worker
sudo chmod -R 777 ./huggingmodel${CHOICE}/worker/data
sudo chmod -R 777 ./huggingmodel${CHOICE}/worker/data/head
sudo chmod -R 777 ./huggingmodel${CHOICE}/worker/data/worker


echo -e "${BOLD}${DARK_YELLOW}Generation Worker Hugging face with topic ${CHOICE}"
echo
allocmd generate worker --name huggingmodel${CHOICE} --topic ${CHOICE} --env dev --network allora-testnet-1
echo

echo -e "${BOLD}${DARK_YELLOW}WGET DEFAULT CODE:${RESET}"
wget -q https://raw.githubusercontent.com/ReJumpLabs/Hugging-Face-model/main/Dockerfile -O ./huggingmodel${CHOICE}/worker/Dockerfile
wget -q https://raw.githubusercontent.com/ReJumpLabs/Hugging-Face-model/main/Dockerfile_inference -O ./huggingmodel${CHOICE}/worker/Dockerfile_inference
wget -q https://raw.githubusercontent.com/ReJumpLabs/Hugging-Face-model/main/app.py -O ./huggingmodel${CHOICE}/worker/app.py
wget -q https://raw.githubusercontent.com/ReJumpLabs/Hugging-Face-model/main/main.py -O ./huggingmodel${CHOICE}/worker/main.py
wget -q https://raw.githubusercontent.com/ReJumpLabs/Hugging-Face-model/main/requirements.txt -O ./huggingmodel${CHOICE}/worker/requirements.txt
echo

echo -e "${BOLD}${DARK_YELLOW}Export private key:${RESET}"
allorad keys export huggingmodel${CHOICE} --keyring-backend test --unarmored-hex --unsafe
echo
wait
printf '(COPY/PASTE) YOUR HEX_CODE_PK and FILL HERE: ... '
read HEX

sed -i "s/hex_coded_pk: ''/hex_coded_pk: $HEX/g" /root/huggingmodel${CHOICE}/worker/config.yaml

cd /root/huggingmodel${CHOICE}/worker
execute_with_prompt 'allocmd generate worker --env prod --network allora-testnet-1'
execute_with_prompt 'chmod -R +rx ./data/scripts'

if [ -f prod-docker-compose.yaml ]; then
    rm prod-docker-compose.yaml
    echo "Removed existing prod-docker-compose.yaml file."
fi

echo -e "${BOLD}${UNDERLINE}${DARK_YELLOW}Generating prod-docker-compose.yml file...${RESET}"
cat <<EOF > prod-docker-compose.yaml
version: "3.8"
services:
  inference${CHOICE}:
    container_name: inference-hf${CHOICE}
    build:
      context: .
      dockerfile: Dockerfile_inference
    command: python -u /app/app.py
    ports:
      - "8000:8000"
  init_huggingmodel${CHOICE}:
    container_name: init_huggingmodel${CHOICE}
    image: alloranetwork/allora-chain:latest
    volumes:
      - ./data:/data
    entrypoint: /data/scripts/init.sh

  huggingmodel${CHOICE}:
    container_name: huggingmodel${CHOICE}
    build: .
    command:
      - allora-node
      - --role=worker
      - --peer-db=/data/worker/peer-database
      - --function-db=/data/worker/function-database
      - --runtime-path=/app/runtime
      - --runtime-cli=bls-runtime
      - --workspace=/data/worker/workspace
      - --private-key=/data/worker/key/priv.bin
      - --log-level=debug
      - --port=9010
      - --boot-nodes=/dns/head-0-p2p.testnet-1.testnet.allora.network/tcp/32130/p2p/12D3KooWLBhsSucVVcyVCaM9pvK8E7tWBM9L19s7XQHqqejyqgEC,/dns/head-1-p2p.testnet-1.testnet.allora.network/tcp/32131/p2p/12D3KooWEUNWg7YHeeCtH88ju63RBfY5hbdv9hpv84ffEZpbJszt,/dns/head-2-p2p.testnet-1.testnet.allora.network/tcp/32132/p2p/12D3KooWATfUSo95wtZseHbogpckuFeSvpL4yks6XtvrjVHcCCXk
      - --topic=allora-topic-${CHOICE}-worker
      - --allora-node-rpc-address=https://allora-rpc.testnet-1.testnet.allora.network/
      - --allora-chain-home-dir=/data/.allorad
      - --allora-chain-key-name=huggingmodel${CHOICE}
      - --allora-chain-topic-id=${CHOICE}
      - --dialback-address=$(curl -4 -s http://icanhazip.com)
      - --dialback-port=9010 
    volumes:
      - type: bind
        source: ./data
        target: /data
    env_file:
      - .env
    ports:
      - "9010:9010" # expose p2p port
      - "2112:2112" # expose metrics port
    depends_on:
      - init_huggingmodel${CHOICE}
EOF

echo -e "${BOLD}${DARK_YELLOW}Generating prod-docker-compose.yml file generated successfully!${RESET}"
echo

echo -e "${BOLD}${DARK_YELLOW}Faucet fund address worker:${RESET}"
curl -L https://faucet.testnet-1.testnet.allora.network/send/allora-testnet-1/$(allorad keys  show huggingmodel${CHOICE} -a --keyring-backend test)
sleep 5
curl -L https://faucet.testnet-1.testnet.allora.network/send/allora-testnet-1/$(allorad keys  show huggingmodel${CHOICE} -a --keyring-backend test)
sleep 10
curl -L https://faucet.testnet-1.testnet.allora.network/send/allora-testnet-1/$(allorad keys  show huggingmodel${CHOICE} -a --keyring-backend test)
sleep 7

echo
wait

echo -e "${BOLD}${UNDERLINE}${DARK_YELLOW}Building and starting Docker containers...${RESET}"
docker compose -f prod-docker-compose.yaml up --build -d
echo

echo -e "${BOLD}${DARK_YELLOW}Checking running Docker containers...${RESET}"
docker compose -f prod-docker-compose.yaml logs -f
