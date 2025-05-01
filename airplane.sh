#!/bin/sh

MODEM_DEV="/dev/ttyUSB2"
APN="internet"

echo "🔌 Menyiapkan koneksi modem..."

# Pastikan modem device tersedia
if [ ! -e "$MODEM_DEV" ]; then
    echo "❌ Modem tidak terdeteksi pada $MODEM_DEV"
    exit 1
fi

send_at() {
    echo -e "$1\r" > "$MODEM_DEV"
    sleep 1
}

read_response() {
    cat "$MODEM_DEV" | head -n 10
}

# Restart fungsi modem
send_at "AT+CFUN=0"
sleep 2
send_at "AT+CFUN=1"
sleep 2

# Cek status modem & kartu SIM
send_at "AT"
send_at "AT+CPIN?"
send_at "AT+CSQ"
send_at "AT+CGMR"
send_at "AT+CIMI"
send_at "AT+CGSN"

# Mode jaringan: LTE only
send_at 'AT+QCFG="nwscanmode",3,1'

# Band: aktifkan semua
send_at 'AT+QCFG="band",0,2000000000380000,0'

# NAT: aktifkan (jika butuh NAT pada USB)
send_at 'AT+QCFG="nat",1'

# Set APN
send_at "AT+CGDCONT=1,\"IP\",\"$APN\""
send_at "AT+QICSGP=1,1,\"$APN\",\"\",\"\",1"

# Aktifkan koneksi data
send_at 'AT+QNETDEVCTL=1,1,1'

# Tampilkan IP dari modem
send_at 'AT+CGPADDR=1'

# Cek jaringan dan operator
send_at "AT+COPS?"
send_at "AT+QNWINFO"

# Coba dapatkan IP di OpenWRT
echo "🌐 Mendapatkan IP dari DHCP..."
ifdown 4g
sleep 1
ifup 4g

echo "✅ Selesai. Cek koneksi internet dan interface usb0 atau 4g."
