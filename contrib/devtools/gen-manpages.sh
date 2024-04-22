#!/bin/sh

TOPDIR=${TOPDIR:-$(git rev-parse --show-toplevel)}
SRCDIR=${SRCDIR:-$TOPDIR/src}
MANDIR=${MANDIR:-$TOPDIR/doc/man}

AKITACOIND=${AKITACOIND:-$SRCDIR/akitacoind}
AKITACOINCLI=${AKITACOINCLI:-$SRCDIR/akitacoin-cli}
AKITACOINTX=${AKITACOINTX:-$SRCDIR/akitacoin-tx}
AKITACOINQT=${AKITACOINQT:-$SRCDIR/qt/akitacoin-qt}

[ ! -x $AKITACOIND ] && echo "$AKITACOIND not found or not executable." && exit 1

# The autodetected version git tag can screw up manpage output a little bit
AKICVER=($($AKITACOINCLI --version | head -n1 | awk -F'[ -]' '{ print $6, $7 }'))

# Create a footer file with copyright content.
# This gets autodetected fine for akitacoind if --version-string is not set,
# but has different outcomes for akitacoin-qt and akitacoin-cli.
echo "[COPYRIGHT]" > footer.h2m
$AKITACOIND --version | sed -n '1!p' >> footer.h2m

for cmd in $AKITACOIND $AKITACOINCLI $AKITACOINTX $AKITACOINQT; do
  cmdname="${cmd##*/}"
  help2man -N --version-string=${AKICVER[0]} --include=footer.h2m -o ${MANDIR}/${cmdname}.1 ${cmd}
  sed -i "s/\\\-${AKICVER[1]}//g" ${MANDIR}/${cmdname}.1
done

rm -f footer.h2m
