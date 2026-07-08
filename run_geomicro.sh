#! /bin/bash

# Run rstudio server on the geomicro lab servers

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Pulls and runs the eandersk/r_microbiome RStudio Server container via Apptainer.

Options:
  --use-cache   Reuse Apptainer's local image cache instead of forcing a fresh
                pull/convert of docker://eandersk/r_microbiome on every run
                (default: always pull fresh, i.e. --disable-cache).
  -h, --help    Show this help message and exit.
EOF
}

disable_cache_flag="--disable-cache"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --use-cache)
            disable_cache_flag=""
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage
            exit 1
            ;;
    esac
done

# Export the SIF container file to the same directory the script is in.
# This must run before `cd $HOME` below, since BASH_SOURCE may be a relative
# path that would otherwise resolve against the wrong directory.
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
#script_dir=$(dirname "$0")

cd $HOME

export R_LIBS_USER="/usr/local/lib/R/site-library"
export RSTUDIO_WHICH_R="/usr/local/bin/R"
export SINGULARITYENV_PASSWORD="r_login"
export SINGULARITYENV_USER=$USER
export XDG_DATA_HOME=$HOME/rstudio_server/$HOSTNAME

workdir=/tmp/${USER}_rstudio_server
mkdir -p ${workdir}
mkdir -p -m 700 ${workdir}/run ${workdir}/tmp ${workdir}/var-lib-rstudio-server $XDG_DATA_HOME

cat > ${workdir}/database.conf <<END
provider=sqlite
directory=/var/lib/rstudio-server
END

echo "script directory is: $script_dir"
echo "Pulling and running latest container from docker://eandersk/r_microbiome"

# Look up this server's RStudio port from servers.conf (hostname:port per line),
# falling back to the "default" entry if this host isn't listed.
server_config="$script_dir/servers.conf"
server_name=$(hostname -s)
www_port=$(awk -F: -v host="$server_name" '
    /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
    { gsub(/[ \t]/, "", $1); gsub(/[ \t]/, "", $2); if ($1 == host) { print $2; found=1; exit } }
' "$server_config")
if [[ -z "$www_port" ]]; then
    www_port=$(awk -F: '$1 == "default" { gsub(/[ \t]/, "", $2); print $2; exit }' "$server_config")
fi
echo "Detected server '$server_name', using RStudio port $www_port (see $server_config)"

# Modify how singularity is run
export PROOT_NO_SECCOMP=1
export APPTAINER_IGNORE_PROOT=1

# To use mEQO's Gurobi solver, provide a license file (free for academic use:
# https://www.gurobi.com/academia/academic-program-and-licenses/) and uncomment below,
# adding `--env GRB_LICENSE_FILE=/opt/gurobi/gurobi.lic` and the bind mount to the
# apptainer exec call:
#   --env GRB_LICENSE_FILE=/opt/gurobi/gurobi.lic \
#   --bind /path/to/your/gurobi.lic:/opt/gurobi/gurobi.lic \

apptainer exec \
    $disable_cache_flag \
    --env XDG_DATA_HOME=$XDG_DATA_HOME \
    --env R_LIBS_USER=/usr/local/lib/R/site-library \
    --env RSTUDIO_WHICH_R=/usr/local/bin/R \
    --env SINGULARITYENV_PASSWORD=r_login \
    --env SINGULARITYENV_USER=$USER \
    --bind /geomicro:/geomicro,/nfs:/nfs,${workdir}/run:/run,${workdir}/var-lib-rstudio-server:/var/lib/rstudio-server,${workdir}/database.conf:/etc/rstudio/database.conf,$script_dir/rsession.conf:/etc/rstudio/rsession.conf \
    --cleanenv \
    docker://eandersk/r_microbiome \
    rserver \
        --auth-none=0 \
        --auth-pam-helper-path=pam-helper \
        --auth-stay-signed-in-days=30 \
        --auth-timeout-minutes=0 \
        --server-user=$USER \
        --www-port $www_port

# --www-address=127.0.0.1 # Use to access only from localhost via ssh port forwarding
