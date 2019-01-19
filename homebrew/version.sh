#!/bin/sh -e
VERSION=${1}
HOMEBREW_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PROJECT_DIR="$(cd ${HOMEBREW_DIR}/.. >/dev/null 2>&1 && pwd )"
APP_PATH=${PROJECT_DIR}/build/Release/SudoKing.app
RELEASE_DIR=${PROJECT_DIR}/releases

if [[ -z $VERSION ]]; then
    echo "ERROR: Please Specify a version. Exiting."
    exit 1
fi

cd ${PROJECT_DIR} && xcodebuild -project SudoKing.xcodeproj

mkdir -p ${RELEASE_DIR}
cd ${RELEASE_DIR}
cp -R ${APP_PATH} SudoKing.app
cp ${HOMEBREW_DIR}/sudoking.sh sudoking

TARBALL=${RELEASE_DIR}/sudoking-${VERSION}.tar.gz
tar -czf ${TARBALL} SudoKing.app sudoking
echo "Created tarball: ${TARBALL}"
SHA=$(shasum -a 256 ${TARBALL} | awk '{printf $1}')
echo "sha256: ${SHA} \n"
