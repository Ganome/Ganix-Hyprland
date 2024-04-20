{ lib, qtbase, qtsvg
, qtgraphicaleffects
, qtquickcontrols2
, wrapQtAppsHook
, stdenvNoCC
, fetchFromGitHub
}:
stdenvNoCC.mkDerivation rec {
  pname = "sddm-chili";
  version = "0.1.5";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-chili";
    rev = "refs/tags/${version}";
#    sha256 = "a3c0607bf70f448fff0a271624e3bc15af978894c04c98355d00a57431e49a0f"; #This is the actual hash of the .tar.gz downloaded
    sha256 = "sha256-wxWsdRGC59YzDcSopDRzxg8TfjjmA3LHrdWjepTuzgw="; #This is the sha that nix expects to see while installing
  };
  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  propagatedUserEnvPkgs = [
    qtbase
    qtsvg
    qtgraphicaleffects
    qtquickcontrols2
  ];

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR $src $out/share/sddm/themes/sddm-chili
  '';
}
