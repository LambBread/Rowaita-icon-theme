{
    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    inputs.nix-colorizer.url = "github:nutsalhan87/nix-colorizer";

    outputs = {self, nixpkgs, nix-colorizer}:
    let
        mkTheme = {
            l_magenta ? "#bc9ed0",
            magenta ? "#9768b6",
            l_white ? "#ece3d5"
        }:

        nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"]
        (
            system:
            let
                pkgs = nixpkgs.legacyPackages.${system};
                lmagenta_oklch = nix-colorizer.hex.to.oklch l_magenta;
                magenta_saturated = nix-colorizer.oklch.to.hex (lmagenta_oklch // {C = 0.4;});
            in
            pkgs.stdenv.mkDerivation
            {
                pname = "rowaita-icon-theme";
                version = "1.2.5";
                src = ./.;
                dontCheckForBrokenSymlinks = true;
                
                buildPhase = ''
                    find Rowaita-Lavender-Dark -type f -name "*.svg" -exec sed -i "s/#8d5aaf/${magenta}/g" {} +
                    find Rowaita-Lavender-Dark -type f -name "*.svg" -exec sed -i "s/#b391ca/${l_magenta}/g" {} +
                    find Rowaita-Lavender-Dark -type f -name "*.svg" -exec sed -i "s/#e8e8e8/${l_white}/g" {} +
                    find Rowaita-Lavender-Dark -type f -name "*.svg" -exec sed -i "s/#ffffff/${l_white}/g" {} +
                    find Rowaita-Lavender-Dark -type f -name "*.svg" -exec sed -i "s/#9900ff/${magenta_saturated}/g" {} +
                    find Rowaita-Lavender-Dark -type f -name "*.svg" -exec sed -i "s/#b049f5/${magenta_saturated}/g" {} +

                    find Rowaita/scalable -type f -name "*.svg" -exec sed -i "s/#8d5aaf/${magenta}/g" {} +
                    find Rowaita/scalable -type f -name "*.svg" -exec sed -i "s/#b391ca/${l_magenta}/g" {} +
                    find Rowaita/scalable -type f -name "*.svg" -exec sed -i "s/#e8e8e8/${l_white}/g" {} +
                    find Rowaita/scalable -type f -name "*.svg" -exec sed -i "s/#ffffff/${l_white}/g" {} +
                    find Rowaita/scalable -type f -name "*.svg" -exec sed -i "s/#9900ff/${magenta_saturated}/g" {} +
                    find Rowaita/scalable -type f -name "*.svg" -exec sed -i "s/#b049f5/${magenta_saturated}/g" {} +
                '';

                installPhase = ''
                    mkdir -p $out/share/icons
                    cp -r Rowaita* $out/share/icons
                '';
            }
        );
    in
    {
        lib.mkTheme = mkTheme;
        packages = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux" ] (system: {
            default = (mkTheme {}).${system};
        });
    };
}
