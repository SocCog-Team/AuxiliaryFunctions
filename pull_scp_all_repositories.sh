#! /bin/bash
# helper function to pull from all relevant SCP repositories
# TODO also implement cloning



if [ ! $# == 1 ]; then
    GITCOMMAND="pull"
else
    GITCOMMAND=${1}
fi


SCP_REPOSITORY_LIST=( AuxiliaryFunctions SessionDataAnalysis eyetrackerDataAnalysis LogFileAnalysis coordination_testing )
CALLING_DIR=$( pwd )

for CUR_SCP_REPO in ${SCP_REPOSITORY_LIST[*]} ; do
    echo "Current repository to pull: ${CUR_SCP_REPO}"
    cd ../${CUR_SCP_REPO}
    echo "Executing: git ${GITCOMMAND} in $( pwd )"
    git ${GITCOMMAND}
    cd ${CALLING_DIR}
done

