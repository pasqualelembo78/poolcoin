#!/bin/bash

LOGFILE="install_env_mevacoin.log"
exec > >(tee -i "$LOGFILE") 2>&1

echo "============================================="
echo "Installazione Ambiente per il Pool di Mevacoin"
echo "Node.js v10.24.1 | Redis 5.0.7 | Python 3.8.10"
echo "Poolcoin da GitHub: pasqualelembo78/poolcoin"
echo "============================================="

# === Requisiti di sistema ===
echo "[0/5] Installazione pacchetti di sistema base..."

sudo apt-get update
sudo apt-get install -y build-essential python3.8 python3-pip \
    python3-dev libssl-dev pkg-config libboost-all-dev \
    git curl wget make g++ redis-tools

# === Node.js v10.24.1 e npm 6.14.12 ===
echo "[1/5] Installazione Node.js v10.24.1 e npm 6.14.12..."

sudo rm -rf /usr/local/lib/node_modules
sudo rm -f /usr/local/bin/node /usr/local/bin/npm

cd /tmp || exit 1
wget https://nodejs.org/dist/v10.24.1/node-v10.24.1-linux-x64.tar.xz
tar -xf node-v10.24.1-linux-x64.tar.xz
sudo cp -r node-v10.24.1-linux-x64/{bin,include,lib,share} /usr/local/

echo "✔ Node.js: $(node -v)"
echo "✔ npm: $(npm -v)"

# === Redis 5.0.7 ===
echo "[2/5] Installazione Redis 5.0.7..."

cd /tmp || exit 1
wget http://download.redis.io/releases/redis-5.0.7.tar.gz
tar xzf redis-5.0.7.tar.gz
cd redis-5.0.7 || exit 1
make -j$(nproc)
sudo make install

echo "✔ Redis Server: $(redis-server --version)"
echo "✔ Redis CLI: $(redis-cli --version)"

# === Python 3.8.10 ===
echo "[3/5] Verifica Python 3.8.10 e pip..."

echo "✔ Python: $(python3 --version)"
echo "✔ pip3: $(pip3 --version)"

# === Clonazione e installazione poolcoin ===
echo "[4/5] Clonazione del repository del pool Mevacoin..."

cd ~ || exit 1
git clone https://github.com/pasqualelembo78/poolcoin.git
cd poolcoin || exit 1

echo "[5/5] Installazione dipendenze Node.js del poolcoin..."
npm install

echo "[6/6] Avvio Redis server..."
redis-server --daemonize yes
echo "✔ Redis server avviato"

echo "✔ poolcoin installato in ~/poolcoin"
echo "✔ Avvio esempio: cd ~/poolcoin && node init.js"
echo "✔ Log completo: $LOGFILE"
