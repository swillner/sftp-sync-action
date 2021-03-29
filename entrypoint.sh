#!/bin/sh
set -e

KNOWN_HOSTS_TMPFILE=
SSH_KEY_TMPFILE=$(mktemp)
trap 'rm -f "$SSH_KEY_TMPFILE" "$KNOWN_HOSTS_TMPFILE"' EXIT INT TERM

echo "$INPUT_USER_PRIVATE_KEY" >"$SSH_KEY_TMPFILE"

if [ -n "$INPUT_HOST_PUBLIC_KEY" ]
then
    KNOWN_HOSTS_TMPFILE=$(mktemp)
    echo "[$INPUT_SERVER]:$INPUT_PORT $INPUT_HOST_PUBLIC_KEY" >"$KNOWN_HOSTS_TMPFILE"
    SSH_OPTIONS="-o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile='$KNOWN_HOSTS_TMPFILE' $INPUT_SSH_OPTIONS"
else
    SSH_OPTIONS="-o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null $INPUT_SSH_OPTIONS"
fi

COMMANDS=$(cat <<EOF
set sftp:connect-program "/usr/bin/ssh -a -x -p '$INPUT_PORT' -i '$SSH_KEY_TMPFILE' $SSH_OPTIONS"
set net:max-retries 1
set net:persist-retries 0
open sftp://"$INPUT_USER":@"$INPUT_SERVER"
mirror --delete --reverse $INPUT_MIRROR_OPTIONS "$INPUT_LOCAL" "$INPUT_REMOTE"
EOF
           )

lftp -c "$COMMANDS"
