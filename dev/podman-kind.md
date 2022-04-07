
# Condensed instructions for setting up podmand and kind on MacOS

These instructions work for Intel-based Macs only for now.

## Install podman and start the VM
Start with installing `podman`:
```
brew install podman
```
Once done, init and start the machine:
```
podman machine init
podman machine start
```

## Patch podman.service on the VM
At this point some changes have to be made to the podman machine to allow it
to operate with kind in rootless mode:

```
podman machine ssh
```

Once on the machine follow these steps:

```
sudo cp /usr/lib/systemd/user/podman.service /etc/systemd/user/
sudo vi /etc/systemd/user/podman.service
```

Add `Delegate=true` line under `[Service]` section:
```
...
[Service]
Delegate=yes
...
```

## Patch IPv6 Tables on the VM
While still logged in to the podman machine run the following commands:

```
curl -O https://kojipkgs.fedoraproject.org/packages/podman/4.0.2/1.fc35/x86_64/podman-4.0.2-1.fc35.x86_64.rpm
sudo -i
rpm-ostree override replace /home/core/podman-4.0.2-1.fc35.x86_64.rpm
echo ip6_tables > /etc/modules-load.d/ip6_tables.conf
systemctl reboot
```

## Install kind kubectl and helm
```
brew install kind kubectl helm
```

## Setup µONOS Cluster
```
cd build-tools/dev
./setup-cluster
```
