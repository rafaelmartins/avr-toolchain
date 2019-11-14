#!/bin/bash

set -ex

pushd "${BUILDDIR}" > /dev/null
wget "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${CT_NG_VERSION}.tar.bz2"
tar -xf "crosstool-ng-${CT_NG_VERSION}.tar.bz2"
pushd "crosstool-ng-${CT_NG_VERSION}/" > /dev/null
./configure --enable-local
${MAKE_CMD}
popd > /dev/null
popd > /dev/null

pushd "${SRCDIR}" > /dev/null
"${BUILDDIR}/crosstool-ng-${CT_NG_VERSION}/ct-ng" defconfig
CT_PREFIX="${BUILDDIR}/prefix" "${BUILDDIR}/crosstool-ng-${CT_NG_VERSION}/ct-ng" build
tar -cJvf "${BUILDDIR}/${PN}-${PV}.tar.xz" -C "${BUILDDIR}/prefix" avr
popd > /dev/null

rm -rf "${BUILDDIR}/.build"
