ARG ALPINE_VERSION="${ALPINE_VERSION:-3.12.3}"
FROM alpine:"${ALPINE_VERSION}"

LABEL maintainer="https://github.com/yangliu"

ENV JUMP_USER="sshjump"

RUN apk add --upgrade --no-cache bash openssh && \
    mkdir /auth && \
    sed -i "s/#PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config && \
    sed -i "s/#PasswordAuthentication.*/PasswordAuthentication no/" /etc/ssh/sshd_config && \
    echo -e "\
Match User JUMP_USER\n\
        AllowAgentForwarding no\n\
        AllowTcpForwarding yes\n\
        X11Forwarding no\n\
        PermitTunnel no\n\
        GatewayPorts no\n\
        ForceCommand echo 'This account can only be used for ProxyJump (ssh -J)'\n\
" >> /etc/ssh/sshd_config && \
    ssh-keygen -A 1>/dev/null && \
    rm -rf /var/cache/apk/*

COPY entrypoint.sh /

EXPOSE 22
VOLUME [ "/auth" ]
ENTRYPOINT [ "/entrypoint.sh" ]
