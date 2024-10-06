
Debian
====================
This directory contains files used to package akitacoind/akitacoin-qt
for Debian-based Linux systems. If you compile akitacoind/akitacoin-qt yourself, there are some useful files here.

## akitacoin: URI support ##


akitacoin-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install akitacoin-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your akitacoin-qt binary to `/usr/bin`
and the `../../share/pixmaps/akitacoin128.png` to `/usr/share/pixmaps`

akitacoin-qt.protocol (KDE)

