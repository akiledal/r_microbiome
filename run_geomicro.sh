#! /bin/bash

# Run rstudio server on the geomicro lab servers

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
echo "Building container $script_dir/r_microbiome.sif"

export PROOT_NO_SECCOMP=1

apptainer build --ignore-proot $script_dir/r_microbiome.sif docker://eandersk/r_microbiome

# To use mEQO's Gurobi solver, provide a license file (free for academic use:
# https://www.gurobi.com/academia/academic-program-and-licenses/) and uncomment below,
# adding `--env GRB_LICENSE_FILE=/opt/gurobi/gurobi.lic` and the bind mount to the
# apptainer exec call:
#   --env GRB_LICENSE_FILE=/opt/gurobi/gurobi.lic \
#   --bind /path/to/your/gurobi.lic:/opt/gurobi/gurobi.lic \


apptainer exec \
    --disable-cache \
    --env XDG_DATA_HOME=$XDG_DATA_HOME \
    --env R_LIBS_USER=/usr/local/lib/R/site-library \
    --env RSTUDIO_WHICH_R=/usr/local/bin/R \
    --env SINGULARITYENV_PASSWORD=r_login \
    --env SINGULARITYENV_USER=$USER \
    --bind /geomicro:/geomicro,/nfs:/nfs,${workdir}/run:/run,${workdir}/var-lib-rstudio-server:/var/lib/rstudio-server,${workdir}/database.conf:/etc/rstudio/database.conf \
    --cleanenv \
    $script_dir/r_microbiome.sif \
    rserver \
        --auth-none=0 \
        --auth-pam-helper-path=pam-helper \
        --auth-stay-signed-in-days=30 \
        --auth-timeout-minutes=0 \
        --server-user=$USER \
        --www-port 4787

# --www-address=127.0.0.1 # Use to access only from localhost via ssh port forwarding
