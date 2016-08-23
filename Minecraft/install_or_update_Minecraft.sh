#!/bin/bash

# Copies Minecraft.app to the user's home folder in ~/Applications
# and registers it as a trusted applications.

# If the user does not have an ~/Applications folder, create it.
if [ ! -f ~/Applications ]; then
	/bin/mkdir ~/Applications
fi

# If the user does not already have Minecraft in their ~/Applications folder, copy it there and trust it.
# Otherwise, check to see if their version is outdated and copy in the new one (and trust it) if that is the case.
if [ ! -f ~/Applications/Minecraft.app ]; then
	/usr/bin/ditto /Library/LaunchAgentScripts/Minecraft_for_all_users/Minecraft.app ~/Applications/Minecraft.app
	register_trusted_cmd="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -R -f -trusted"
	application=~/Applications/Minecraft.app
	$register_trusted_cmd "$application"

	exit 0
else
	vAvailableVersion=`/usr/bin/defaults read /Library/FAA/LaunchAgentScripts/Minecraft_for_all_users/Minecraft.app/Contents/Info.plist CFBundleShortVersionString`
	vUserVersion=`/usr/bin/defaults read ~/Applications/Minecraft.app/Contents/Info.plist CFBundleShortVersionString`

	if [ "$vUserVersion" -lt "$vAvailableVersion" ]; then
		/usr/bin/ditto /Library/LaunchAgentScripts/Minecraft_for_all_users/Minecraft.app ~/Applications/Minecraft.app			
		register_trusted_cmd="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -R -f -trusted"
		application=~/Applications/Minecraft.app
		$register_trusted_cmd "$application"
	fi

	exit 0
fi
