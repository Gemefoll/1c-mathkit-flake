{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "mathkit";
  version = "12";

  src = pkgs.fetchurl {
    url = "http://files.obr.1c.ru/mathkit/12/mathkit-12-linux.zip";
    sha256 = "sha256-CUKZB5rhxbNaDILuKv0EJn35vm8Lrq6+gLLMJJ2B3ZM=";
    curlOpts = "-k";
  };

  # zip → нужен unzip
  nativeBuildInputs = [
    pkgs.unzip
    pkgs.makeWrapper
  ];

  # отключаем стандартную распаковку (она не всегда корректно работает с zip)
  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
        mkdir -p $out/opt/mathkit
        cp -r * $out/opt/mathkit

        mkdir -p $out/bin
        mkdir -p $out/share/applications
        makeWrapper $out/opt/mathkit/mathkit.12.0.ru/mathkit.sh $out/bin/mathkit \
        --set JAVA_HOME ${pkgs.jre8} \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.jre8 ]}

        cat > $out/share/applications/mathkit.desktop <<EOF
    [Desktop Entry]
    Name=MathKit
    Exec=mathkit
    Type=Application
    Categories=Education;
    EOF
  '';

  meta = with pkgs.lib; {
    description = "MathKit 12";
    platforms = platforms.linux;
  };

  buildInputs = [
    pkgs.jre8
  ];
}
