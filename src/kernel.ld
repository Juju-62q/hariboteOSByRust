ENTRY(hari_main)

/*出力フォーマット*/
OUTPUT_FORMAT("binary")

/*セクション*/
SECTIONS{
	/*.hrbオブジェクトファイルのフォーマットに従い、ヘッダを定義*/
	.head 0x0 :
	{
		LONG((ADDR(.bss) + SIZEOF(.bss) + 0xfff) & ~ 0xfff)	/* stack+.data+heapの大きさ */
		LONG(0x69726148)	/* シグネチャ "Hari" */
		LONG(0x0)		/* mmareaの大きさ */
		LONG(ADDR(.data))	/* スタックの初期位置 */
		LONG(SIZEOF(.data))	/* .dataのサイズ */
		LONG(LOADADDR(.data))	/* .dataの初期値列がファイルのどこにあるか */
		LONG(0xe9000000)	/* 0xE9000000 */
		LONG(hari_main - 0x20)	/* エントリアドレス-0x20 */
		LONG((ADDR(.bss) + SIZEOF(.bss) + 0xf) & ~ 0xf)		/* heap領域の開始アドレス */
	}

	/* .textセクションのメモリ開始位置 */
	.text ADDR(.head) + SIZEOF(.head) : SUBALIGN(1)
	{
		/*.textセクション全部を含む*/
		*(.text.hari_main)
		*(.text*)
	}


	/*.dataセクションのメモリ開始位置*/
	.data 0x00000400:
	/*.data:*/

	/*.dataセクションのファイル上の開始位置*/
	AT(LOADADDR(.text) + SIZEOF(.text)) SUBALIGN(4)
	{
		*(.data)
		*(.rodata*)
	}

	/*.bssセクションのメモリ開始位置(.dataセクションの終端から)*/
	.bss :

	/*.bssセクションのファイル上の開始位置*/
	AT(LOADADDR(.data) + SIZEOF(.data)) SUBALIGN(4)
	{
		*(.bss)
	}

	/* 上記以外のセクションは無視する */
	/DISCARD/ : {*(*)}
}
