#!/bin/sh

ln -ivs $(pwd)/gitconfig ~/.gitconfig
ln -ivs $(pwd)/git_aliases ~/.git_aliases
ln -ivs $(pwd)/vimrc ~/.vimrc

pushd ~
git clone-linus
pushd linux
git add-tyreld
git fetch tyreld
git add-suse
git fetch suse
popd
git clone-fio
git clone-ppcutils
git clone-librtas
git clone-diag
popd
