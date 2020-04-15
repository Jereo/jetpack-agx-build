#!/bin/bash
################################################################################
##
## To support:
##  1. bspsetup: toolchain, kernel and u-boot source setup
##  2. l4tout_setup: setup Linux_for_Tegra
##
################################################################################

function _later_check()
{
	[ -d $L4TOUT ] || (echo "${red} _early_check failed${normal}" && return 1)
	[ -f ${KERNEL_TOOLCHAIN}gcc ] || (echo "${red} ${KERNEL_TOOLCHAIN}gcc check failed${normal}" && return 1)
	[ -f ${BSP_TOOLCHAIN}gcc ] || (echo "${red} ${BSP_TOOLCHAIN}gcc check failed${normal}" && return 1)
	[ -d $KERNEL_PATH ] || (echo "$KERNEL_PATH check failed${normal}" && return 1)
}

function _toolchain_setup()
{
	# for bsp
	if [ ! -f ${BSP_TOOLCHAIN}gcc ]
	then
		if [ ! -f ${BSP_TOOLCHAIN}gcc ] && [ -x $BSP_TOOLCHAIN_ROOT/make-arm-hf-toolchain.sh ]
		then
			pushd $BSP_TOOLCHAIN_ROOT &> /dev/null
			edo ./make-arm-hf-toolchain.sh
			popd &> /dev/null
		fi
	fi

	# for kernel
	if [ ! -f ${KERNEL_TOOLCHAIN}gcc ]
	then
		if [ ! -f ${KERNEL_TOOLCHAIN}gcc ] && [ -x $KERNEL_TOOLCHAIN_ROOT/make-aarch64-toolchain.sh ]
		then
			pushd $KERNEL_TOOLCHAIN_ROOT &> /dev/null
			edo ./make-aarch64-toolchain.sh
			popd &> /dev/null
		fi
	fi
}

function _sources_setup()
{
    echo "Doing nothing!!"
}

function l4tout_setup()
{
	pushd $L4TOUT &> /dev/null
	edo sudo ./apply_binaries.sh
	popd &> /dev/null

	sync
}

function bspsetup()
{
	if [ ! -d $L4TOUT ]
	then
		echo "${red}Linux_for_Tegra is missing."
        echo "plaese run  \"${yel}l4tout_setup${red}\" to setup${normal}"
		return 1;
	fi

	## Toolochain
	mkdir -p $KERNEL_TOOLCHAIN_ROOT
	mkdir -p $BSP_TOOLCHAIN_ROOT
	mkdir -p $KERNEL_ROOT
	mkdir -p $CBOOT_ROOT

	_toolchain_setup && _sources_setup

	_later_check || (echo "${red}_later_check failed, BSP setup failed!${normal}" && return 1)

	echo "${mag}BSP setup successfully!${normal}"; echo
}

echo -e "${red}l4tout_setup${normal}: \t\tsetup Xavier/Linux_for_Tegra"
