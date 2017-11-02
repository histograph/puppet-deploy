#!/usr/bin/env bash
# run as root
echo
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo "  ---%%%%%%%%%% SETTING HOSTNAME %%%%%%%%%%---"
echo "  ---%%%%%%%%%% ${1} %%%%%%%%%%---"
echo "  ---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---"
echo

# set -x
hostname "${1}"

