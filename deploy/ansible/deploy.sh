#!/bin/bash

function help() {
    echo "deploy: helper to deploy PIALAB with ansible with common parameters"
    echo "Usage:"
    echo "deploy staging|prod [fast] [cmd] [-b BRANCH] [EXTRA-ARGS]"
    echo ""
    echo "target: staging|prod - specify to which server you want to deploy;"
    echo "                       this also select the appropriate branch (staging"
    echo "                       or master, resp.)"
    echo "fast: (optional)     - toggles fast deployment"
    echo "cmd: don't run, display command that would be run"
    echo "EXTRA-ARGS: additional parameters to pass to ansible-playbook"
}

ANSIBLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

FAST_OR_FULL="full"

# parse options
for i in $@; do
    case $i in
    fast)
        FAST="FAST_DEPLOYMENT=True"
        FAST_OR_FULL="fast"
        ;;
    staging)
        TARGET=staging
        TARGET_BRANCH=dev
        ;;
    prod)
        TARGET=prod
        TARGET_BRANCH=master
        ;;
    cmd)
        SHOW_COMMAND=1
        ;;
    -b=*)
        OVERRIDE_TARGET_BRANCH="${i#*=}"
        ;;
    *)
        OPTIONS="$OPTIONS $i"
        ;;
    esac
done

if [ $OVERRIDE_TARGET_BRANCH ]; then
    TARGET_BRANCH=$OVERRIDE_TARGET_BRANCH
fi

if [ -z ${TARGET+x} ]; then
    help
    exit 1
fi

echo "deploying PIALAB to $TARGET, $FAST_OR_FULL mode"

echo "git fetch..."
git fetch origin
echo ""

HOSTS=${ANSIBLE_DIR}/hosts.yml
BRANCH=$(git rev-parse --abbrev-ref HEAD)
VAULT_PASSWORD_METHOD=prompt
VAULT_PASSWORD_FILE=${ANSIBLE_DIR}/vault-password
PLAYBOOK=${ANSIBLE_DIR}/playbook-$TARGET.yml

# git: repport uncommited changes
if ! git diff-index --quiet HEAD; then
    echo "WARNING: you have uncommited changes. CTRL+C to abort and commit changes"
    git status
else
    echo "git looks ok"
fi

# git: check local is up-to-date with remote
if [ x"$(git rev-parse $BRANCH)" != x"$(git rev-parse origin/$BRANCH)" ]; then
    echo "your local branch $BRANCH is not in sync with the remote branch origin/$BRANCH"
    echo "you probably need to do a git pull / push"
    echo "aborting"
    exit 1
fi

if [ "$BRANCH" != "$TARGET_BRANCH" ]; then
    echo "Only branch *${TARGET_BRANCH}* can be deployed in $TARGET"
    exit 1
fi

if [ -f ${VAULT_PASSWORD_FILE} ]; then
    VAULT_PASSWORD_METHOD=${VAULT_PASSWORD_FILE}
else
    echo "Vous pouvez sauvegarder le mot de passe du vault ansible dans le fichier vault-password.\
  Sinon il vous sera demandé par ansible à chaque déploiement."
fi

if [ $SHOW_COMMAND ]; then
    echo ""
    echo "you have requested to print the ansible command, here it is. I'm not running it.\r"
    echo "## ansible-playbook $PLAYBOOK -i $HOSTS --extra-vars=\"GIT_BRANCH=${BRANCH} ${FAST}\" --ssh-extra-args=\"-o ForwardAgent=yes\" --vault-id $VAULT_PASSWORD_METHOD ${OPTIONS}"
    echo ""
    exit 0
fi

echo ""
echo "Deploy PIALAB to $TARGET ($PLAYBOOK $HOSTS)"
echo " using mode $FAST_OR_FULL"
echo ""
echo "BRANCH : <$BRANCH>"
echo ""
read -p "Do you confirm? (y/N): " -r

if [[ $REPLY =~ ^([Yy](es)?|Y(ES)?)$ ]]; then
    echo 'go'
    set -x
    ansible-playbook $PLAYBOOK -i $HOSTS --extra-vars="GIT_BRANCH=${BRANCH} ${FAST}" --ssh-extra-args="-o ForwardAgent=yes" --vault-id $VAULT_PASSWORD_METHOD ${OPTIONS}

    set +x
    echo ""
    echo "*** DEPLOYMENT COMPLETE ! ***"
    echo ""

else
    echo "ok bye!"
    exit 1
fi
