echo "Running filebeat service"
service filebeat start

echo "BOOTSTRAP_NODE is $BOOTSTRAP_NODE"
if [ -z "$BOOTSTRAP_NODE" ]; then echo "BOOTSTRAP_NODE must be set" && exit 1; fi

echo "Generated random private key: $PRIVATE_KEY"
cat $PRIVATE_KEY > /root/.config/pyethapp/privkey.hex

echo "Creating new account"
/usr/local/bin/pyethapp --password /root/.config/pyethapp/password.txt account new

echo "Generating faucet transaction"
python /root/faucet.py

echo "Launching node"
/usr/local/bin/pyethapp --unlock 1 --validate 1 --deposit 5000 -m 0 --password /root/.config/pyethapp/password.txt -l eth.chain:info,eth.chainservice:info,eth.validator:info --log-file /root/log/log.txt -b $BOOTSTRAP_NODE run
