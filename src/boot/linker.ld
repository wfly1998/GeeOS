OUTPUT_ARCH("riscv")
ENTRY(_start)
SECTIONS
{
  . = 0x00001000;
  .text : {
		*(.text.init)
	 	*(.text*)
		*(.rodata*)
	}
  .data : {
		*(.data)
		*(.data*)
		*(.sdata)
	}
	. = 0x80000000;
  .bss : {
		*(.bss*)
	}
	/DISCARD/ : {
		*(.eh_frame)
	}
}
