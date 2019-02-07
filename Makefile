SHELL := /bin/zsh
ANDROID = PATH:/opt/android-sdk/build-tools/28.0.2
LOVE_NAME = game.love
ROOT_DIR = .
BUILD_DIR = build
OUTPUT_DIR = ${BUILD_DIR}/output
RELEASE_DIR = ${BUILD_DIR}/release
NAME = purrr
APK_NAME = ${NAME}.apk
PACKAGE_NAME = com.${NAME}.flamendless
TEST_APK_NAME = ${OUTPUT_DIR}/${NAME}-unaligned.apk
KS_FILE = ${BUILD_DIR}/am2018.keystore
EXCLUDE = *.git* *.gitmodules* *.gitignore* *.md* *.txt* *.rst* *docs/* *.ase* *.aseprite* *.swp* *spec/* *test/* *rockspec* *.mak* *.yml* *ctags* *Makefile* *build/* *backup/* *res/* *examples/* *LICENSE* *.vscode* *icons/* *.luacheckrc* *test* *.out* *.travis* *ase*;
VERSION = 0-1-3
PASSWORD :=

test:
	echo "Testing"
	love .

build-android: build-love apk-compile apk-sign apk-install

apk-release: build-love apk-compile apk-sign
	cp ${OUTPUT_DIR}/${APK_NAME} ${RELEASE_DIR}/purrr-${VERSION}.apk
	notify-send "FINISHED"

build-love:
	echo "making .love file..."
	noglob zip -9rv ${OUTPUT_DIR}/${LOVE_NAME} ${ROOT_DIR} -x ${EXCLUDE}
	echo "made .love file!"
	notify-send "LOVE BUILT!"

apk-compile:
	echo "copying .love to build"
	cp ${OUTPUT_DIR}/${LOVE_NAME} ${BUILD_DIR}/decoded/assets/
	echo "copied!"
	echo "compiling apk..."
	apktool b -o ${OUTPUT_DIR}/${APK_NAME} ${BUILD_DIR}/decoded;
	echo "compiled apk!"
	notify-send "APK COMPILED!"

apk-sign:
	echo "signing apk..."
	apk-signer -f ${OUTPUT_DIR}/${APK_NAME} -a flamendless -k ${KS_FILE} -s ${PASSWORD};
	echo "signed apk!"
	notify-send "APK SIGNED!"

apk-install:
	echo "adb installing..."
	adb uninstall ${PACKAGE_NAME}
	adb install ${TEST_APK_NAME}
	echo "adb installed"
	notify-send "APK INSTALLED!"
