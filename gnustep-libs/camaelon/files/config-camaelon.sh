echo "Applying Camaelon default theme..."
echo "defaults write NSGlobalDomain GSAppKitUserBundles \"(${GNUSTEP_SYSTEM_ROOT}/Library/Bundles/Camaelon.themeEngine)\""
defaults write NSGlobalDomain GSAppKitUserBundles "(${GNUSTEP_SYSTEM_ROOT}/Library/Bundles/Camaelon.themeEngine)"
echo "defaults write Camaelon Theme Nesedah"
defaults write Camaelon Theme Nesedah
