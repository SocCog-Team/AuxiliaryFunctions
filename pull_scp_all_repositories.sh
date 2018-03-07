#! /bin/bash
# helper function to pull from all relevant SCP repositories
# TODO also implement cloning


SCP_REPOSITORY_LIST=( AuxiliaryFunctions SessionDataAnalysis eyetrackerDataAnalysis LogFileAnalysis coordination_testing )
CALLING_DIR=$( pwd )

for CUR_SCP_REPO in ${SCP_REPOSITORY_LIST[*]} ; do
    echo "Current repository to pull: ${CUR_SCP_REPO}"
    cd ../${CUR_SCP_REPO}
    echo "git pull"
    git pull
    cd ${CALLING_DIR}
done

