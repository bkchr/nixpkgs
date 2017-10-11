{ mkDerivation, lib, fetchurl, cmake, extra-cmake-modules, wrapGAppsHook

# For `digitaglinktree`
, perl, sqlite

, qtbase
, qtxmlpatterns
, qtsvg
, qtwebkit

, kconfigwidgets
, kcoreaddons
, kdoctools
, kfilemetadata
, knotifications
, knotifyconfig
, ktextwidgets
, kwidgetsaddons
, kxmlgui

, bison
, boost
, eigen
, exiv2
, flex
, jasper
, lcms2
, lensfun
, libgphoto2
, libkipi
, liblqr1
, libqtav
, libusb1
, marble
, mysql
, opencv3
, threadweaver

# For panorama and focus stacking
, enblend-enfuse
, hugin
, gnumake

, oxygen
}:

mkDerivation rec {
  name    = "digikam-${version}";
  version = "5.7.0";

  src = fetchurl {
    url = "http://download.kde.org/stable/digikam/${name}.tar.xz";
    sha256 = "1xah079g47fih8l9qy1ifppfvmq5yms5y1z54nvxdyz8nsszy19n";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules kdoctools wrapGAppsHook ];

  buildInputs = [
    bison
    boost
    eigen
    exiv2
    flex
    jasper
    lcms2
    lensfun
    libgphoto2
    libkipi
    liblqr1
    libqtav
    libusb1
    mysql
    opencv3
  ];

  propagatedBuildInputs = [
    qtbase
    qtxmlpatterns
    qtsvg
    qtwebkit

    kconfigwidgets
    kcoreaddons
    kfilemetadata
    knotifications
    knotifyconfig
    ktextwidgets
    kwidgetsaddons
    kxmlgui

    marble
    oxygen
    threadweaver
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DLIBUSB_LIBRARIES=${libusb1.out}/lib"
    "-DLIBUSB_INCLUDE_DIR=${libusb1.dev}/include/libusb-1.0"
    "-DENABLE_MYSQLSUPPORT=1"
    "-DENABLE_INTERNALMYSQL=1"
    "-DENABLE_MEDIAPLAYER=1"
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ gnumake hugin enblend-enfuse ]})
    substituteInPlace $out/bin/digitaglinktree \
      --replace "/usr/bin/perl" "${perl}/bin/perl" \
      --replace "/usr/bin/sqlite3" "${sqlite}/bin/sqlite3"
  '';

  meta = with lib; {
    description = "Photo Management Program";
    license = licenses.gpl2;
    homepage = http://www.digikam.org;
    maintainers = with maintainers; [ the-kenny ];
    platforms = platforms.linux;
  };
}
