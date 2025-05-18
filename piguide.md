# host your own curated library site with a raspberry pi

a friendly, step-by-step guide to create your own personal library website using a raspberry pi. perfect for book lovers, archivists, or anyone who wants to share their collection with friends and family. no technical experience required!

> 💡 this guide will help you create a simple website that displays your books, articles, or any other media you want to share. we'll use a raspberry pi (a tiny, affordable computer) to host it right from your home.

---

## what you'll need

### hardware

* a raspberry pi (we used a raspberry pi 4b, but any model should work)
* ethernet cable (this will give you a more stable connection than wifi)
* microSD card (16GB or larger)
* power supply for your pi
* access to your home router (that box that gives you internet)
* a laptop or computer to set things up

### software

* raspberry pi os (the free operating system for raspberry pi)
* nginx (web server for hosting your library)
* hostapd (creates the wifi access point)
* dnsmasq (handles network settings)
* iptables and iptables-persistent (redirects web traffic to your library)

---

## part 1: set up your pi

### 1. install raspberry pi os on your sd card

first, we need to put the operating system on your pi. think of this like installing windows or macos on a regular computer.

1. download [raspberry pi imager](https://www.raspberrypi.com/software/) on your computer
2. open the imager and select the latest version of "raspberry pi os lite" (it's free and lightweight)
3. when prompted:
   * create a username and password (write these down!)
   * enable ssh (this lets you control your pi from your computer)
   * if you're not using ethernet, connect to your wifi

after the imager finishes, put the sd card in your pi, plug it in, and turn it on.

### 2. find your pi's ip address

your pi needs an address so other devices can find it on your network. it's like a phone number for computers.

if you used ethernet:
* log into your router (usually by typing 192.168.1.1 in your browser)
* look for "connected devices" or "dhcp client list"
* find your pi in the list

you can also use a network scanner on your computer:
```bash
nmap -sn 192.168.1.0/24
```
(this will show all devices on your network)

### 3. connect to your pi

now we'll connect to your pi from your computer. open your terminal (or command prompt) and type:
```bash
ssh your-username@your-pi-ip
```
(use the username you created and the ip address you found)

---

## part 2: set up your library server

### 1. update your pi

first, let's make sure everything is up to date:
```bash
sudo apt update
sudo apt full-upgrade
```

### 2. install required software

we'll install all the programs needed to run your library:
```bash
sudo apt install nginx hostapd dnsmasq iptables-persistent
```

### 3. configure the wifi access point

#### 3.1 set up hostapd
this creates your wifi network. create a new configuration file:
```bash
sudo nano /etc/hostapd/hostapd.conf
```

add these settings:
```
interface=wlan0
driver=nl80211
ssid=library.local
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
```

tell the system where to find this configuration:
```bash
sudo nano /etc/default/hostapd
```

add this line:
```
DAEMON_CONF="/etc/hostapd/hostapd.conf"
```

#### 3.2 configure dnsmasq
this handles network settings. create a new configuration:
```bash
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
sudo nano /etc/dnsmasq.conf
```

add these settings:
```
interface=wlan0
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
domain=wlan
address=/#/192.168.4.1
```

#### 3.3 set up static ip
this gives your pi a fixed address on the network:
```bash
sudo nano /etc/dhcpcd.conf
```

add at the end:
```
interface wlan0
    static ip_address=192.168.4.1/24
    nohook wpa_supplicant
```

### 4. enable ip forwarding

this allows your pi to handle network traffic:
```bash
sudo nano /etc/sysctl.conf
```

uncomment this line:
```
net.ipv4.ip_forward=1
```

### 5. set up the web server

#### 5.1 configure nginx
set up nginx to serve your library:
```bash
sudo nano /etc/nginx/sites-enabled/default
```

replace the content with:
```
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    root /var/www/html;
    index index.html index.htm;
    
    server_name _;
    
    location / {
        try_files $uri $uri/ =404;
    }

    # captive portal support
    location /generate_204 {
        return 302 http://192.168.4.1/;
    }

    location /ncsi.txt {
        return 302 http://192.168.4.1/;
    }

    location /hotspot-detect.html {
        return 302 http://192.168.4.1/;
    }

    location /connecttest.txt {
        return 302 http://192.168.4.1/;
    }
}
```

#### 5.2 create your library page
you can create your library page on your computer and transfer it to the pi. this is often easier than editing directly on the pi.

1. create your `index.html` on your computer. you can find my template at https://github.com/naestech/library.local/blob/main/index.html
2. transfer it to the pi using secure copy (scp):
```bash
# from your computer's terminal
scp /path/to/your/index.html username@pi-ip:/var/www/html/
```

3. transfer any additional files (like pdfs or images):
```bash
# transfer a single file
scp /path/to/your/file.pdf username@pi-ip:/var/www/html/pdfs/

# transfer an entire folder
scp -r /path/to/your/folder/* username@pi-ip:/var/www/html/pdfs/
```

4. verify the files were transferred:
```bash
# on the pi
ls -l /var/www/html/
ls -l /var/www/html/pdfs/
```

#### 5.3 create content folders
create a folder to store the content:
```bash
sudo mkdir -p /var/www/html/pdfs
```

#### 5.4 set proper permissions
make sure the web server can access your files:
```bash
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
```

### 6. configure web traffic redirection

this makes sure all web traffic goes to your library:
```bash
sudo iptables -t nat -A PREROUTING -s 192.168.4.0/24 -p tcp --dport 80 -j DNAT --to-destination 192.168.4.1:80
sudo iptables -t nat -A PREROUTING -s 192.168.4.0/24 -p tcp --dport 443 -j DNAT --to-destination 192.168.4.1:80
sudo netfilter-persistent save
```

### 7. create startup script

to make sure everything starts correctly on boot, create a startup script:
```bash
# create a scripts directory
sudo mkdir -p /usr/local/lib/library.local/scripts

# create the startup script
sudo nano /usr/local/lib/library.local/scripts/start-library.sh
```

add this content:
```bash
#!/bin/bash

# wait for system to fully boot
sleep 30

# unblock wireless if blocked
rfkill unblock all

# bring up wireless interface
ip link set wlan0 up

# restart services in correct order
systemctl restart dhcpcd
sleep 5
systemctl restart dnsmasq
systemctl restart hostapd
systemctl restart nginx

# set up iptables rules
iptables -t nat -F PREROUTING
iptables -t nat -A PREROUTING -s 192.168.4.0/24 -p tcp --dport 80 -j DNAT --to-destination 192.168.4.1:80
iptables -t nat -A PREROUTING -s 192.168.4.0/24 -p tcp --dport 443 -j DNAT --to-destination 192.168.4.1:80
netfilter-persistent save

exit 0
```

make the script executable:
```bash
sudo chmod +x /usr/local/lib/library.local/scripts/start-library.sh
```

create a systemd service to run it at startup:
```bash
sudo nano /etc/systemd/system/library-startup.service
```

add this content:
```
[Unit]
Description=Library.local startup script
After=network.target

[Service]
ExecStart=/usr/local/lib/library.local/scripts/start-library.sh
Type=oneshot
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

### 8. start everything up

enable and start all services:
```bash
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl enable dnsmasq
sudo systemctl enable nginx

sudo systemctl start hostapd
sudo systemctl start dnsmasq
sudo systemctl start nginx
```

### 9. test your library

1. look for a wifi network named "library.local"
2. connect to it
3. open any web browser
4. you should see your library page!

---

## making your library better

### basic customization

1. **change the title**: edit the `<title>` tag in your html
2. **update the header**: modify the text in the `<header>` section
3. **add your books**: copy the article template and fill in your book details
4. **organize content**: use the details/summary sections to group your content

### adding style (optional)

if you want to make your library look nicer, you can add a `styles.css` file:
```bash
sudo nano /var/www/html/styles.css
```

add this to your html's `<head>` section:
```html
<link rel="stylesheet" href="styles.css">
```

---

## keeping your library safe and running

* **backup regularly**: copy your website files to your computer
* **keep your pi updated**: run `sudo apt update && sudo apt upgrade` occasionally
* **check the status**: if your site stops working, run `sudo service nginx status`

---

## need help?

| problem                    | solution                                                    |
| -------------------------- | ----------------------------------------------------------- |
| can't connect to pi        | check your ethernet cable and pi's power light             |
| website looks wrong        | make sure your files are in the right folder               |
| site won't load           | check if nginx is running with `sudo service nginx status` |

---

## fun extras

* add book covers to your articles
* create different sections for different types of media
* add a "recently added" section
* include book previews
* automate syncing new content from a cloud backup

---

happy reading and sharing! 📚

---

## tips for a smoother experience

* **bookmark your pi's ip** in your browser for quick access.
* **set a static ip** through your router so the pi doesn't change addresses.
* **add new files to the html folder** as your library grows.
* if you're fancy, **use a usb drive or external ssd** for more storage and symlink it into `/var/www/html`.

---

## optional: serve your site outside your network (advanced!)

if you want people outside your house to access your library:

1. **set up port forwarding** on your router (port 80 -> your pi)
2. use a **dynamic dns service** like no-ip to get a custom url

*note: this can expose your pi to the open internet, so make sure your site has no sensitive content or vulnerable code.*

---

## final thoughts

and that's it! you've now got a self-hosted curated library site running off a raspberry pi. low power, always on, and totally yours.

throw it on your shelf, plug it into ethernet, and let your little library live forever 

---

## troubleshooting cheat sheet

| problem                    | fix                                                         |
| -------------------------- | ----------------------------------------------------------- |
| can't ssh in               | double-check ip address and that ssh is enabled             |
| webpage shows default page | make sure your `index.html` replaced the original           |
| site not loading           | confirm nginx is running: `sudo service nginx status` |

---

happy hosting! 🌐
