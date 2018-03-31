{ stdenv, fetchurl, meson, ninja, pkgconfig, python
, gnonlin, libxml2, flex, perl, gst-plugins-good
, gst-plugins-bad
}:

stdenv.mkDerivation rec {
  name = "gstreamer-editing-services-1.14.0";

  meta = with stdenv.lib; {
    description = "Library for creation of audio/video non-linear editors";
    homepage    = "https://gstreamer.freedesktop.org";
    license     = licenses.lgpl2Plus;
    platforms   = platforms.unix;
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer-editing-services/${name}.tar.xz";
    sha256 = "14cdd6y9p4k603hsnyhdjw2igg855gwpx0362jmg8k1gagmr0pwd";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ meson ninja pkgconfig python flex perl ];

  propagatedBuildInputs = [ gnonlin libxml2 gst-plugins-good gst-plugins-bad ];

  patches = [
    ./fix_install_dir.patch
    ./fix_pkgconfig_includedir.patch
  ];
}
