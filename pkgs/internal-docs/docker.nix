{
  pkgs,
  docs,
}:
let
  nginxConfig = pkgs.writeText "nginx.conf" (
    builtins.replaceStrings [ "@nginx@" "@docs@" ] [ "${pkgs.nginx}" "${docs}" ] (
      builtins.readFile ./nginx.conf
    )
  );
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
      "${pkgs.nginx}/bin/nginx"
      "-c"
      "${nginxConfig}"
    ];
    ExposedPorts = {
      "80/tcp" = { };
    };
    User = "nginx";
  };
}
