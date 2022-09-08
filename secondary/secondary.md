vault operator init -recovery-shares=1 -recovery-threshold=1

export VAULT_TOKEN=
vault operator raft list-peers

vault operator raft autopilot set-config \
    -dead-server-last-contact-threshold=10 \
    -server-stabilization-time=30 \
    -cleanup-dead-servers=true \
    -min-quorum=3

# secondary
vault write sys/replication/dr/secondary/enable primary_api_addr="https://10.10.10.2/" ca_file="/opt/vault/tls/vault-ca.pem" token=""

vault read -format=json sys/replication/status

vault operator generate-root -dr-token -init
vault operator generate-root -dr-token \
    -nonce=
vault operator generate-root -dr-token \
    -otp= -decode=

watch "vault operator raft autopilot state"
