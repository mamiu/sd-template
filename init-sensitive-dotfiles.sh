#!/usr/bin/env bash

# helper variables to make text bold
bold_start=$(tput bold)
bold_end=$(tput sgr0)


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


ssh-keygen -t rsa -b 4096 -C "$USERNAME@sensitive-dotfiles" -P "" -f /tmp/sd_readonly_cert &>/dev/null
# awk 'BEGIN{printf "echo -e \""}{print $0}END{printf "\" > /tmp/sd_readonly_cert\n"}' ORS='\\\n' /tmp/sd_readonly_cert.pub
PRIVATE_KEY="$( awk 1 ORS='\\\n' /tmp/sd_readonly_cert.pub )"
PUBLIC_KEY="$( cat /tmp/sd_readonly_cert.pub )"
rm -f /tmp/sd_readonly_cert*

echo -e "$PRIVATE_KEY" > /tmp/sd_readonly_cert
chmod 600 /tmp/sd_readonly_cert
GIT_SSH_COMMAND="ssh -i /tmp/sd_readonly_cert" git clone "git@github.com:$USERNAME/$REPOSITORY.git" ~/.homesick/repos/sd
rm -f /tmp/sd_readonly_cert
history clear &>/dev/null || history -c &>/dev/null && history -w &>/dev/null
homeshick link sd
