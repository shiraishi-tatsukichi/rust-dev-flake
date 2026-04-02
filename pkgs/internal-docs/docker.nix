{
  pkgs,
  docs,
}:
let
  nginxConfig = pkgs.substituteAll {
    src = ./nginx.conf;
    inherit (pkgs) nginx;
    inherit docs;
  };
in
pkgs.dockerTools.buildLayeredImage {
  name = "internal-docs";
  tag = "latest";

  contents = [
    pkgs.nginx
    pkgs.fakeNss
  ];

  config = {
    Cmd = [
      "nginx"
      "-c"
      "${nginxConfig}"
    ];
    ExposedPorts = {
      "80/tcp" = { };
    };
  };
}
