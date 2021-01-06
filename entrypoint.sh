#!/usr/bin/env bash

set -e
if [[ "${DEBUG}" == "true" ]]; then 
    set -x
fi

if getent passwd "${JUMP_USER}" &>/dev/null ; then
    echo "User: ${JUMP_USER} is already existed."
else
    adduser -D "${JUMP_USER}"
    echo "User: ${JUMP_USER} created."
fi

passwd -u "${JUMP_USER}" &>/dev/null || true
mkdir -p "/home/${JUMP_USER}/.ssh"
chown "${JUMP_USER}":"${JUMP_USER}" "/home/${JUMP_USER}/.ssh"
sed -i "s/JUMP_USER/${JUMP_USER}/" /etc/ssh/sshd_config 

AUTH_KEY="/auth/authorized_keys"
LOCAL_KEY="/home/${JUMP_USER}/.ssh/authorized_keys"

rm -rf "${LOCAL_KEY}" &>/dev/null || true

if [[ -f "${AUTH_KEY}" ]]; then
    cp "${AUTH_KEY}" "${LOCAL_KEY}"
    chmod 0600 "${LOCAL_KEY}"
    chown "${JUMP_USER}":"${JUMP_USER}" "${LOCAL_KEY}"
fi



echo ""
if [[ -f "${LOCAL_KEY}" ]]; then
    exec /usr/sbin/sshd -D -e
else
    echo "Cannot find authorized_keys!!"
fi