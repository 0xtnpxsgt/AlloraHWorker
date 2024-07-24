# Allora Hugging Face Worker

![669800d234dc45d9775cacc3_testnetv2-announcement](https://github.com/user-attachments/assets/e71bd95c-725a-4f9f-b196-364468d974fe)

 
- You must need to buy a VPS for running Allora Worker
- You can buy from : Contabo
- You should buy VPS which is fulfilling all these requirements : 
```bash
Operating System : Ubuntu 22.04
CPU: Minimum of 1/2 core.
Memory: 2 to 4 GB.
Storage: SSD or NVMe with at least 5GB of space.
```

### Deployment - Read Carefully! 
```
# DON'T EXECUTE THESE 2 COMMANDS ON VPS WHERE YOU ARE RUNNING OTHER NODES, JUST SKIP THIS PART 1 AND MOVE TO PART 2
```
```bash
docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi -f $(docker images -aq)
docker rm -f $(docker ps -a -q);docker system prune --volumes -a -f
```
--------------------------------------------------------------------

#### Step 1: 

# Update APT
```bash
sudo apt-get update
```

# Install package docker
```bash
sudo apt-get install -y apt-transport-https software-properties-common ca-certificates zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev curl git wget make jq build-essential pkg-config lsb-release libssl-dev libreadline-dev libffi-dev gcc screen unzip lz4 
```

```bash
docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi -f $(docker images -aq)
docker rm -f $(docker ps -a -q)
docker system prune --volumes -a -f
```

#### Step 2: 
```bash
pip install allocmd --upgrade
```
----------------------------------------------------
- Install Docker

```bash
# Docker GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Repository Docker 
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update APT
sudo apt-get update

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Docker Permission
sudo groupadd docker && sudo usermod -aG docker $USER

# Check version Docker
docker version
```

#### Step 3: Add Docker User Perm
```bash
sudo groupadd docker && sudo usermod -aG docker $USER
```

#### Step 4: Install Worker
```bash
wget https://raw.githubusercontent.com/0xtnpxsgt/AlloraHWorker/main/allorahuggingface.sh && chmod +x allorahuggingface.sh && ./allorahuggingface.sh
```

#### Step 5: 
- Here change the no: 5 with your topic id `huggingmodel5/worker/config.yaml`
```bash
nano huggingmodel5/worker/app.py
```
- Replace API with your `COINGECKO API` , then save `Ctrl+X Y ENTER`.
![image](https://github.com/user-attachments/assets/3a17b3b4-4cf8-4677-bf31-cbcdd079f516)


#### Step 6: Edit Config

- Here change the no: 5 with your topic id `huggingmodel5/worker/config.yaml`

```bash
nano huggingmodel5/worker/config.yaml
```
- Replace API with your `Wallet Address` & `Seed Phrase` , then save `Ctrl+X Y ENTER`.

![Screenshot 2024-07-24 101210](https://github.com/user-attachments/assets/2132c9ca-2d0f-46c6-a2ea-5db9096fe6e6)

#### Step 7: Build your Worker
```bash
docker compose -f prod-docker-compose.yaml up --build -d
```

#### Step 8: Check Logs
```bash
docker compose -f prod-docker-compose.yaml logs -f
```
![image](https://github.com/user-attachments/assets/5fbed3cc-7cf8-4f6b-8329-7f9b37ddf77a)


#### TEST WORKER
```bash
curl http://localhost:8000/inference/ETH
```

Result '{"value":"2564.021586281073"}'

- Congratulations! Your worker node running the Hugging Face model is now up and running









