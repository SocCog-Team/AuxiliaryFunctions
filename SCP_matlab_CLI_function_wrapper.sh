#! /bin/bash

MATLAB_INVOCATION="matlab -r"
MATLAB_CMD_STRING="subject_bias_analysis_sm01()"
CALLINGDIR=$( pwd )


echo ${MATLAB_INVOCATION} "cd('${CALLINGDIR}'); SCP_analysis_CLI_wrapper('${MATLAB_CMD_STRING}')"
${MATLAB_INVOCATION} "cd('${CALLINGDIR}'); SCP_analysis_CLI_wrapper('${MATLAB_CMD_STRING}')"



exit 0

