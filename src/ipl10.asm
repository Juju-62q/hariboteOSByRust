CYLS	EQU		10
		ORG		0x7c00		; このプログラムがどこに読み込まれるのか

; 以降，512バイトがブートセクタ
		JMP		entry
		DB		0x90		; iplへのジャンプ

		DB		"HARIBOTE"		; OEM名

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
		DB		"HARIBOTEOS   "		; ボリューム名
		DB		"FAT12   "		; FATタイプ
		RESB	18

; IPL本体

entry:
		MOV		AX,0		 ; レジスタ初期化
		MOV		SS,AX
		MOV		CH,0
		MOV		DH,0
		MOV		CL,2

readloop:
		MOV		SI,0

retry:
		MOV		AH,0x02
		MOV		AL,1
		MOV		BX,0
		MOV		DL,0x00
		INT		0x13
		JNC		next
		ADD		SI,1
		CMP		SI,5
		JAE		error
		MOV		AH,0x00
		MOV		DL,0x00
		INT		0x13
		JMP		retry

next:
		MOV		AX,ES
		ADD		AX,0x0020
		MOV		ES,AX
		ADD		CL,1
		CMP		CL,18
		JBE		readloop
		MOV		CL,1
		ADD		DH,1
		CMP		DH,2
		JB		readloop
		MOV		DH,0
		ADD		CH,1
		CMP		CH,CYLS
		JB		readloop

fin:
		HLT				; 何かあるまでCPUを停止させる
		JMP		fin		; 無限ループ

putloop:
		MOV		AL,[SI]
		ADD		SI,1		; SIに1を足す
		CMP		AL,0		; 文字列の終了判定
		JE		fin
		MOV		AH,0x0e		; 一文字表示ファンクション
		MOV		BX,15		; カラーコード
		INT		0x10		; ビデオBIOS呼び出し
		JMP		putloop

error:
		MOV		SI,msg

msg:
		DB		0x0a, 0x0a		; 改行を2つ
		DB		"load error"
		DB		0x0a		; 改行
		DB		0		; 文字列の終了

		RESB		0x01fe-($-$$)		; 0x01feバイト目までを0x00で埋める

		DB		0x55, 0xaa		; ブートシグネチャ
