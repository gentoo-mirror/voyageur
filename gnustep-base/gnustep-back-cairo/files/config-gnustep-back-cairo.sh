#!/bin/bash

echo "Switching to libgnustep-cairo backend ..."
echo "defaults write NSGlobalDomain GSBackend libgnustep-cairo"
defaults write NSGlobalDomain GSBackend libgnustep-cairo

