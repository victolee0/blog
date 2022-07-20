#!/usr/bin/env sh

set -e

yarn build

cd .vuepress/dist

git init
git add -A
git commit -m 'deploy'

git push -f https://github.com/victolee0/victolee0.github.io.git main