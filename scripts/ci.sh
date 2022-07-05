#!/bin/bash

set -ex

pushd "${BUILDDIR}" > /dev/null

wget "https://github.com/crosstool-ng/crosstool-ng/archive/${CT_NG_COMMIT}.tar.gz"
wget "http://packs.download.atmel.com/Atmel.AVR-Dx_DFP.${AVR_DX_PACK_VERSION}.atpack"

tar -xf "${CT_NG_COMMIT}.tar.gz"
pushd "crosstool-ng-${CT_NG_COMMIT}/" > /dev/null
./bootstrap
./configure --enable-local
${MAKE_CMD}

popd > /dev/null
popd > /dev/null

pushd "${SRCDIR}" > /dev/null
"${BUILDDIR}/crosstool-ng-${CT_NG_COMMIT}/ct-ng" defconfig
CT_PREFIX="${BUILDDIR}/prefix" "${BUILDDIR}/crosstool-ng-${CT_NG_COMMIT}/ct-ng" build

mkdir -p "${BUILDDIR}/pack"
pushd "${BUILDDIR}/pack" > /dev/null
unzip "${BUILDDIR}/Atmel.AVR-Dx_DFP.${AVR_DX_PACK_VERSION}.atpack"
cp -v include/avr/ioavr* "${BUILDDIR}/prefix/avr/avr/include/avr/"
cp -v gcc/dev/*/device-specs/* "${BUILDDIR}"/prefix/avr/lib/gcc/avr/*/device-specs/
for d in gcc/dev/*/avr*; do
    dir="$(basename $d)"
    mkdir -p "${BUILDDIR}/prefix/avr/avr/lib/${dir}/"
    cp -v "${d}"/* "${BUILDDIR}/prefix/avr/avr/lib/${dir}/"
done
popd > /dev/null

tar -cJvf "${BUILDDIR}/${PN}-${TARGET/dist-/}-${PV}.tar.xz" -C "${BUILDDIR}/prefix" avr
popd > /dev/null

rm -rf "${BUILDDIR}/.build"
