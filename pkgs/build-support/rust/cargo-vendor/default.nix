{ stdenv, callPackage, fetchFromGitHub, pkgconfig, openssl, curl, libssh2, cmake }:

let
  cargo-vendor-bootstrap = (callPackage ./cargo-vendor-bootstrap.nix {}).cargo_vendor_0_1_13.overrideAttrs (attrs: {
    src = fetchFromGitHub {
      owner = "alexcrichton";
      repo = "cargo-vendor";
      rev = "0.1.13";
      sha256 = "0ljh2d65zpxp26a95b3czy5ai2z2dm87x7ndfdc1s0v1fsy69kn4";
    };
  });
  buildRustPackage = callPackage ../. { cargo-vendor = cargo-vendor-bootstrap; };
in
buildRustPackage rec {
  name = "cargo-vendor-${version}";
  version = "0.1.16";

  src = fetchFromGitHub {
    owner = "alexcrichton";
    repo = "cargo-vendor";
    rev = "${version}";
    sha256 = "03pllm7y9k1sk8ch5rz6wlmj19k5niv32rn89fwsw0mfv0hcfs35";
  };

  cargoSha256 = "0g4p12hikmw4whdqkjamj5kbbwih0l3i67h728hjdb4q8phn6vvg";

  buildInputs = [ openssl curl libssh2 ];

  nativeBuildInputs = [ pkgconfig cmake ];

  doCheck = false;
}
