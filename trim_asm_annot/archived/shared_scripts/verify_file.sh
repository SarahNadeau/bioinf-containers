verify_file()
{
  # $1=filename; $2=file description
  # $3=size in Bytes (requires c, k, M, or G prefix)
  if [ -f  "${1}" ]; then
    if [ -s  "${1}" ]; then
      if [[ $(find -L "${1}" -type f -size +"${3}") ]]; then
        :
      else
        echo "ERROR: ${2} file ${1} present but < ${3}B" >&2
        exit 1
      fi
    else
      echo "ERROR: ${2} file ${1} present but empty" >&2
      exit 1
    fi
  else
    echo "ERROR: ${2} file ${1} absent" >&2
    exit 1
  fi
}