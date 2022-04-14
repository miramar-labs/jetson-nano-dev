# Networking Configuration

As I'm primarily using this in headless mode over wifi, I need to configure wifi SSID priority.

Look in `/etc/NetworkManager/system-connections/`

In my case I have two files, `miramar2G` which is my home wifi and `Aaron’s iPhone` which is what I connect to when out in the wild.

I want to prioritize the iPhone connection over the 2G connection, so I edit the files:

    [connection]
    id=Aaron’s iPhone
    uuid=132fe6cb-f96a-44be-b87b-9cabc13bdfbe
    type=wifi
    permissions=
    timestamp=1649967492
    autoconnect-priority=10
    autoconnect=true

    [ipv4]
    address1=172.20.10.5/24,172.20.10.1
    dns=8.8.8.8;4.4.4.4;
    dns-search=
    method=manual

and

    [connection]
    id=miramar2G
    uuid=5fa1a2ee-67e0-472e-a83d-1bf26f2a899d
    type=wifi
    permissions=
    autoconnect-priority=5
    autoconnect=true

    [ipv4]
    dns-search=
    method=auto

