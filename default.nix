{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let

  version = "1.8.0";
  
  commentoSrc = fetchFromGitHub {
    owner = "adtac";
    repo = "commento";
    rev = "v${version}";
    sha256 = "0h8kic1h8pzlwhic7l0vb7mjjgn1fw7l37a2qxdmq7q4hj2j7cna";
  };

  api = buildGoModule {
    inherit version;
    name = "commento";
    src = "${commentoSrc}/api";  
    modSha256 = "0v2bkqynxqjq5fcj1ng2m9vqypnix2z2q7bdqgi01llkdsqd2bbk";
  };
  
  frontend = mkYarnPackage rec {

    name = "frontend";
    src = "${commentoSrc}/frontend";
    packageJSON = "${src}/package.json";
    yarnLock = "${src}/yarn.lock";

    yarnPreBuild = ''
      mkdir -p $HOME/.node-gyp/${nodejs.version}
      echo 9 > $HOME/.node-gyp/${nodejs.version}/installVersion
      ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
    '';

    pkgConfig.node-sass = {
      buildInputs = [ python ];
      postInstall = ''
        yarn --offline run build
        rm build/config.gypi
      '';
    };

    installPhase = ''
      sed -i "s+node_modules+$(pwd)/node_modules+g" ./deps/commento/gulpfile.js
      $(pwd)/node_modules/.bin/gulp prod --gulpfile ./deps/commento/gulpfile.js
    '';

    distPhase = ''
      mv ./deps/commento/build/prod $out
    '';
    
  };
  
in stdenv.mkDerivation {
  inherit src version;
  name = "commento-${version}";

  installPhase = ''
    mkdir -p $out/{db,templates}
    ln -s ${api}/bin/api $out/commento
    cp -r ${frontend}/* $out
    cp -r ${commentoSrc}/db/*.sql $out/db
    cp -r ${commentoSrc}/templates/*.txt $out/templates
  '';

  meta = with stdenv.lib; {
    description = "A fast, bloat-free comments platform";
    homepage = "https://github.com/adtac/commento";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.unix;
  };
}
