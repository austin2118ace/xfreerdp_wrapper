#!/bin/bash
# xfreerdp wrapper for Dewan Lab Computers
# Austin Pauley, 12-30-25

# List of computers
declare -A computers
computers[1]="psy-pdb-c474b"
computers[2]="psy-pdb-c474-1"
computers[3]="psy-pdb-c474-2"
computers[4]="psy-pdb-c474-3"
computers[5]="psy-pdb-c152-1"
computers[6]="psy-pdb-c152-2"
computers[7]="psy-pdb-c152-3"
computers[8]="psy-pdb-c152-4"
computers[9]="psy-pdb-c152-5"
computers[10]="psy-pdb-c152-6"
computers[11]="psy-pdb-c152-7"
computers[12]="psy-pdb-c152-8"
computers[13]="psy-pdb-gonk-w1"

# List of monitor resolutions
declare -A resolutions
resolutions[1]="3440x1440-Main"
resolutions[2]="1920x1200-Laptop"
resolutions[3]="1920x1080-Side"
resolutions[4]="2560x1600-Laptop_No_Monitor"

# Sort and print list of computers
sorted_keys=$(printf "%s\n" "${!computers[@]}" | sort -n)
echo "Please select a computer from the list below: "
for key in $sorted_keys; do
    echo "$key. ${computers[$key]}"
done
read computer_selection

# Check computer selection is valid
if [[ ! -v computers[$computer_selection] ]]; then
    echo "Error: $computer_selection is not a valid selection!" >&2
    exit 1 
else
    computer_name=${computers[$computer_selection]}
    echo "$computer_name selected!"
fi

# Sort and print list of resolutions
sorted_keys=$(printf "%s\n" "${!resolutions[@]}" | sort -n)
echo "Please select a resolution from the list below: "
for key in $sorted_keys; do
    echo "$key. ${resolutions[$key]}"
done
read resolution_selection

# Check resolution selection is valid
if [[ ! -v resolutions[$resolution_selection] ]]; then
    echo "Error: $resolution_selection is not a valid selection!" >&2
    exit 1 
else
    resolution_full=${resolutions[$resolution_selection]}
    echo "$resolution_full selected!"
fi

# Split resolution description and resolution
resolution_description="${resolution_full##*-}"
resolution_wh="${resolution_full%-*}"

# Get username and domain
echo "Enter username with domain in form (username@domain): "
read user_w_domain

# Split username and domain
domain="${user_w_domain##*@}"
username="${user_w_domain%@*}"

args=("/v:$computer_name" "/u:$username" "/log-level:ERROR" "/network:lan" "/f" "/floatbar:sticky:on,default:visible,show:always" "/bpp:32" "/scale-desktop:200" "/rfx" "/rfx-mode:video" "/gdi:hw" "+dynamic-resolution" "+clipboard" "+fonts" "+wallpaper" "+window-drag" "+menu-anims" "+aero")

# Is host reachable? If not use the remote terminal
if [[ -z $(dig +short $computer_name) ]]; then
    # If username and domain matches then there is no @ sign in the input
    args+=("/gateway:g:psyterm.psy.fsu.edu,u:acp18,d:fsu")
fi

if [[ "$username" != "$domain" ]]; then
    # If different use the domain
    args+=("/d:$domain")
else
    # If the same then use the computer name as the domain for a local account
    args+=("/d:$computer_name")
fi

xfreerdp "${args[@]}"

