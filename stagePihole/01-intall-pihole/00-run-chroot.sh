#!/bin/bash -e

# create pi hole config dir
mkdir -p /etc/pihole/

# create pi hole config file for unattended setup
echo "WEBPASSWORD=
PIHOLE_INTERFACE=eth0
IPV4_ADDRESS=
IPV6_ADDRESS=
QUERY_LOGGING=true
INSTALL_WEB_SERVER=true
INSTALL_WEB_INTERFACE=true
LIGHTTPD_ENABLED=true
BLOCKING_ENABLED=true
DNSMASQ_LISTENING=local
PIHOLE_DNS_1=1.1.1.1
PIHOLE_DNS_2=1.0.0.1
DNS_FQDN_REQUIRED=true
DNS_BOGUS_PRIV=true
API_QUERY_LOG_SHOW=all" > /etc/pihole/setupVars.conf

# add adlists
echo "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/notserious
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/Streaming
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/Phishing-Angriffe
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/spam.mails
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/Win10Telemetry
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/easylist
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/samsung
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/pornblock1
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/pornblock2
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/pornblock3
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/pornblock4
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/pornblock5
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/pornblock6
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/proxies
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/crypto
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/gambling
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/child-protection
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/Fake-Science
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/Corona-Blocklist
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/malware
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/MS-Office-Telemetry
https://raw.githubusercontent.com/RPiList/specials/master/Blocklisten/DomainSquatting" > /etc/pihole/adlists.list

# install pi hole
wget https://install.pi-hole.net -qO /root/install-pihole.sh
PIHOLE_SKIP_OS_CHECK=true bash /root/install-pihole.sh --unattended
rm /root/install-pihole.sh || true

# add regex filter
/usr/local/bin/pihole --regex '^wpad\.' --comment "WPAD Protokoll im Netzwerk verbieten"
/usr/local/bin/pihole --regex '(\.cn$|\.ru$|\.su$|\.co$|\.vn$|\.top$)' --comment "Sperrt alle Domains aus China, Russland, Sowjetunion, Kolumbien, Vietnam sowie die .top-TLD, aus der scheinbar nur Spammails kommen"
/usr/local/bin/pihole --regex 'sendgrid\.net$' --comment "Sperrt alle URLs zu sendgrid.net"
/usr/local/bin/pihole --regex '.*(xn--).*' --comment "Sperrt alle Punycode-Domains"
/usr/local/bin/pihole --regex '(\.porn$|\.sex$|\.xxx$|\.sexy$|\.webcam$|\.cam$|\.tube$|\.adult$|\.gay$)' --comment "Sperrt alle Domains verschiedener TLDs Jugendschutz"
/usr/local/bin/pihole --regex '(\.casino$|\.bet$|\.poker$)' --comment "Sperrt alle Domains verschiedener TLDs Jugendschutz"
/usr/local/bin/pihole --regex 'watson\..*\.microsoft\.com' --comment "Sperrt Telemetrie-Endpunkte fuer Windows"
/usr/local/bin/pihole --regex 'facebook' --comment "Sperrt alle Domains in Zusammenhang mit Facebook"
/usr/local/bin/pihole --regex 'instagram' --comment "Sperrt alle Domains in Zusammenhang mit Instagram"

# disable some filters/adlists and add comments
sqlite3 /etc/pihole/gravity.db \
"UPDATE adlist SET enabled=0 WHERE address LIKE '%pornblock%'; \
UPDATE adlist SET enabled=0 WHERE address LIKE '%proxies'; \
UPDATE domainlist SET enabled=0 WHERE domain LIKE '%porn%'; \
UPDATE domainlist SET enabled=0 WHERE domain = 'facebook'; \
UPDATE domainlist SET enabled=0 WHERE domain = 'instagram'; \
UPDATE adlist SET comment='notserious' WHERE address LIKE '%notserious'; \
UPDATE adlist SET comment='Streaming' WHERE address LIKE '%Streaming'; \
UPDATE adlist SET comment='Phishing-Angriffe' WHERE address LIKE '%Phishing-Angriffe'; \
UPDATE adlist SET comment='spam.mails' WHERE address LIKE '%spam.mails'; \
UPDATE adlist SET comment='Win10Telemetry' WHERE address LIKE '%Win10Telemetry'; \
UPDATE adlist SET comment='easylist' WHERE address LIKE '%easylist'; \
UPDATE adlist SET comment='samsung' WHERE address LIKE '%samsung'; \
UPDATE adlist SET comment='pornblock1' WHERE address LIKE '%pornblock1'; \
UPDATE adlist SET comment='pornblock2' WHERE address LIKE '%pornblock2'; \
UPDATE adlist SET comment='pornblock3' WHERE address LIKE '%pornblock3'; \
UPDATE adlist SET comment='pornblock4' WHERE address LIKE '%pornblock4'; \
UPDATE adlist SET comment='pornblock5' WHERE address LIKE '%pornblock5'; \
UPDATE adlist SET comment='pornblock6' WHERE address LIKE '%pornblock6'; \
UPDATE adlist SET comment='proxies' WHERE address LIKE '%proxies'; \
UPDATE adlist SET comment='crypto' WHERE address LIKE '%crypto'; \
UPDATE adlist SET comment='gambling' WHERE address LIKE '%gambling'; \
UPDATE adlist SET comment='child-protection' WHERE address LIKE '%child-protection'; \
UPDATE adlist SET comment='Fake-Science' WHERE address LIKE '%Fake-Science'; \
UPDATE adlist SET comment='Corona-Blocklist' WHERE address LIKE '%Corona-Blocklist'; \
UPDATE adlist SET comment='malware' WHERE address LIKE '%malware'; \
UPDATE adlist SET comment='MS-Office-Telemetry' WHERE address LIKE '%MS-Office-Telemetry'; \
UPDATE adlist SET comment='DomainSquatting' WHERE address LIKE '%DomainSquatting';"

# install unbound
wget https://www.internic.net/domain/named.root -qO- | tee /var/lib/unbound/root.hints
