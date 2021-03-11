CC = c++
CFLAGS = -Wall -std=c++17
DLLFLAGS = -shared -fpic

SRC = ./src

DEST_PATH = ./build
DEST_FILE = PhotinoApp

DEST_PROD = $(DEST_PATH)/prod
DEST_DEV = $(DEST_PATH)/dev
DEST_PUB = $(DEST_PATH)/publish

DEV_EXE = $(DEST_DEV)/$(DEST_FILE)
DEV_DLL = $(DEST_DEV)/$(DEST_FILE).dylib

MAC_SRCS = $(SRC)/Photino/App/*.mm\
		   $(SRC)/Photino/Structs/*.cpp\
		   $(SRC)/Photino/WebView/*.mm\
		   $(SRC)/Photino/Window/*.mm\
		   $(SRC)/PhotinoHelpers/*.mm\
		   $(SRC)/PhotinoShared/*.cpp

MAC_EVT_SRCS = $(SRC)/Photino/Events/*.cpp

MAC_DEPS = -framework Cocoa\
		   -framework WebKit

run: build-exe-dev execute-dev

publish-app: ensure-output-pub build-exe-dev create-bundle

build-exe-dev: ensure-output-dev copy-assets compile-exe-dev

build-dll-dev: ensure-output-dev compile-dll-dev

copy-assets:
	rm -rf $(DEST_DEV)/Assets &&\
	cp -r $(SRC)/Assets $(DEST_DEV)/

ensure-output-dev:
	mkdir -p $(DEST_DEV)

ensure-output-pub:
	mkdir -p $(DEST_PUB)

compile-exe-dev:
	rm $(DEV_EXE) &\
	$(CC) $(CFLAGS)\
		$(MAC_DEPS)\
		$(MAC_SRCS)\
		$(SRC)/main.mm\
		-o $(DEV_EXE)

compile-dll-dev:
	rm $(DEV_DLL) &\
	$(CC) $(CFLAGS) $(DLLFLAGS)\
		$(MAC_DEPS)\
		$(MAC_SRCS)\
		$(SRC)/exports.mm\
		-o $(DEV_DLL)

execute-dev:
	echo "----------------\nRun Application:\n----------------\n" &&\
	$(DEV_EXE)

create-bundle:
	rm -rf $(DEST_PUB) &&\
	mkdir -p $(DEST_PUB)/PhotinoApp.app/Contents/MacOS &&\
	mkdir -p $(DEST_PUB)/PhotinoApp.app/Contents/Resources &&\
	mv $(DEV_EXE) $(DEST_PUB)/PhotinoApp.app/Contents/MacOS/ &&\
	mv $(DEST_DEV)/Assets $(DEST_PUB)/PhotinoApp.app/Contents/Resources &&\
	cp ./macOS\ Icons/Icon-MacOS-512x512@2x.png $(DEST_PUB)/PhotinoApp.app/Contents/Resources/AppIcon.png &&\
	cp ./Info.plist $(DEST_PUB)/PhotinoApp.app/Contents/
