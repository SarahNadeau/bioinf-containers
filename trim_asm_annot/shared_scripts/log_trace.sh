# Redirect trace to a log file
exec 608> "${O}/.log/TrimAsmAnnot.${B}.log"
BASH_XTRACEFD=608
PS4="+ $(date "+%a %d-%^b-%Y %H:%M:%S") "
set -x