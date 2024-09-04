#! /bin/bash

# Run rstudio server on the geomicro lab servers

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

apptainer exec \
    --env XDG_DATA_HOME=$XDG_DATA_HOME \
    --env R_LIBS_USER=/usr/local/lib/R/site-library \
    --env RSTUDIO_WHICH_R=/usr/local/bin/R \
    --env SINGULARITYENV_PASSWORD=r_login \
    --env SINGULARITYENV_USER=$USER \
    --bind /geomicro:/geomicro,/nfs:/nfs,${workdir}/run:/run,${workdir}/var-lib-rstudio-server:/var/lib/rstudio-server,${workdir}/database.conf:/etc/rstudio/database.conf,/etc/group:/etc/group,/etc/passwd:/etc/passwd \
    --cleanenv \
    --disable-cache \
    docker://eandersk/r_microbiome \
    rserver \
        --auth-none=0 \
        --auth-pam-helper-path=pam-helper \
        --auth-stay-signed-in-days=30 \
        --auth-timeout-minutes=0 \
        --server-user=$USER \
        --www-port 8382

# --www-address=127.0.0.1 # to only make available on local machine (access via ssh port-forwarding)