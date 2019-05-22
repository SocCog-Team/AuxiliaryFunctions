#! /bin/bash

MATLAB_INVOCATION="matlab -r"
# command line only
MATLAB_INVOCATION="matlab -nojvm -nodisplay -nosplash -r"

MATLAB_CMD_STRING="subject_bias_analysis_sm01(0)"
CALLINGDIR=$( pwd )


echo ${MATLAB_INVOCATION} "cd('${CALLINGDIR}'); SCP_analysis_CLI_wrapper('${MATLAB_CMD_STRING}')"
${MATLAB_INVOCATION} "cd('${CALLINGDIR}'); SCP_analysis_CLI_wrapper('${MATLAB_CMD_STRING}')"



exit 0

