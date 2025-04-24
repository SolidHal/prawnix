{ inputs, pkgs, ... }:

let
  host_sway_conf = (pkgs.writeTextFile {
    name = "host_sway_conf";
    text = ''

# prawnix specific sway configuration
# resolution and scaling
output * scale 1.0

    '';
  });
in

{
  imports = [
    (inputs.solidnix + /modules/sway/default.nix)
  ];

  # install the sway config
  # this gets picked up by sway default.nix
  environment.etc = {
    "xdg/sway/sway.conf".source = (
      pkgs.concatTextFile {
        name = "sway.conf";
        files = [ (inputs.solidnix + /modules/sway/sway.conf) host_sway_conf ];
      });
  };

}
