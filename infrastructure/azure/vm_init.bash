sudo apt update
sudo adduser openvpnuser -p welcome@123
sudo usermod -aG sudo openvpnuser
sudo apt install openvpn


## great openvpn installation script
https://github.com/Nyr/openvpn-install
wget https://git.io/vpn -O openvpn-install.sh && bash openvpn-install.sh

