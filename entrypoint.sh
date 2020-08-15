#!/bin/bash


# (Execute inside a Docker Container)
# ==================================
UPLOAD_FILE="$1"
GITHUB_USERNAME="$2"
GITHUB_REPO="$3"
USER_EMAIL="$4"
TARGETDIR="$5"

REMOTE_REPO="git@github.com:${GITHUB_USERNAME}/${GITHUB_REPO}.git"
HTTPS_REMORE="https://github.com/${GITHUB_USERNAME}/${GITHUB_REPO}.git"
# ==================================


# Setup Git Repository =============
git clone ${HTTPS_REMORE}
ls -l .
# git submodule add ${HTTPS_REMORE}
cd ${GITHUB_REPO}
git config --local pull.rebase false
git config --local user.name "${GITHUB_USERNAME}"
git config --local user.email "${USER_EMAIL}"
git checkout master
# ==================================

mkdir -p "${TARGETDIR}"


# Get file =========================
touch "${TARGETDIR}/${UPLOAD_FILE}"
cat > "./${UPLOAD_FILE}" << EOF
<html>
<head>
<title>Document</title>
</head>
<body>
This is test.
</body>
</html>
EOF

mv "./${UPLOAD_FILE}" "${TARGETDIR}/${UPLOAD_FILE}"
# ==================================

# Commit to Another Repository =====
origin="https://${GITHUB_ACTOR}:${GH_DEPLOY_TOKEN}@github.com/${GITHUB_USERNAME}/${GITHUB_REPO}.git"
cd ${GITHUB_REPO}/
git pull $origin master
git add .
git commit -m "Deploy ${GITHUB_SHA} by GitHub Actions"
git push $origin master
# ==================================


# Clean Up =========================
cd ..
git submodule deinit --all
git rm ${GITHUB_REPO}
git rm --cached .gitmodules && rm .gitmodules
# ==================================

