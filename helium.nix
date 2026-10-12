{
  appimageTools,
  fetchurl,
}:

let
  pname = "helium";
  version = "0.19.2.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-oEVQo8fHC9rTrNOkQw7ajSr8C/cXOpxYpAP+q5UXCH8=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # Chromium-based apps sometimes need extra libs beyond the default FHS env
  extraPkgs =
    pkgs: with pkgs; [
      libva
      libgbm
      libxkbcommon
    ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/*.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share/ 2>/dev/null || true

    substituteInPlace $out/share/applications/*.desktop \
      --replace-quiet 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = {
    description = "Helium browser";
    homepage = "https://github.com/imputnet/helium";
    platforms = [ "x86_64-linux" ];
    mainProgram = "helium";
  };
}
