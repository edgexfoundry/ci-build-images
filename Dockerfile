FROM ubuntu:18.04

# Allow specifying the architecture from the build arg command line (edgeXDocker.build passes this in)
# https://github.com/edgexfoundry/edgex-global-pipelines/blob/master/vars/edgeXDocker.groovy#L37
ARG ARCH

# The following snippet is essentially the same as the upstream dockerfile
# here: https://github.com/snapcore/snapcraft/blob/master/docker/stable.Dockerfile
# except we also specify the architecture to download so that this works
# on other architectures like arm64, etc.
# Basically, we send a command to the snap store for the info on the core +
# snapcraft snaps, extract the download link from the JSON result and then 
# download and extract the snaps into the docker container.
# We do this because we can't easily run snapd (and thus snaps) inside a 
# docker container without disabling important security protections enabled 
# for docker containers.
# Note that now snapcraft depends on snapd for the "snap pack" command, so we 
# have to also install snapd as an apt package, even though snapd is not 
# functional inside the docker container, we do this last so it doesn't get 
# cleaned up
# TODO: add a little bit of error checking for the curl calls in case we ever
# are on a proxy or something and we end up downloading a login page or
# or something like that
RUN apt-get update && \
    apt-get dist-upgrade --yes && \
    apt-get install --yes \
    curl sudo jq squashfs-tools && \
    for thesnap in core core18 snapcraft; do \
        dlUrl=$(curl -s -H 'X-Ubuntu-Series: 16' -H "X-Ubuntu-Architecture: $ARCH" "https://api.snapcraft.io/api/v1/snaps/details/$thesnap" | jq '.download_url' -r) && \
        dlSHA=$(curl -s -H 'X-Ubuntu-Series: 16' -H "X-Ubuntu-Architecture: $ARCH" "https://api.snapcraft.io/api/v1/snaps/details/$thesnap" | jq '.download_sha512' -r) && \
        curl -s -L $dlUrl --output $thesnap.snap && \
        echo "$dlSHA $thesnap.snap" > $thesnap.snap.sha512 && \
        sha512sum -c $thesnap.snap.sha512 && \
        mkdir -p /snap/$thesnap && \
        unsquashfs -n -d /snap/$thesnap/current $thesnap.snap && \
        rm $thesnap.snap.sha512 && \
        rm $thesnap.snap; \
    done && \
    apt remove --yes --purge curl jq squashfs-tools && \
    apt-get autoclean --yes && \
    apt-get clean --yes && \
    apt-get install snapd --yes

# The upstream dockerfile just uses this file locally from the repo since it's
# in the same build context, but rather than copy that file here into the 
# build context before running, we can just download it from github directly
# While unlikely, it is possible that the file location could move in the 
# upstream git repo on the master branch, so for stability in our builds, just
# hard-code the git commit that most recently updated this file as the 
# revision to download from.
# Note: If this script ever breaks with the version of snapcraft we downloaded
# above, try updating this Dockerfile to do same as whatever the upstream
# docker image does
ADD https://raw.githubusercontent.com/snapcore/snapcraft/25043ab3667d24688b3d93dcac9f9a74f35dae9e/docker/bin/snapcraft-wrapper /snap/bin/snapcraft
RUN sed -i -e "s@\"amd64\"@$ARCH@" /snap/bin/snapcraft && chmod +x /snap/bin/snapcraft

# Snapcraft will be in /snap/bin, so we need to put that on the $PATH
ENV PATH=/snap/bin:$PATH

COPY ./entrypoint.sh /

# Run the entrypoint.sh script to actually perform the build when the
# container is run
WORKDIR /build
ENTRYPOINT [ "/entrypoint.sh" ]