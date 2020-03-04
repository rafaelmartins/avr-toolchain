#!/bin/bash

set -ex

pushd "${BUILDDIR}" > /dev/null
wget "https://github.com/crosstool-ng/crosstool-ng/archive/${CT_NG_COMMIT}.tar.gz"
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
tar -cJvf "${BUILDDIR}/${PN}-${TARGET/dist-/}-${PV}.tar.xz" -C "${BUILDDIR}/prefix" avr
popd > /dev/null

rm -rf "${BUILDDIR}/.build"
