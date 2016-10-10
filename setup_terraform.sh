## Setup terraform envvars
# Usage:
#	. ./setup_terraform.sh

export TF_VAR_number_of_workers=1
export TF_VAR_do_token=$(cat ./secrets/DO_TOKEN)

# ssh -V prints to stderr, redirect
ssh_ver=$(ssh -V 2>&1)
[[ $ssh_ver =~ OpenSSH_([0-9][.][0-9]) ]] && version="${BASH_REMATCH[1]}"
# if ssh version is under 6.9, use -lf, otherwise must use the -E version
if ! awk -v ver="$version" 'BEGIN { if (ver < 6.9) exit 1; }'; then
    export TF_VAR_ssh_fingerprint=$(ssh-keygen -lf ~/.ssh/id_rsa.pub | awk '{print $2}')
else
    export TF_VAR_ssh_fingerprint=$(ssh-keygen -E MD5 -lf ~/.ssh/id_rsa.pub | awk '{print $2}' | sed 's/MD5://g')
fi

