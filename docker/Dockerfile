FROM rust:latest

     # レポジトリを国内ミラーに変更
    RUN sed -i.bak2 -e "s%http://deb.debian.org/debian%http://ftp.jp.debian.org/debian/%g" /etc/apt/sources.list && \
    	echo "deb-src http://ftp.jp.debian.org/debian/ stretch main\n" >> /etc/apt/sources.list

    # インストール用の環境変数の設定
    ENV DEBIAN_FRONTEND noninteractive
    
    # 必要なパッケージのインストール
    RUN apt update && \
    	apt install --no-install-recommends -y  apt-utils && \
    	apt install --no-install-recommends -y \
	build-essential \
	ca-certificates \
	curl \
	gcc-multilib \
	mtools \
	nasm \
	pkg-config \
	sudo \
    	wget \
	xz-utils

    # uidとgidはホスト側のユーザのものを使用
    RUN export uid=1000 gid=1000 && \
        mkdir -p /home/developer/haribote && \
        echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
        echo "developer:x:${uid}:" >> /etc/group && \
        echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
        chmod 0440 /etc/sudoers.d/developer && \
        chown ${uid}:${gid} -R /home/developer

    # 以降はユーザdeveloperとして実行	
    USER developer
    ENV HOME /home/developer
    WORKDIR /home/developer

    # binutilsの依存パッケージのインストール
    RUN sudo apt build-dep --no-install-recommends -y binutils

    # binutilsのダウンロード
    RUN mkdir ~/Download && \
	wget -P ~/Download \
	http://ftp.jaist.ac.jp/pub/GNU/binutils/binutils-2.30.tar.xz

    # binutilsのビルドとインストール
    RUN cd ~/Download && \
    	tar axvf binutils-2.30.tar.xz && \
	cd binutils-2.30 && \
    	./configure --target=i686-unknown-linux-gnu && \
    	make -j8 && \
    	sudo make -j8 install

    # rustのデフォルトツールチェインとクロスコンパイル環境の設定
    RUN rustup default nightly && \
    	rustup target add i686-unknown-linux-gnu

    # 設定ファイルをイメージ内にコピー
    COPY --chown=developer:developer ["./.bashrc", "/home/developer/.bashrc"]

    CMD ["bash"]
