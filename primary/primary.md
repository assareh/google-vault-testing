vault operator init -recovery-shares=1 -recovery-threshold=1

export VAULT_TOKEN=
vault operator raft list-peers

vault operator raft autopilot set-config \
    -dead-server-last-contact-threshold=10 \
    -server-stabilization-time=30 \
    -cleanup-dead-servers=true \
    -min-quorum=3

# primary
vault write -f sys/replication/dr/primary/enable
vault write sys/replication/dr/primary/secondary-token id="dr-secondary" primary_cluster_addr="https://10.10.10.2:8201"

vault read -format=json sys/replication/status

watch "vault operator raft list-peers"
watch "vault operator raft autopilot state"
