#!/bin/bash -e

# Required by the python click framework.
export LC_ALL=C.UTF-8
export SNAPCRAFT_SETUP_CORE=1

# This tells snapcraft to include a manifest file in the snap
# detailing which packages were used to build the snap.
export SNAPCRAFT_BUILD_INFO=1

# If snapcraft ever encounters any bugs, we should force it to 
# auto-report silently rather than attempt to ask for permission
# to send a report.
export SNAPCRAFT_ENABLE_SILENT_REPORT=1

apt-get update

case "$JOB_TYPE" in 
    "stage")
        # Stage jobs build the snap locally and release it
        pushd /build > /dev/null
        unbuffer snapcraft clean
        unbuffer snapcraft
        popd > /dev/null
        pushd /build > /dev/null
        unbuffer snapcraft login --with /build/edgex-snap-store-login
        # Push the snap up to the store and release it on the specified
        # channel
        unbuffer snapcraft push "$SNAP_NAME"*.snap --release "$SNAP_CHANNEL" 
        # Also force an update of the meta-data
        unbuffer snapcraft push-metadata "$SNAP_NAME"*.snap --force
        popd > /dev/null
    ;;
    "release")
        # Release jobs will promote an already built snap revision
        # in the store to a channel.
        unbuffer snapcraft login --with /build/edgex-snap-store-login
        unbuffer snapcraft release "$SNAP_NAME" "$SNAP_REVISION" "$SNAP_CHANNEL"
    ;;
    *)
        # Do normal build and nothing else to verify the snap builds
        pushd /build > /dev/null
        unbuffer snapcraft clean
        unbuffer snapcraft
        popd > /dev/null
    ;;
esac