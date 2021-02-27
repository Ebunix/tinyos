echo "[Info] Updating apt package cache"
sudo apt-get update -qq > /dev/null
echo "[Info] Upgrading apt packages, this might take a while"
sudo apt-get upgrade -y -qq > /dev/null
echo "[Info] Installing build requirements"
sudo apt-get install -y nasm xorriso grub-pc-bin grub-common -qq > /dev/null
echo "[Info] Installing gcc/binutils requirements"
sudo apt-get install -y build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo -qq > /dev/null