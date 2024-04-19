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
    owner = "stepanzubkov"; # archive/refs/tags/v1.0.2.tar.gz";
    repo = "sddm-zust";
    rev = "refs/tags/v${version}";
#    sha256 = "f5e7eaac92c7a0e01d5c27bd07b1c5388f59c5119a04f9b5d45db63f541dba45";
    sha256 = "sha256-CN5sguzj/W/HdiNAxshHBluA3U4mBqejxbdoKjSJWX4=";
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
