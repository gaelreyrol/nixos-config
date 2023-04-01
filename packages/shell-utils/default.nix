{ writeShellApplication, symlinkJoin }:

let
  trace-symlink = writeShellApplication {
    name = "trace-symlink";
    text = ''
      readlinkWithPrint() {
          link=$(readlink "$1")
          p=$link
          [ -n "''${p##/*}" ] && p=$(dirname "$1")/$link
          echo "$p"
          [ -h "$p" ] && readlinkWithPrint "$p"
      }

      a=$1
      [ -e "$a" ] && {
          echo "$a"

          # extra print if one of the parent is also a symlink
          b=$(basename "$a")
          d=$(dirname "$a")
          p=$(readlink -f "$d")/$b
          [ "$a" != "$p" ] && echo "$p"

          # follows the symlink
          if [ -L "$p" ];then
              readlinkWithPrint "$p"
          fi
      }
    '';
  };
  trace-which = writeShellApplication {
    name = "trace-which";
    text = ''
      a=$(which "$1") && exec ${trace-symlink}/bin/trace-symlink "$a"
    '';
  };
in
symlinkJoin {
  name = "shell-utils";
  paths = [
    trace-symlink
    trace-which
  ];
}
