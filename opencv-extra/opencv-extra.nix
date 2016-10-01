{ mkDerivation
, stdenv
, lib

, opencv3_1

# library dependencies
, base
, bindings-DSL
, bytestring
, containers
, inline-c
, inline-c-cpp
, opencv
, primitive
, template-haskell
, transformers
}:
mkDerivation {
  pname = "opencv-extra";
  version = "0.0.0";
  src = builtins.filterSource (path: type:
          # Filter out .cpp files under ./src generated by inline-c:
            !(lib.hasPrefix (toString (./. + "/src")) (dirOf path)
              && lib.hasSuffix ".cpp" (baseNameOf path))

          # Filter out .nix files so that changing them doesn't necessarily cause a rebuild:
          && !(lib.hasSuffix ".nix" (baseNameOf path))

          # Filter out some other files or directories not needed for a build:
          && !(builtins.elem (toString path) (map (p: toString (./. + "/${p}")) [
                "cabal.config"
                "dist"
                ".gitignore"
                "Makefile"
              ]))
        ) ./.;

  libraryHaskellDepends =
  [ base
    bindings-DSL
    bytestring
    containers
    inline-c
    inline-c-cpp
    opencv
    primitive
    template-haskell
    transformers
  ];

  libraryPkgconfigDepends = [ opencv3_1 ];

  configureFlags =
    [ "--with-gcc=g++"
      "--with-ld=g++"
    ];

  homepage = "lumiguide.eu";
  license = stdenv.lib.licenses.bsd3;
}
