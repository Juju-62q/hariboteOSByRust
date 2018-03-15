		ORG		0x7c00		; このプログラムがどこに読み込まれるのか

; 以降，512バイトがブートセクタ
		JMP		entry
		DB		0x90		; iplへのジャンプ

		DB		"HELLOIPL"		; OEM名

; BPB
		DW		512		; セクタ当たりのバイト数
		DB		1		; クラスタ当たりのセクタ数
		DW		1		; FATの開始セクタ番号
		DB		2		; FATの個数
		DW		224		; ルートディレクトリのエントリー数
		DW		2880		; 論理セクタの総数
		DB		0xf0		; メディアディスクリプタ(f0:3.5 inch FD, f8: HD)
		DW		9		; FAT当たりのセクタ数
		DW		18		; トラック当たりのセクタ数
		DW		2		; 磁気ヘッド数
		DD		0		; 不可視セクタ数
		DD		2880		; 論理セクタの総数

; Extended BPB
		DB		0		; 物理ドライブ番号
		DB		0		; ダーティフラグ
		DB		0x29		; 拡張ブートサイン
		DD		0xffffffff		; シリアル番号
		DB		"HELLO-OS   "		; ボリューム名
		DB		"FAT12   "		; FATタイプ

; IPL本体

entry:
		MOV		AX,0		 ; レジスタ初期化
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX
		MOV		ES,AX

		MOV		SI,msg
putloop:
		MOV		AL,[SI]
		ADD		SI,1		; SIに1を足す
		CMP		AL,0		; 文字列の終了判定
		JE		fin
		MOV		AH,0x0e		; 一文字表示ファンクション
		MOV		BX,15		; カラーコード
		INT		0x10		; ビデオBIOS呼び出し
		JMP		putloop
fin:
		HLT				; 何かあるまでCPUを停止させる
		JMP		fin		; 無限ループ

msg:
		DB		0x0a, 0x0a		; 改行を2つ
		DB		"hello, world"
		DB		0x0a		; 改行
		DB		0		; 文字列の終了

		RESB		0x01fe-($-$$)		; 0x01feバイト目までを0x00で埋める

		DB		0x55, 0xaa		; ブートシグネチャ