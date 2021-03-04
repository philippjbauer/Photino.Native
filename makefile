CC=c++
CFLAGS=-Wall -framework Cocoa -framework WebKit

SRC=./src/
SRC_SHARED=$(SRC)Shared/

DEST_PATH=./build/

DEST_PATH_PROD=$(DEST_PATH)prod/
DEST_PATH_DEV=$(DEST_PATH)dev/
DEST_FILE=PhotinoApp

run: clean compile execute

clean:
	rm -rf $(DEST_PATH_DEV) && mkdir -p $(DEST_PATH_DEV)

compile:
	$(CC) $(CFLAGS)\
		$(SRC)Helpers/*.cpp\
		$(SRC)Helpers/*.mm\
		$(SRC)PhotinoApp/*.mm\
		$(SRC)PhotinoWebView/*.mm\
		$(SRC)PhotinoWindow/*.mm\
		$(SRC)Structs/*.cpp\
		$(SRC)main.mm\
		-o $(DEST_PATH_DEV)$(DEST_FILE)

execute:
	echo "----------------\nRun Application:\n----------------\n" &&\
	$(DEST_PATH_DEV)$(DEST_FILE)