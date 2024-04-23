VERSION=1.0.1.0
rm -rf ./release-linux
mkdir release-linux

cp ./src/akitacoind ./release-linux/
cp ./src/akitacoin-cli ./release-linux/
cp ./src/qt/akitacoin-qt ./release-linux/
cp ./NEOXACOIN_small.png ./release-linux/

cd ./release-linux/
strip akitacoind
strip akitacoin-cli
strip akitacoin-qt

#==========================================================
# prepare for packaging deb file.

mkdir akitacoin-$VERSION
cd akitacoin-$VERSION
mkdir -p DEBIAN
echo 'Package: akitacoin
Version: '$VERSION'
Section: base 
Priority: optional 
Architecture: all 
Depends:
Maintainer: Akitacoin
Description: Akitacoin coin wallet and service.
' > ./DEBIAN/control
mkdir -p ./usr/local/bin/
cp ../akitacoind ./usr/local/bin/
cp ../akitacoin-cli ./usr/local/bin/
cp ../akitacoin-qt ./usr/local/bin/

# prepare for desktop shortcut
mkdir -p ./usr/share/icons/
cp ../NEOXACOIN_small.png ./usr/share/icons/
mkdir -p ./usr/share/applications/
echo '
#!/usr/bin/env xdg-open

[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=/usr/local/bin/akitacoin-qt
Name=akitacoin
Comment= akitacoin coin wallet
Icon=/usr/share/icons/NEOXACOIN_small.png
' > ./usr/share/applications/akitacoin.desktop

cd ../
# build deb file.
dpkg-deb --build akitacoin-$VERSION

#==========================================================
# build rpm package
rm -rf ~/rpmbuild/
mkdir -p ~/rpmbuild/{RPMS,SRPMS,BUILD,SOURCES,SPECS,tmp}

cat <<EOF >~/.rpmmacros
%_topdir   %(echo $HOME)/rpmbuild
%_tmppath  %{_topdir}/tmp
EOF

#prepare for build rpm package.
rm -rf akitacoin-$VERSION
mkdir akitacoin-$VERSION
cd akitacoin-$VERSION

mkdir -p ./usr/bin/
cp ../akitacoind ./usr/bin/
cp ../akitacoin-cli ./usr/bin/
cp ../akitacoin-qt ./usr/bin/

# prepare for desktop shortcut
mkdir -p ./usr/share/icons/
cp ../akitacoin.png ./usr/share/icons/
mkdir -p ./usr/share/applications/
echo '
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=/usr/bin/akitacoin-qt
Name=akitacoin
Comment= akitacoin coin wallet
Icon=/usr/share/icons/akitacoin.png
' > ./usr/share/applications/akitacoin.desktop
cd ../

# make tar ball to source folder.
tar -zcvf akitacoin-$VERSION.tar.gz ./akitacoin-$VERSION
cp akitacoin-$VERSION.tar.gz ~/rpmbuild/SOURCES/

# build rpm package.
cd ~/rpmbuild

cat <<EOF > SPECS/akitacoin.spec
# Don't try fancy stuff like debuginfo, which is useless on binary-only
# packages. Don't strip binary too
# Be sure buildpolicy set to do nothing

Summary: Akitacoin wallet rpm package
Name: akitacoin
Version: $VERSION
Release: 1
License: MIT
SOURCE0 : %{name}-%{version}.tar.gz
URL: https://www.akitacoin.net/

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

%description
%{summary}

%prep
%setup -q

%build
# Empty section.

%install
rm -rf %{buildroot}
mkdir -p  %{buildroot}

# in builddir
cp -a * %{buildroot}


%clean
rm -rf %{buildroot}


%files
/usr/share/applications/akitacoin.desktop
/usr/share/icons/akitacoin.png
%defattr(-,root,root,-)
%{_bindir}/*

%changelog
* Tue Apr 23 2024  Akitacoin Project Team.
- First Build

EOF

rpmbuild -ba SPECS/akitacoin.spec



