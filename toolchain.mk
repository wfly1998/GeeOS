# external parameters
DEBUG ?= 0
OPT_LEVEL = 2

# judge if is debug mode
ifeq ($(DEBUG), 0)
	C_DEBUG_ARG = -DNDEBUG
	C_OPT_ARG = -O$(OPT_LEVEL)
	YU_OPT_ARG = -O $(OPT_LEVEL)
else
	C_DEBUG_ARG = -g
	C_OPT_ARG = -O0
	YU_OPT_ARG = -O 0
endif

# cross compile toolchain prefix
RV_PREFIX := riscv32-unknown-linux-gnu-

# cross Yu compiler
YUFLAGS := -Werror $(YU_OPT_ARG)
YUFLAGS += -tt riscv32-unknown-elf -tc generic-rv32 -tf +m,+a
export YUC := yuc $(YUFLAGS)

# cross C compiler
CFLAGS := -Wall -Werror -c -static $(C_DEBUG_ARG) $(C_OPT_ARG)
CFLAGS += -fno-builtin -fno-pic
CFLAGS += -target riscv32-unknown-elf -march=rv32ima -mabi=ilp32
export CC := clang $(CFLAGS)

# native C++ compiler
CXXFLAGS := -Wall -Werror -c $(C_DEBUG_ARG) $(C_OPT_ARG)
CXXFLAGS += -std=c++17
export CXX := clang++ $(CXXFLAGS)

# cross LLVM compiler
LLCFLAGS := $(C_OPT_ARG) -filetype=obj
LLCFLAGS += -march=riscv32 -mcpu=generic-rv32 -mattr=+m,+a
export LLC := llc $(LLCFLAGS)

# cross linker
LDFLAGS := -nostdlib -melf32lriscv
export LD := ld.lld $(LDFLAGS)

# native linker
NLDFLAGS :=
export NLD := clang++ $(NLDFLAGS)

# objcopy
OBJCFLAGS := -O binary
export OBJC := llvm-objcopy $(OBJCFLAGS)

# objdump
OBJDFLAGS := -D
export OBJD := $(RV_PREFIX)objdump $(OBJDFLAGS)

# strip
STRIPFLAGS := --strip-unneeded --strip-sections
export STRIP := llvm-strip $(STRIPFLAGS)

# archiver
ARFLAGS := ru
export AR := llvm-ar $(ARFLAGS)

# ranlib
RANLIBFLAGS :=
export RANLIB := llvm-ranlib $(RANLIBFLAGS)
