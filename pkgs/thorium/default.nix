{ lib, fetchurl, appimageTools }:

appimageTools.wrapType2 rec {
  pname = "thorium";
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/edrlab/thorium-reader/releases/download/v${version}/Thorium-${version}.AppImage";
    hash = "sha256-LnUUYnkbPxTWjCQFheqG2BhlksFRa2B5WZ8w23wV/Qg=";
  };

  extraPkgs = pkgs: with pkgs; [
  ];

  extraInstallCommands =
    let appimageContents = appimageTools.extractType2 { inherit pname version src; }; in
    ''
      install -Dm444 ${appimageContents}/thorium.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/thorium.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
      install -m 444 -D ${appimageContents}/thorium.png \
        $out/share/icons/hicolor/1024x1024/apps/thorium.png
    '';

  meta = with lib; {
    homepage = "https://www.edrlab.org/software/thorium-reader/";
    description = "The EPUB reader of choice for Windows 10 and 11, MacOS and Linux";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
  };
}
