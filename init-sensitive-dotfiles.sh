#!/usr/bin/env bash

# Helper variables to make text bold
BOLD_START=$(tput bold)
BOLD_END=$(tput sgr0)

# Get path to directory of this file
ABSOLUTE_FILE_PATH="$(realpath "$0")"
CURRENT_DIR="$(dirname "$ABSOLUTE_FILE_PATH")"

cd "$CURRENT_DIR"

if ! [ -x "$HOME/.homesick/repos/homeshick/bin/homeshick" ]; then
  echo "ERROR: homeshick must be installed!" >&2
  echo "       Installation instructions:" >&2
  echo "       https://github.com/andsens/homeshick/wiki/Installation" >&2
  exit 1
fi

if ! [ -x "$(command -v ssh-keygen)" ]; then
  echo "ERROR: ssh-keygen must be installed!" >&2
  exit 1
fi

if ! [ -x "$(command -v ssh-keyscan)" ]; then
  echo "ERROR: ssh-keyscan must be installed!" >&2
  exit 1
fi

while [ $# -gt 0 ]; do
    case "$1" in
        -u|--username)
            USERNAME="$2"
            shift 2
            if [ $? -gt 0 ]; then
                echo "You must pass a GitHub username as second argument to -u or --username!" >&2
                exit 1
            fi
        ;;
        --username=*)
            USERNAME="${1#*=}"
            shift
        ;;
        -r|--repository)
            REPOSITORY="$2"
            shift 2
            if [ $? -gt 0 ]; then
                echo "You must pass the name of your sensitive dotfiles GitHub repository as second argument to -r or --repository!" >&2
                exit 1
            fi
        ;;
        --repository=*)
            REPOSITORY="${1#*=}"
            shift
        ;;
        *)
            if [ "${1// }" ]; then
                echo "unknown option: $1" >&2
                exit 1
            fi
            shift
        ;;
    esac
done

[ -z "$USERNAME" ] && echo -e "Please provide your GitHub username to the --username parameter!" >&2 && exit 1
[ -z "$REPOSITORY" ] && echo -e "Please provide the name of your sensitive dotfiles GitHub repository to the --repository parameter!" >&2 && exit

rm -rf ".git/" &>/dev/null
git init >/dev/null
git remote add origin "git@github.com:$USERNAME/$REPOSITORY.git"

SD_READONLY_CERT_PATH="/tmp/sd_readonly_cert"

ssh-keygen -t rsa -b 4096 -C "$USERNAME@sensitive-dotfiles" -P "" -f $SD_READONLY_CERT_PATH <<< y &>/dev/null
PRIVATE_KEY="$( awk 1 ORS='\\n' $SD_READONLY_CERT_PATH )"
PUBLIC_KEY="$( cat $SD_READONLY_CERT_PATH.pub )"
rm -f $SD_READONLY_CERT_PATH*

echo -e "\nCreate a new deploy key in your sensitive dotfiles repository: GitHub Repository -> Settings -> Deploy keys -> Add deploy key\n"
echo -e "\t${BOLD_START}Title:${BOLD_END} Sensitive Dotfiles Installation Key"
echo -e "\t${BOLD_START}Key:${BOLD_END} $PUBLIC_KEY\n"

cat > ./README.md << EOF

# ${USERNAME^} Sensitive Dotfiles

> This file was auto-generated with the \`./init-sensitive-dotfiles.sh\` script on $( date +'%F %H:%M' ).  
> Do not edit this file manually!

## Install sensitive dotfiles

Copy and paste the following commands into a terminal on your new or clean installed system (only \`sh\`, \`bash\` and \`fish\` shells are supported):

\`\`\`bash
export HISTCONTROL=ignorespace
 /bin/echo -e "$PRIVATE_KEY" > $SD_READONLY_CERT_PATH
 chmod 600 $SD_READONLY_CERT_PATH
 mkdir -p $HOME/.ssh
 ssh-keyscan github.com >> ~/.ssh/known_hosts
 GIT_SSH_COMMAND="ssh -i $SD_READONLY_CERT_PATH" git clone "git@github.com:$USERNAME/$REPOSITORY.git" ~/.homesick/repos/$REPOSITORY && ~/.homesick/repos/homeshick/bin/homeshick link $REPOSITORY
 rm -f $SD_READONLY_CERT_PATH
\`\`\`
EOF

if [ ! -d "./home" ]; then
    mkdir home
fi
if [ ! -d "$HOME/.ssh" ]; then
    mkdir -p $HOME/.ssh
fi
ssh-keyscan github.com >> $HOME/.ssh/known_hosts 2>/dev/null
