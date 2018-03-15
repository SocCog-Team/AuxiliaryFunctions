#! /bin/bash
# helper function to pull from all relevant SCP repositories
# TODO also implement cloning


# allow to pass in the desired git command as first command line argument to this script
if [ ! $# == 1 ]; then
    # default to pull
    GITCOMMAND="pull"
else
    GITCOMMAND=${1}
fi

# prepend this in front of the SCP_REPOSITORY names to create the link for cloning
SCP_GITHUB_BASE_URL="https://github.com/SocCog-Team/"

SCP_REPOSITORY_LIST=( AuxiliaryFunctions SessionDataAnalysis eyetrackerDataAnalysis LogFileAnalysis coordination_testing )
CALLING_DIR=$( pwd )

for CUR_SCP_REPO in ${SCP_REPOSITORY_LIST[*]} ; do
    echo "Current repository to ${GITCOMMAND}: ${CUR_SCP_REPO}"

    case ${GITCOMMAND} in
	pull|push)
            cd ../${CUR_SCP_REPO}
    	    CURRENT_GIT_COMMANDLINE="git ${GITCOMMAND}"            
            echo "Executing: ${CURRENT_GIT_COMMANDLINE} in $( pwd )"
            ${CURRENT_GIT_COMMANDLINE}
            cd ${CALLING_DIR}
            ;;
        clone)
    	    # figure out whether we are called from AuxiliaryFunctions and cd one level down
    	    TMP=basename $( pwd )
    	    if ( "${TMP}" == "AuxiliaryFunctions" ) ; then
    		echo "Running script from inside a already cloned repository, moving up one level"
    		cd ..
    	    fi
    	    CURRENT_GIT_COMMANDLINE="git clone ${SCP_GITHUB_BASE_URL}${CUR_SCP_REPO}"
    	    echo ${CURRENT_GIT_COMMANDLINE}
    	    ${CURRENT_GIT_COMMANDLINE}
    	    ;;
    	*)
    	    echo "Git command ${GITCOMMAND} not handled yet, might this be a typo?"
    	    ;;
    esac    
    
done

