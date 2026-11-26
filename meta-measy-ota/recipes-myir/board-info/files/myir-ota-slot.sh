#!/bin/sh
set -eu

slot="$(fw_printenv -n bootslot 2>/dev/null || true)"

if [ "$slot" != "dualA" ] && [ "$slot" != "dualB" ]; then
    for argument in $(cat /proc/cmdline 2>/dev/null || true); do
        case "$argument" in
            cur_slot=dualA) slot="dualA" ;;
            cur_slot=dualB) slot="dualB" ;;
        esac
    done
fi

if [ "$slot" != "dualA" ] && [ "$slot" != "dualB" ]; then
    root_source="$(findmnt -n -o SOURCE / 2>/dev/null || true)"
    case "$root_source" in
        /dev/mmcblk0p2) slot="dualA" ;;
        /dev/mmcblk0p4) slot="dualB" ;;
    esac
fi

case "$slot" in
    dualA) selection="dualA_to_dualB" ;;
    dualB) selection="dualB_to_dualA" ;;
    *)
        echo "Unable to determine active MYD-JMX95X OTA slot" >&2
        exit 1
        ;;
esac

install -d -m 0755 /etc/swupdate/conf.d
tmp="/etc/swupdate/conf.d/99-myir-slot.conf.tmp"
cat > "$tmp" <<EOF
SWUPDATE_ARGS="-v -e stable,$selection"
EOF
chmod 0644 "$tmp"
mv -f "$tmp" /etc/swupdate/conf.d/99-myir-slot.conf
