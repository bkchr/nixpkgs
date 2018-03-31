{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, bison, flex
, python3, glib, makeWrapper, valgrind, libcap
, gtk3, gsl, libunwind, darwin
}:

stdenv.mkDerivation rec {
  name = "gstreamer-1.14.0";

  meta = {
    description = "Open source multimedia framework";
    homepage = https://gstreamer.freedesktop.org;
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.ttuegel ];
  };

  src = fetchurl {
    url = "${meta.homepage}/src/gstreamer/${name}.tar.xz";
    sha256 = "0vj6k01lp2yva6rfd95fkyng9jdr62gkz0x8d2l81dyly1ki6dpw";
  };

  patches = [ 
    ./fix_install_dir.patch
    ./fix_pkgconfig_includedir.patch
  ];

  outputs = [ "out" "dev" ];
  outputBin = "dev";

  nativeBuildInputs = [
    meson ninja pkgconfig gettext bison flex python3 makeWrapper valgrind gtk3 gsl
  ];
  buildInputs = [ libcap libunwind ] ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.CoreServices;

  propagatedBuildInputs = [ glib ];

  postInstall = ''
    for prog in "$dev/bin/"*; do
        wrapProgram "$prog" --suffix GST_PLUGIN_SYSTEM_PATH : "\$(unset _tmp; for profile in \$NIX_PROFILES; do _tmp="\$profile/lib/gstreamer-1.0''$\{_tmp:+:\}\$_tmp"; done; printf "\$_tmp")"
    done
  '';

  preConfigure= ''
    patchShebangs .
  '';

  preFixup = ''
    moveToOutput "share/bash-completion" "$dev"
  '';

  setupHook = ./setup-hook.sh;
}
