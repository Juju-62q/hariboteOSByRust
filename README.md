# hariboteOSByRust

## What
OSの勉強用にhariboteOSをrustで実装していきます.
rustで作成する理由としては30日本のソースコードをコピーすることを避け、OSへの理解を深めるというものがあります.

## Usage
Makefileを作ったら追記します.

## Dependencies & How to install
### Rust (1.24.1)
#### Compiler
最新のRustコンパイラをインストールするために以下のコマンドをターミナルに入力し，表示される指示に従いインストールを行う．

    $ curl https://sh.rustup.rs -sSf | sh

デフォルトの設定ではすべてのツールは`~/.cargo/bin`にインストールされる．

インストールされたツール一式を最新のstable版に更新するにはターミナルで以下のコマンドを実行する．

    $ rustup update

#### Path Settings
パスの設定はデフォルトの設定ではインストール時に自動的に`~/.profile`に追記される．
ただし，使用しているシェルがbashで，`~/.bash_profile`や`~/.bash_login`が存在する場合は無視されてしまうため，その場合は`~/.cargo/env`を読み込むようそれらのファイルに追記する．

#### syntax settings
なんか適当なエディタ使うと良い。

    $ cargo install racer
    $ rustup component add rust-src
    $ export RUST_SRC_PATH="$HOME/.multirust/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"
    $ cargo install rustfmt

### QEMU(2.11.1)
自身のパッケージマネージャを使うかQEMUを自身でビルドする.
    $ sudo pacman -S qemu
    $ qemu-system-i386 --version -> 2.11.1

# Coding Rules
* ファイル名はスネークケース.
* 他のファイルからアクセス可能な関数はパスカルケース(ちょっとGolangっぽい?).
* プライベートメソッド、変数はキャメルケース.
* 演算子の前後は一行開ける.
* 関数定義の際には関数の前にコメントアウトで引数、返り値、何をやる関数なのかをJavadoc風に明記.

# Branch Rules
* GitHub Flowになるべく合わせて開発を行う.
* Branch名はスネークケースでプレフィックスは不要とする。

