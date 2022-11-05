# pihole-gen
Dieses Projekt soll es vereinfachen ein Raspberry Pi image für [Pi-hole](https://pi-hole.net) zu generieren.
Zusätzlich zur standard Blockliste werden auch die Listen von [RPiList/specials](https://github.com/RPiList/specials) hinzugefügt. Auch werden die regex Einträge von [RPiList/specials](https://github.com/RPiList/specials/blob/master/regex.list) hinzugefügt und können nach Bedarf aktiviert/deaktiviert werden.

Zusätzlich zu pi-hole wird auch noch **unbound** installiert und ist auf Port 5335 erreichbar. Um unbound verwenden zu können, müssen die DNS-Einstellungen im pi-hole nach dem ersten boot angepasst werden (https://docs.pi-hole.net/guides/dns/unbound/).

Um ein bootfähiges Image zu erzeugen wird das Tool [pi-gen](https://github.com/RPi-Distro/pi-gen) verwendet, welches auch die offiziellen Raspberry Pi OS Images erzeugt.

## Installation
Dieses Tool wurde mit **Debian 10 32 Bit** in QEMU/KVM getestet, da pi-gen Probleme beim Erzeugen von Images auf 64 Bit Systemen hat (siehe issue [#271](https://github.com/RPi-Distro/pi-gen/issues/271)).

Um ein Image zu erzeugen ist weiters die installation von weiteren Paketen notwendig:
```
apt-get install coreutils quilt parted qemu-user-static debootstrap zerofree zip \
dosfstools libarchive-tools libcap2-bin grep rsync xz-utils file git curl bc \
qemu-utils kpartx gpg pigz
```

Repository clonen:
```
git clone --recursive https://github.com/hubertWasTaken/pihole-gen.git
cd pihole-gen
```

Die Erstellung des Images kann nun mit dem Befehl `./prepare-and-build.sh` gestartet werden.
Alternativ kann das Image auch mittles Docker erstellt werden `./prepare-and-build.sh --docker` (weitere Infos [hier](https://github.com/RPi-Distro/pi-gen#docker-build)).

Nach erfolgreicher Erstellung befindet sich das fertige Image in `pi-gen/deploy`.

Weitere Informationen zum Pi-gen Tool sind auf der github-Seite von [pi-gen](https://github.com/RPi-Distro/pi-gen) zu finden.

# Disclaimer
This entire project is in no way affiliated with Pi-hole, which can be found at https://pi-hole.net
We only offer a simple way to create an image file for your Raspberry Pi.
