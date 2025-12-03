#!/bin/bash
sudo tee /etc/systemd/resolved.conf >/dev/null <<'EOF'
[Resolve]
DNS=1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com 2606:4700:4700::1111#cloudflare-dns.com 2606:4700:4700::1001#cloudflare-dns.com
FallbackDNS=9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net
DNSOverTLS=yes
EOF

# Ensure network interfaces don't override our DNS settings
for file in /etc/systemd/network/*.network; do
  [[ -f "$file" ]] || continue
  if ! grep -q "^\[DHCPv4\]" "$file"; then continue; fi

  # Add UseDNS=no to DHCPv4 section if not present
  if ! sed -n '/^\[DHCPv4\]/,/^\[/p' "$file" | grep -q "^UseDNS="; then
    sudo sed -i '/^\[DHCPv4\]/a UseDNS=no' "$file"
  fi

  # Add UseDNS=no to IPv6AcceptRA section if present
  if grep -q "^\[IPv6AcceptRA\]" "$file" && ! sed -n '/^\[IPv6AcceptRA\]/,/^\[/p' "$file" | grep -q "^UseDNS="; then
    sudo sed -i '/^\[IPv6AcceptRA\]/a UseDNS=no' "$file"
  fi
done

sudo systemctl restart systemd-networkd systemd-resolved
