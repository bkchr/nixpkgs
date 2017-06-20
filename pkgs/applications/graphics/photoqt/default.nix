{ stdenv, fetchurl, cmake, makeQtWrapper, exiv2, graphicsmagick
, qtbase, qtdeclarative, qtmultimedia, qtquickcontrols, qttools
, libraw
}:

let
  version = "1.5.1";
in
stdenv.mkDerivation rec {
  name = "photoqt-${version}";
  src = fetchurl {
    url = "http://photoqt.org/pkgs/photoqt-${version}.tar.gz";
    sha256 = "61018feba7e3e0b82b0bc845cab4740ea3e26339cd4b69847ed1ba5fe7bf739e";
  };

  buildInputs = [
    cmake makeQtWrapper qtbase qtquickcontrols qttools exiv2 graphicsmagick
    qtmultimedia qtdeclarative libraw
  ];

  preConfigure = ''
    export MAGICK_LOCATION="${graphicsmagick}/include/GraphicsMagick"
  '';

  postInstall = ''
    wrapQtProgram $out/bin/photoqt
  '';

  patches = [ ./cmake-find-qt.patch ];

  meta = {
    homepage = "http://photoqt.org/";
    description = "Simple, yet powerful and good looking image viewer";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.eduarrrd ];
  };
}
