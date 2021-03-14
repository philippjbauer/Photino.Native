CC = c++
CFLAGS = -Wall -std=c++2a -fobjc-arc
DEBUG_FLAGS = -O0 -g
PROD_FLAGS = -O2
DLL_FLAGS = -shared -fpic

SRC = ./src
SRC_ASSETS = $(SRC)/Assets

BUILD_FILE = PhotinoApp
BUILD_PATH = ./build

BUILD_PATH_DEV = $(BUILD_PATH)/dev
BUILD_PATH_DEV_BIN = $(BUILD_PATH_DEV)/bin
BUILD_PATH_DEV_ASSETS = $(BUILD_PATH_DEV_BIN)/Assets
BUILD_PATH_DEV_LIB = $(BUILD_PATH_DEV)/lib
BUILD_EXE_DEV = $(BUILD_PATH_DEV_BIN)/$(BUILD_FILE)
BUILD_DLL_DEV = $(BUILD_PATH_DEV_LIB)/$(BUILD_FILE).dylib

BUILD_PATH_PROD = $(BUILD_PATH)/prod
BUILD_PATH_PROD_BIN = $(BUILD_PATH_PROD)/bin
BUILD_PATH_PROD_ASSETS = $(BUILD_PATH_PROD_BIN)/Assets
BUILD_PATH_PROD_LIB = $(BUILD_PATH_PROD)/lib
BUILD_EXE_PROD = $(BUILD_PATH_PROD_BIN)/$(BUILD_FILE)
BUILD_DLL_PROD = $(BUILD_PATH_PROD_LIB)/$(BUILD_FILE).dylib

PUB_PATH = ./publish
PUB_PATH_APP = $(PUB_PATH)/$(BUILD_FILE).app
PUB_PATH_CONTENTS = $(PUB_PATH_APP)/Contents
PUB_PATH_MACOS = $(PUB_PATH_CONTENTS)/MacOS
PUB_PATH_RESOURCES = $(PUB_PATH_CONTENTS)/Resources

MAC_SRCS = $(SRC)/Photino/**/*.mm\
		   $(SRC)/Photino/**/*.cpp\
		   $(SRC)/PhotinoHelpers/*.mm\
		   $(SRC)/PhotinoShared/*.cpp

MAC_EVT_SRCS = $(SRC)/Photino/Events/*.cpp

MAC_DEPS = -framework Cocoa\
		   -framework WebKit

run: ensure-build-exe-dev\
	 build-exe-dev\
	 execute-dev

build-exe-prod: ensure-build-exe-prod\
			    compile-exe-prod\
			    copy-assets-prod

build-exe-dev: ensure-build-exe-dev\
			   compile-exe-dev\
			   copy-assets-dev

build-exe-min: ensure-build-exe-dev\
			   compile-exe-min\
			   copy-assets-dev

build-dll-prod: ensure-build-dll-prod\
			    compile-dll-prod

build-dll-dev: ensure-build-dll-dev\
			   compile-dll-dev

build-all: build-exe-prod\
		   build-exe-dev\
		   build-dll-prod\
		   build-dll-dev

publish-macos: build-exe-prod\
			   ensure-publish-path\
			   create-macos-bundle

ensure-build-exe-prod:
	rm -rf $(BUILD_PATH_PROD_BIN) &&\
	mkdir -p $(BUILD_PATH_PROD_BIN)

ensure-build-exe-dev:
	rm -rf $(BUILD_PATH_DEV_BIN) &&\
	mkdir -p $(BUILD_PATH_DEV_BIN)

ensure-build-dll-prod:
	rm -rf $(BUILD_PATH_PROD_LIB) &&\
	mkdir -p $(BUILD_PATH_PROD_LIB)

ensure-build-dll-dev:
	rm -rf $(BUILD_PATH_DEV_LIB) &&\
	mkdir -p $(BUILD_PATH_DEV_LIB)

ensure-publish-path:
	rm -rf $(PUB_PATH) &&\
	mkdir -p $(PUB_PATH)

compile-exe-prod:
	$(CC) $(CFLAGS) $(PROD_FLAGS)\
		$(MAC_DEPS)\
		$(MAC_SRCS)\
		$(SRC)/main.mm\
		-o $(BUILD_EXE_PROD)

compile-exe-dev:
	$(CC) $(CFLAGS) $(DEBUG_FLAGS)\
		$(MAC_DEPS)\
		$(MAC_SRCS)\
		$(SRC)/main.mm\
		-o $(BUILD_EXE_DEV)

compile-exe-min:
	$(CC) $(CFLAGS) $(DEBUG_FLAGS)\
		$(MAC_DEPS)\
		$(MAC_SRCS)\
		$(SRC)/minimal.mm\
		-o $(BUILD_EXE_DEV)

compile-dll-prod:
	$(CC) $(CFLAGS) $(PROD_FLAGS) $(DLL_FLAGS)\
		$(MAC_DEPS)\
		$(MAC_SRCS)\
		$(SRC)/exports.mm\
		-o $(BUILD_DLL_PROD)

compile-dll-dev:
	$(CC) $(CFLAGS) $(DLL_FLAGS)\
		$(MAC_DEPS)\
		$(MAC_SRCS)\
		$(SRC)/exports.mm\
		-o $(BUILD_DLL_DEV)

copy-assets-prod:
	rm -rf $(BUILD_PATH_PROD_ASSETS) &&\
	mkdir -p $(BUILD_PATH_PROD_BIN) &&\
	cp -r $(SRC_ASSETS) $(BUILD_PATH_PROD_BIN)/

copy-assets-dev:
	rm -rf $(BUILD_PATH_DEV_ASSETS) &&\
	mkdir -p $(BUILD_PATH_DEV_BIN) &&\
	cp -r $(SRC_ASSETS) $(BUILD_PATH_DEV_BIN)/

execute-prod:
	echo "----------------\nRun Application:\n----------------\n" &&\
	./$(BUILD_EXE_PROD)

execute-dev:
	echo "----------------\nRun Application:\n----------------\n" &&\
	./$(BUILD_EXE_DEV)

create-macos-bundle:
	mkdir -p $(PUB_PATH_MACOS) &&\
	mkdir -p $(PUB_PATH_RESOURCES) &&\
	cp $(BUILD_EXE_PROD) $(PUB_PATH_MACOS)/ &&\
	cp -r $(BUILD_PATH_PROD_ASSETS) $(PUB_PATH_RESOURCES) &&\
	cp ./res/BundleIcon.png $(PUB_PATH_RESOURCES)/ &&\
	cp ./res/Info.plist $(PUB_PATH_CONTENTS)/ &&\
	open $(PUB_PATH)
