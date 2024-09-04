#! /bin/bash

# Run rstudio server using Docker

cd $HOME

export R_LIBS_USER="/usr/local/lib/R/site-library"
export RSTUDIO_WHICH_R="/usr/local/bin/R"
export PASSWORD="r_login"
export USER=$USER
export XDG_DATA_HOME=$HOME/rstudio_server/$HOSTNAME

workdir=/tmp/${USER}_rstudio_server
mkdir -p ${workdir}
mkdir -p -m 700 ${workdir}/run ${workdir}/tmp ${workdir}/var-lib-rstudio-server $XDG_DATA_HOME

cat > ${workdir}/database.conf <<END
provider=sqlite
directory=/var/lib/rstudio-server
END

echo "Starting!"

## #-d \
# docker run --platform linux/x86_64 \
#     -p 8887:8787 \
#     -e XDG_DATA_HOME=$XDG_DATA_HOME \
#     -e R_LIBS_USER=/usr/local/lib/R/site-library \
#     -e RSTUDIO_WHICH_R=/usr/local/bin/R \
#     -e PASSWORD=r_login \
#     -e USER=$USER \
#     -e DISABLE_AUTH=true \
#     --user $UID:$GID \
#     -v ${workdir}/run:/run -v ${workdir}/var-lib-rstudio-server:/var/lib/rstudio-server -v ${workdir}/database.conf:/etc/rstudio/database.conf -v /etc/group:/etc/group -v /etc/passwd:/etc/passwd \
#     eandersk/r_microbiome \
#     rserver --www-address=127.0.0.1 \
#         --auth-none=0 \
#         --auth-pam-helper-path=pam-helper \
#         --auth-stay-signed-in-days=30 \
#         --auth-timeout-minutes=0 \
#         --server-user=$USER

docker run --platform linux/x86_64 \
    -p 8794:8787 \
    -e PASSWORD=r_login \
    -e DISABLE_AUTH=true \
    -v $HOME:/data \
    eandersk/r_microbiome


# docker run --rm \
#   --platform linux/x86_64 \
#   -p 8794:8787 \
#   -e PASSWORD=r_login \
#   -e DISABLE_AUTH=true \
#   eandersk/r_microbiome