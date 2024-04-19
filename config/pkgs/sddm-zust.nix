{ lib, qtbase, qtsvg
, qtgraphicaleffects
, qtquickcontrols2
, wrapQtAppsHook
, stdenvNoCC
, fetchFromGitHub
}:
stdenvNoCC.mkDerivation rec {
  pname = "zust-sddm";
  version = "1.0.2";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "stephanzubkov";
    repo = "sddm-zust";
    rev = "ff673f71f7c41903ba7eeb9c91eaac54ab169fb8";
    sha256 = "sha256-e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
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
    cp -aR $src $out/share/sddm/themes/sddm-zust
  '';
}
