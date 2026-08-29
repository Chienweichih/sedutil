CC      ?= gcc
CFLAGS  ?= -Wall -Wextra -Os
TARGET  := hmac_otp_demo
SRC     := hmac_otp_demo.c

.PHONY: all clean run

all: $(TARGET)

$(TARGET): $(SRC) hmac_sha256.h
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC)

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET)
