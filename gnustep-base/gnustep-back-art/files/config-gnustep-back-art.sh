#!/bin/bash

echo "Switching to libgnustep-art backend ..."
echo "defaults write NSGlobalDomain GSBackend libgnustep-art"
defaults write NSGlobalDomain GSBackend libgnustep-art

echo "Setting default fonts..."
defaults write NSGlobalDomain NSFont DejaVuSans
defaults write NSGlobalDomain NSBoldFont DejaVuSans-Bold
defaults write NSGlobalDomain NSUserFixedPitchFont DejaVuSansMono

