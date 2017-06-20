{ kdeFramework, lib
, extra-cmake-modules
, kdoctools
, pcre
}:

kdeFramework {
  name = "kjs";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ pcre ];
}
