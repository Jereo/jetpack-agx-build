#!/bin/bash
first_cmd=$1
TOP=$(pwd)

if [ "$first_cmd" == "4.2.2" ];then
    git_repo="origin/l4t/l4t-r32.2"
else if [ "$first_cmd" == "4.3" ];then
    git_repo="origin/l4t/l4t-r32.3.1"
else if [ "$first_cmd" == "4.4" ];then
    git_repo="origin/l4t/l4t-r32.4.2"
else
    echo "Please Input correct version of Jetpack."
fi
cd ${TOP}/../sources

gitPaths=`find . -type d -name "\.git" | sed -r "s/\.(\/|git)//g;/patches/d;/^\//d;/^$/d" | uniq`

for gitPath in ${gitPaths}
do
    gitbranch=${git_repo}
    cd ${gitPath} > /dev/null
    result=`echo ${gitPath} | grep "kernel-[0-9].[0-9]"`
    if [ "x${result}" != "x" ];then
        echo "${gitPath}"
        gitbranch=${git_repo}-4.9
    fi
<<<<<<< HEAD

    result=`echo ${gitPath} | grep "jakku"`
    if [ "x${result}" != "x" -a "$first_cmd" != "4.4" ];then
        echo "${gitPath}"
        gitbranch=master
    fi

=======
>>>>>>> 4b1f2553ba80bce0f4ffda9ffc1447fb3dc6eeda
    temp_branch="temp_branch"
    result=`git branch | grep "${gitbranch}"`
    if [ "x${result}" != "x" ];then
        git checkout -b ${temp_branch}
        git branch -D ${gitbranch}
    fi
    git checkout -b ${gitbranch} ${gitbranch}
    if [ "x${temp_branch}" != "x" ];then
        git branch -D ${temp_branch}
    fi
    cd - > /dev/null
done
