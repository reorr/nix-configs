#!/usr/bin/env bash

mkdir -p ~/.config/home-manager

ln -sfn $(pwd)/home.nix ~/.config/home-manager/home.nix
