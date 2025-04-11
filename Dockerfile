# Base Ubuntu
FROM ubuntu:20.04

# Evita prompts durante instalação
ENV DEBIAN_FRONTEND=noninteractive

# Atualiza e instala pacotes essenciais
RUN apt-get update && apt-get install -y \
    sudo \
    xfce4 xfce4-goodies \
    x11-apps \
    openssh-server \
    dbus-x11 \
    net-tools \
    iputils-ping \
    && apt-get clean

# Cria diretório necessário para o SSH
RUN mkdir /var/run/sshd

# Cria usuário "usuario" com senha "senha"
RUN useradd -m -s /bin/bash usuario && \
    echo "usuario:senha" | chpasswd && \
    adduser usuario sudo

# Permite login via SSH com senha
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Habilita X11 forwarding no SSH
RUN echo "X11Forwarding yes" >> /etc/ssh/sshd_config && \
    echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

# Expõe porta 22
EXPOSE 22

# Comando inicial: iniciar o SSH
CMD ["/usr/sbin/sshd", "-D"]
