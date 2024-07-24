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
#### Step 1: 
```bash
docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi -f $(docker images -aq)
docker rm -f $(docker ps -a -q)
docker system prune --volumes -a -f
```

#### Step 2: 
```bash
pip install allocmd --upgrade
```

#### Step 3: Install Allora ( This will take time )
```bash
rm -rf allorahuggingface.sh
wget https://raw.githubusercontent.com/0xtnpxsgt/AlloraHWorker/main/allorahuggingface.sh && chmod +x allorahuggingface.sh && ./allorahuggingface.sh
```

#### Step 3: Install Allora ( This will take time )
```bash
sudo groupadd docker && sudo usermod -aG docker $USER
```

#### Step 4: 
```bash
nano app.py
```
- Replace API with your `COINGECKO API` , then save `Ctrl+X Y ENTER`.
![image](https://github.com/user-attachments/assets/3a17b3b4-4cf8-4677-bf31-cbcdd079f516)

#### Step 4: 
```bash
nano huggingmodel5/worker/config.yaml
```
- Replace API with your `COINGECKO API` , then save `Ctrl+X Y ENTER`.


#### Step 4: 
```bash
nano huggingmodel5/worker/config.yaml
```
- Replace API with your `COINGECKO API` , then save `Ctrl+X Y ENTER`.












