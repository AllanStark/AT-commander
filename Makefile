CC = g++
CFLAGS = -I. -c -w -Wall -Werror -g -ggdb
LDFLAGS = -lm
LDLIBS = -lcheck

TEST_DIR = tests

CFLAGS = -Iatcommander

# Guard against \r\n line endings only in Cygwin
OSTYPE := $(shell uname)
ifneq ($(OSTYPE),Darwin)
	OSTYPE := $(shell uname -o)
	ifeq ($(OSTYPE),Cygwin)
		TEST_SET_OPTS = igncr
	endif
endif

SRC = $(wildcard atcommander/*.c)
OBJS = $(SRC:.c=.o)
TEST_SRC = $(wildcard $(TEST_DIR)/*.c)
TEST_OBJS = $(TEST_SRC:.c=.o)

all: $(OBJS)

test: $(TEST_DIR)/tests.bin
	@set -o $(TEST_SET_OPTS) >/dev/null 2>&1
	@export SHELLOPTS
	@sh runtests.sh $(TEST_DIR)

$(TEST_DIR)/tests.bin: $(TEST_OBJS) $(OBJS)
	@mkdir -p $(dir $@)
	$(CC) $(LDFLAGS) $(CC_SYMBOLS) $(CFLAGS) $(INCLUDE_PATHS) -o $@ $^ $(LDLIBS)

clean:
	rm -rf *.o $(TEST_DIR)/*.o $(TEST_DIR)/*.bin
