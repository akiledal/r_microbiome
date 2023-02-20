#! /bin/bash

# Run rstudio server on the geomicro lab servers

cd $HOME

export R_LIBS_USER="/usr/local/lib/R/site-library"
export RSTUDIO_WHICH_R="/usr/local/bin/R"
export SINGULARITYENV_PASSWORD="r_login"
export SINGULARITYENV_USER=$USER

workdir=rstudio_server
mkdir -p ${workdir}
mkdir -p -m 700 ${workdir}/run ${workdir}/tmp ${workdir}/var/lib/rstudio-server

.rstudio-desktop/

cat > ${workdir}/database.conf <<END
provider=sqlite
directory=/var/lib/rstudio-server
END

singularity exec \
    --env R_LIBS_USER=/usr/local/lib/R/site-library \
    --env RSTUDIO_WHICH_R=/usr/local/bin/R \
    --env SINGULARITYENV_PASSWORD=r_login \
    --env SINGULARITYENV_USER=$USER \
    --bind /geomicro:/geomicro,${workdir}/run:/run,${workdir}/var-lib-rstudio-server:/var/lib/rstudio-server,${workdir}/database.conf:/etc/rstudio/database.conf \
    --cleanenv \
    docker://eandersk/r_microbiome \
    rserver --www-address=127.0.0.1 \
        --auth-none=0 \
        --auth-pam-helper-path=pam-helper \
        --auth-stay-signed-in-days=30 \
        --auth-timeout-minutes=0 \
        --server-user=$USER \
        --www-port 8788