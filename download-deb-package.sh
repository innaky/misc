#!/bin/sh

if [ $# -ne 1 ]; then
  prog=`basename ${0}`
  echo "usage: ${prog} <package>"
  exit 1
fi

TMP=`mktemp -t a.sh.XXXXXX`
trap "rm $TMP* 2>/dev/null" 0

check_virtual_package()
{
  apt show $1 2> /dev/null | grep "not a real package" > /dev/null
  return $?
}

get_provide_package()
{
  apt install -s $1 > ${TMP} 2> /dev/null

  local state=0
  local pkgs=""
  while read line; do
    if [ "${line}x" = "Package $1 is a virtual package provided by:x" ]; then
      state=1
    elif [ ${state} -eq 1 -a -n "${line}" ]; then
      pkg=`echo ${line} | awk '{ print $1 }'`
      echo ${pkg} | grep -v ':i386' > /dev/null && pkgs="${pkg} ${pkgs}"
    fi
  done < ${TMP}

  echo "${pkgs}"
}

get_depend_package()
{
  local pkgs=""
  local pkg=""

  for pkg in `apt-rdepends $1 2> /dev/null | grep -v "^  "`; do
    check_virtual_package ${pkg}
    if [ $? -eq 0 ]; then
      pkg=`get_provide_package ${pkg}`
    fi
    pkgs="${pkgs} ${pkg}"
  done

  echo "${pkgs}"
}

download_deb_package()
{
  local pkgs=""
  pkgs=`get_depend_package $1`
  apt download ${pkgs}
}

download_deb_package $1
