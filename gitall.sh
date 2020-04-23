#!/bin/bash
cmd=$*
first_cmd=$1
gitPaths=`find . -type d -name "\.git" | sed -r "s/\.(\/|git)//g;/patches/d;/^\//d;/^$/d" | uniq`

for gitPath in ${gitPaths}
do
    cd ${gitPath} > /dev/null
    if [ "$first_cmd" != "diff" ];then
		echo "${gitPath}"
		git $cmd
	    cd - > /dev/null
        continue
    fi
	modifyFiles=`git status | sed -r '/^(\w|\s+\W|\s+deleted\:)/d;/(^$|.*patch$|\.gitignore$)/d;/modified\:/!d;s/(\s|modified\:)//g'`
	deletedFiles=`git status | sed -r '/^(\w|\s+\W|\s+modified\:)/d;/(^$|.*patch$|\.gitignore$)/d;/deleted\:/!d;s/(\s|deleted\:)//g'`
	addedFiles=`git status | sed -r '/^(\w|\s+\W|\s+modified\:|\s+deleted\:)/d;/(^$|.*patch$|\.gitignore$)/d;s/\s//g;s/newfile\://g'`

	if [ "x${modifyFiles}${deletedFiles}${addedFiles}" != "x" ];then
		echo "${gitPath}"
		git $cmd
	fi
	cd - > /dev/null
done
