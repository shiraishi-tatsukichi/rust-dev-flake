{
  pkgs,
  docs,
}:
let
  # nginx ユーザー/グループを定義するための /etc/passwd と /etc/group
  userContents = pkgs.runCommand "user-contents" { } ''
    mkdir -p $out/etc
    echo "nginx:x:1000:1000:Nginx user:/var/empty:/bin/sh" > $out/etc/passwd
    echo "nginx:x:1000:" > $out/etc/group
  '';

  # substituteAll の代わりに writeText を使用して文字列展開を確実にする
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
    userContents
  ];

  # Nginxが起動時に期待するディレクトリをあらかじめ作成する
  # さらに、非ルートユーザー(1000)でも書き込めるように権限(1777)を設定
  extraCommands = ''
    mkdir -p tmp/nginx_client_body
    mkdir -p var/log/nginx
    mkdir -p var/cache/nginx
    chmod -R 1777 tmp var/log/nginx var/cache/nginx
  '';

  config = {
    Cmd = [
      "${pkgs.nginx}/bin/nginx"
      "-c"
      "${nginxConfig}"
    ];
    ExposedPorts = {
      "80/tcp" = { };
    };
    # UID:GID で実行
    User = "1000:1000";
  };
}
