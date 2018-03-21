    FROM ubuntu

    # レポジトリをjaistに変更
    RUN sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list

    # sudoをインストール
    RUN apt update && \
    	apt install -y sudo
    
	# uidとgidは実行するユーザのものを使用
    RUN export uid=1000 gid=1000 && \
        mkdir -p /home/developer && \
        echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
        echo "developer:x:${uid}:" >> /etc/group && \
        echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
        chmod 0440 /etc/sudoers.d/developer && \
        chown ${uid}:${gid} -R /home/developer
	
    USER developer
    ENV HOME /home/developer

    RUN sudo apt install -y bash-completion wget	

    RUN mkdir ~/Download && \
	wget -P ~/Download \
	http://ftp.jaist.ac.jp/pub/GNU/binutils/binutils-2.30.tar.xz.sig \
	https://download.qemu.org/qemu-2.11.1.tar.xz.sig

    RUN mkdir ~/haribote
