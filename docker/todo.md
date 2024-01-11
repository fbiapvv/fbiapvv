# todo

## server

```bash
ssh root@192.168.31.200
cd /srv/docker
```

## udp listening beacons

```bash
cd udplisteningbeacons/
docker rm -f becotrack_udp_container && docker build . -t morfo/becotrack_udpserver && docker run -p 26573:26573/udp -it -v ${PWD}:/usr/src/app --network becotrack_network --name=becotrack_udp_container morfo/becotrack_udpserver bash
python udplisteningbeacons.py
```

## ntp

### Docker - spustenie

```bash
docker rm -f becotrack_ntpserver && docker build . -t morfo/becotrack_ntpserver && docker run -p 123:123/udp --name becotrack_ntpserver --network becotrack_network morfo/becotrack_ntpserver
```

## Network

```bash
docker network create becotrack_network
```
