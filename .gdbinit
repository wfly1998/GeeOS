file build/geeos.elf
set arch riscv:rv32
target remote localhost:1234
define hook-stop
x/i $pc
info registers sp a0 a1 a2
end
break _$main_
continue
