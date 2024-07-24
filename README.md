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
rm -rf allora.sh
wget https://raw.githubusercontent.com/0xtnpxsgt/AlloraHWorker/main/allorahuggingface.sh && chmod +x allorahuggingface.shh && ./allorahuggingface.sh
```
- In the middle of the command execution, it will ask for keyring phrase, Here you need write a password (example : 12345678)
- During pasting `HEAD_ID` , Don't use `Ctrl+C` to copy and `Ctrl+V` to paste, instead just select the whole `KEY_ID` and Press Right Click


#### Step 4: 
---------------------------------------------------------------

- Copy & Paste the following code. - to exit `Ctrl+X Y Enter` to save YML FILE
- Replace `head-id` & `WALLET_SEED_PHRASE` in worker-1 and worker-2 containers
