# bin/functions/contracts.sh

for contract in "$ROOT_DIR/bin/contracts/"*.sh; do
  source "$contract"
done
