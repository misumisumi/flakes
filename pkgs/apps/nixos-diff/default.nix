{
  diffutils,
  nix,
  writeShellApplication,
  writers,
}:
let
  script = writers.writePython3 "format-nixpkgs-diff" { } (
    builtins.readFile ./format-nixpkgs-diff.py
  );
in
writeShellApplication {
  name = "nixos-diff";
  text = ''
    usage() {
      cat <<EOF # remove the space between << and EOF, this is due to web plugin issue
    Usage: ''$(
        basename "''${BASH_SOURCE[0]}"
      ) <cmd> from-path to-path [-h] [-v]

      Show the diff of two nix store paths

    Available options:

    -h, --help      Print this help and exit
    -v, --verbose   Print script debug info
    EOF
      exit
    }

    cleanup() {
      trap - SIGINT SIGTERM ERR EXIT
      # script cleanup here
    }

    msg() {
      echo >&2 -e "''${1-}"
    }

    die() {
      local msg=''$1
      local code=''${2-1} # default exit status 1
      msg "''$msg"
      exit "''$code"
    }

    parse_params() {
      # default values of variables set from params
      from_file=0
      FROMPATH=""
      TOPATH=""
      while (( $# > 0 )) do
        case "''${1-}" in
        -h | --help) usage ;;
        -v | --verbose) set -x ;;
        -f | --from-file) from_file=1;;
        -- ) break ;;
        -?*) break ;;
        *)
          FROMPATH="''${1-}"
          TOPATH="''${2-}"
          shift
        ;;
        esac
        shift
      done
      return 0
    }

    parse_params "''$@"

    if [ "''${from_file}" -eq 0 ]; then
      FROMTMP=$(mktemp)
      TOTMP=$(mktemp)
      ${nix}/bin/nix path-info -r "''${FROMPATH}" | cut -d'-' -f2- | sort | sed -e "s/-[a-z]\+$//g" | uniq > "''${FROMTMP}"
      ${nix}/bin/nix path-info -r "''${TOPATH}" | cut -d'-' -f2- | sort | sed -e "s/-[a-z]\+$//g" | uniq > "''${TOTMP}"
      FROMPATH=''${FROMTMP}
      TOPATH=''${TOTMP}
    fi
    ${diffutils}/bin/diff -y --suppress-common-lines "''${FROMPATH}" "''${TOPATH}"  | ${script} | column -t -c 80 -L

    [ -n "''${FROMTMP}" ] && rm "''${FROMTMP}"
    [ -n "''${TOTMP}" ] && rm "''${TOTMP}"
  '';
}
