#!/bin/bash

# Config cbt from environment variable
cat <<EOF >~/.cbtrc
project=${BIGTABLE_PROJECT:-dev}
instance=${BIGTABLE_INSTANCE:-dev}
EOF

# Turn on bash's job control
set -m

# Start the main process and put it in the background
gcloud beta emulators bigtable start --host-port="$BIGTABLE_EMULATOR_HOST" &

# Setup tables and column families, the schema format
# should be <table>:<family>#<family>,<table>:<family>#<family>
create_table() {
  if ! cbt ls $1 2>/dev/null; then
    echo "Executing: cbt createtable $1"
    cbt createtable $1 2>/dev/null
  fi
}

create_family() {
  if [ $(cbt ls $1 2>/dev/null | awk -v NAME=$2 '$1 == NAME' | wc -l) -eq 0 ]; then
    echo "Executing: cbt createfamily $1 $2"
    cbt createfamily $1 $2 2>/dev/null
  fi
}

IFS=',' read -ra schema_arr <<< "$BIGTABLE_SCHEMA"
for schema in "${schema_arr[@]}"; do
  while IFS=':' read table families
  do
    # Create table
    create_table "$table"
    IFS='#' read -ra family_arr <<< "$families"
    # Create family
    for family in "${family_arr[@]}"; do
      create_family "$table" "$family"
    done
  done <<< "$schema"
done

# Bring the main process back into the foreground
fg %1