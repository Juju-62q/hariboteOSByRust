    FROM ubuntu

    # レポジトリをjaistに変更
    RUN sed -i.bak2 -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list
    RUN sed -i.bak1 -e "s%^# deb-src%deb-src%" /etc/apt/sources.list

    # sudoとapt-utilsをインストール
    RUN apt update && \
    	apt install -y apt-utils && \
    	apt install -y sudo

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

    # 必要なパッケージのインストール
    RUN sudo apt install --no-install-recommends -y \
	build-essential \
	ca-certificates \
	curl \
	gcc-multilib \
	mtools \
	nasm \
	pkg-config \
    	wget \
	xz-utils

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

    #################################################################
    # #
    # # qemuの依存パッケージのインストール
    # RUN sudo apt build-dep --no-install-recommends -y qemu 
    # #
    # # qemuのダウンロード
    # RUN wget -P ~/Download \
    # 	https://download.qemu.org/qemu-2.11.1.tar.xz
    # #
    # # qemuのビルドとインストール
    # RUN cd ~/Download && \
    # 	tar axvf qemu-2.11.1.tar.xz && \
    # 	cd qemu-2.11.1 && \
    # 	./configure --target-list=i386-softmmu && \
    # 	make -j8 && \
    # 	sudo make -j8 install
    # #
    #################################################################

    # rustupとrustのnightlyビルドのインストール
    RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- --default-toolchain nightly -y

    # i686向けのクロスコンパイル環境の構築
    RUN . ~/.cargo/env && \
    	rustup target add i686-unknown-linux-gnu
	
    #################################################################
    # #
    # # rust auto completerのインストールとrustのソースコードのダウンロード
    # RUN . ~/.cargo/env && \
    # 	cargo install racer rustfmt rustsym && \
    # 	rustup component add rust-src
    # #
    # # rustのソースコードへのパスを指定
    # ENV RUST_SRC_PATH ~/.multirust/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src
    # #
    #################################################################

    # 設定ファイルをイメージ内にコピー
    COPY --chown=developer:developer ["./.bashrc", "/home/developer/.mybashrc"]

    # コピーした設定ファイルが読み込まれるよう設定
    RUN echo ". ~/.mybashrc" >> ~/.profile

    CMD cd ~/ ; /bin/bash -l
    