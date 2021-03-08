CC = c++
CFLAGS = -Wall -std=c++17
DLLFLAGS = -shared -fpic

SRC = ./src

DEST_PATH = ./build
DEST_FILE = PhotinoApp

DEST_PROD = $(DEST_PATH)/prod
DEST_DEV = $(DEST_PATH)/dev

DEV_EXE = $(DEST_DEV)/$(DEST_FILE)
DEV_DLL = $(DEST_DEV)/$(DEST_FILE).dylib

MAC_SRCS = $(SRC)/Photino/App/*.mm\
		   $(SRC)/Photino/Events/*.cpp\
		   $(SRC)/Photino/Structs/*.cpp\
		   $(SRC)/Photino/WebView/*.mm\
		   $(SRC)/Photino/Window/*.mm\
		   $(SRC)/PhotinoHelpers/*.mm\
		   $(SRC)/PhotinoHelpers/*.cpp\
		   $(SRC)/PhotinoShared/*.cpp

MAC_EVT_SRCS = $(SRC)/Photino/Events/*.cpp

MAC_DEPS = -framework Cocoa\
		   -framework WebKit

run: build-exe-dev execute-dev

build-exe-dev: ensure-output compile-exe-dev

build-dll-dev: ensure-output compile-dll-dev

build-exe-evt-test: ensure-output compile-exe-evt-test

copy-assets:
	rm -rf $(DEST_DEV)/Assets &&\
	cp -r $(SRC)/Assets $(DEST_DEV)/

ensure-output:
	mkdir -p $(DEST_DEV)

compile-exe-dev:
	$(CC) $(CFLAGS)\
		$(MAC_DEPS)\
		$(MAC_SRCS)\
		$(SRC)/main.mm\
		-o $(DEV_EXE)

compile-dll-dev:
	$(CC) $(CFLAGS) $(DLLFLAGS)\
		$(MAC_DEPS)\
		$(MAC_SRCS)\
		$(SRC)/exports.mm\
		-o $(DEV_DLL)

compile-exe-evt-test:
	$(CC) $(CFLAGS)\
		$(MAC_EVT_SRCS)\
		$(SRC)/main.mm\
		-o $(DEV_EXE)

execute-dev:
	echo "----------------\nRun Application:\n----------------\n" &&\
	$(DEV_EXE)
