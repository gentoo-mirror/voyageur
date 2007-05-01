#!/bin/bash

echo "Switching to libgnustep-cairo backend ..."
echo "defaults write NSGlobalDomain GSBackend libgnustep-cairo"
defaults write NSGlobalDomain GSBackend libgnustep-cairo

echo "Setting default fonts..."
defaults write NSGlobalDomain NSFont BitstreamVeraSans-Roman
defaults write NSGlobalDomain NSBoldFont BitstreamVeraSans-Bold
defaults write NSGlobalDomain NSUserFixedPitchFont BitstreamVeraSansMono-Roman

