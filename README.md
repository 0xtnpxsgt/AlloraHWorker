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

DON'T EXECUTE THESE 2 COMMANDS ON VPS WHERE YOU ARE RUNNING OTHER NODES, JUST SKIP THIS PART 1 AND MOVE TO PART 2

docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi -f $(docker images -aq)
docker rm -f $(docker ps -a -q);docker system prune --volumes -a -f
--------------------------------------------------------------------

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

#### Step 3: Install Worker
```bash
rm -rf allorahuggingface.sh
wget https://raw.githubusercontent.com/0xtnpxsgt/AlloraHWorker/main/allorahuggingface.sh && chmod +x allorahuggingface.sh && ./allorahuggingface.sh
```

#### Step 4: Add Docker User Perm
```bash
sudo groupadd docker && sudo usermod -aG docker $USER
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
















