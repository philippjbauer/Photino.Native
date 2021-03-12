CC = c++
CFLAGS = -Wall -std=c++17
DLLFLAGS = -shared -fpic

SRC = ./src
SRC_ASSETS = $(SRC)/Assets

BUILD_FILE = PhotinoApp
BUILD_PATH = ./build
BUILD_PATH_DEV = $(BUILD_PATH)/dev
BUILD_PATH_DEV_BIN = $(BUILD_PATH_DEV)/bin
BUILD_PATH_DEV_LIB = $(BUILD_PATH_DEV)/lib
BUILD_EXE_DEV = $(BUILD_PATH_DEV_BIN)/$(BUILD_FILE)
BUILD_DLL_DEV = $(BUILD_PATH_DEV_LIB)/$(BUILD_FILE).dylib
# BUILD_PATH_PROD = $(BUILD_PATH)/prod
# BUILD_EXE_PROD = $(BUILD_PATH_PROD)/$(BUILD_FILE)
# BUILD_DLL_PROD = $(BUILD_PATH_PROD)/$(BUILD_FILE).dylib

PUB_PATH = ./publish
PUB_PATH_APP = $(PUB_PATH)/$(BUILD_FILE).app
PUB_PATH_CONTENTS = $(PUB_PATH_APP)/Contents
PUB_PATH_MACOS = $(PUB_PATH_CONTENTS)/MacOS
PUB_PATH_RESOURCES = $(PUB_PATH_CONTENTS)/Resources

MAC_SRCS = $(SRC)/Photino/App/*.mm\
		   $(SRC)/Photino/Structs/*.cpp\
		   $(SRC)/Photino/WebView/*.mm\
		   $(SRC)/Photino/Window/*.mm\
		   $(SRC)/PhotinoHelpers/*.mm\
		   $(SRC)/PhotinoShared/*.cpp

MAC_EVT_SRCS = $(SRC)/Photino/Events/*.cpp

MAC_DEPS = -framework Cocoa\
		   -framework WebKit

run: ensure-build-exe-dev\
	 build-exe-dev\
	 execute-dev

build-exe-dev: ensure-build-exe-dev\
			   compile-exe-dev\
			   copy-assets

build-dll-dev: ensure-build-dll-dev\
			   compile-dll-dev

publish-macos: ensure-build-exe-dev\
			   build-exe-dev\
			   ensure-output-pub\
			   create-macos-bundle

ensure-build-exe-dev:
	rm $(BUILD_EXE_DEV) &\
	mkdir -p $(BUILD_PATH_DEV_BIN)

ensure-build-dll-dev:
	rm $(BUILD_DLL_DEV) &\
	mkdir -p $(BUILD_PATH_DEV_LIB)

ensure-output-pub:
	rm -rf $(PUB_PATH) &\
	mkdir -p $(PUB_PATH)

compile-exe-dev:
	$(CC) $(CFLAGS)\
		$(MAC_DEPS)\
		$(MAC_SRCS)\
		$(SRC)/main.mm\
		-o $(BUILD_EXE_DEV)

compile-dll-dev:
	$(CC) $(CFLAGS) $(DLLFLAGS)\
		$(MAC_DEPS)\
		$(MAC_SRCS)\
		$(SRC)/exports.mm\
		-o $(BUILD_DLL_DEV)

copy-assets:
	rm -rf $(BUILD_PATH_DEV_BIN)/Assets &\
	cp -r $(SRC_ASSETS) $(BUILD_PATH_DEV_BIN)/

execute-dev:
	echo "----------------\nRun Application:\n----------------\n" &&\
	./$(BUILD_EXE_DEV)

create-macos-bundle:
	mkdir -p $(PUB_PATH_MACOS) &&\
	mkdir -p $(PUB_PATH_RESOURCES) &&\
	cp $(BUILD_EXE_DEV) $(PUB_PATH_MACOS)/ &&\
	cp -r $(BUILD_PATH_DEV_BIN)/Assets $(PUB_PATH_RESOURCES) &&\
	cp ./res/BundleIcon.png $(PUB_PATH_RESOURCES)/ &&\
	cp ./res/Info.plist $(PUB_PATH_CONTENTS)/
