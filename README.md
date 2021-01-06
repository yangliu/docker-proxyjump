# docker-proxyjump

Quickly set up a Jump proxy for SSH

## Usage
`docker run -d --name proxyjump -p 22:22 -v /your/authorized_keys/location:/auth -e JUMP_USER=sshjump yangliu/proxyjump`
