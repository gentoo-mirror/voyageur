#!/bin/bash

echo "Switching to libgnustep-cairo backend ..."
echo "defaults write NSGlobalDomain GSBackend libgnustep-cairo"
defaults write NSGlobalDomain GSBackend libgnustep-cairo

echo "Setting default fonts..."
defaults write NSGlobalDomain NSFont DejaVuSans
defaults write NSGlobalDomain NSBoldFont DejaVuSans-Bold
defaults write NSGlobalDomain NSUserFixedPitchFont DejaVuSansMono

