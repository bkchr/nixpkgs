{
  mkDerivation, lib,
  extra-cmake-modules,

  kactivities,
  plasma-framework,
  kwindowsystem,
  libksysguard,

  encfs,
  fuse
}:

mkDerivation {
  name = "plasma-vault";
  nativeBuildInputs = [ extra-cmake-modules ];

  patches = [
    ./encfs-path.patch
    ./fusermount-path.patch
    # Cryfs supported is removed because I do not want to package & maintain it
    # Feel free to package it and remove this patch
    ./cryfs-remove.patch
  ];

  buildInputs = [
    kactivities plasma-framework kwindowsystem libksysguard
  ];

  NIX_CFLAGS_COMPILE = [
    ''-DNIXPKGS_ENCFS="${lib.getBin encfs}/bin/encfs"''
    ''-DNIXPKGS_ENCFSCTL="${lib.getBin encfs}/bin/encfsctl"''

    ''-DNIXPKGS_FUSERMOUNT="${lib.getBin fuse}/bin/fusermount"''
  ];

}
