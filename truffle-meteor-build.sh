#!/bin/bash

# By Rob Myers <rob@robmyers.org>
# CC0 2016
# To the extent possible under law, the person who associated CC0 with this
# work has waived all copyright and related or neighboring rights to this work.

# We copy the .meteor/ dir from app/ into the specified environment's build/ dir
# then call meteor-build-client in there, building into a meteor/ directory
# next to build/ .

if [ "${1}" = "-h" ] || [ "${1}" = "--help" ]
then
    echo "Usage: truffle-meteor-build [environment]"
    echo "       Copies the .meteor directory from app into the truffle build,"
    echo "       then calls meteor-build-client."
    echo "ARGS:  [environment] - The truffle environment to use (default developmpment)."
    echo "       Make sure you have npm install -g meteor-build-client"
    echo "       and meteor init in the truffle app/ directory."
fi

environment="${1:-development}"
base_dir="$(pwd)"

if [ ! -f "${base_dir}/truffle.json" ]
then
    echo "Please call from within the top level of a Truffle project."
    exit 1
fi

app_dir="${base_dir}/app"
dot_metoer_dir="${app_dir}/.meteor"
environment_dir="${base_dir}/environments/${environment}"
truffle_build_dir="${environment_dir}/build"
meteor_build_dir="${environment_dir}/meteor"

if [ ! -d "${environment_dir}" ]
then
    echo "Cannot find directory for environment ${environment}."
    exit 1
fi

pushd "${base_dir}" > /dev/null
echo "Truffle: building ${environment} in ${truffle_build_dir}"
truffle build "${environment}"
cp -r "${app_dir}/.meteor" "${truffle_build_dir}"
pushd "${truffle_build_dir}" > /dev/null
echo "Meteor: building client in ${meteor_build_dir}"
meteor-build-client "${meteor_build_dir}" -p ''
popd > /dev/null
popd > /dev/null