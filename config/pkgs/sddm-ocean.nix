{ lib, qtbase, qtsvg
, qtgraphicaleffects
, qtquickcontrols2
, wrapQtAppsHook
, stdenvNoCC
, fetchFromGitHub
}:
stdenvNoCC.mkDerivation rec {
  pname = "sddm-ocean";
  version = "1.0.0";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "Ganome";
    repo = "sddm-ocean";
    rev = "refs/tags/V${version}";
#    sha256 = "daf0a00b8d145e395678a41eac2069dbeaa1872ed717280c666c85b64fa71c86"; #This is the actual hash of the .tar.gz downloaded
    sha256 = "sha256-TTiVfTUTyzVgCcuQrKtEFnG4oDHqZzkOWRuND9/Hszo="; #This is the sha that nix expects to see while installing
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
    cp -aR $src $out/share/sddm/themes/sddm-ocean
  '';
}
