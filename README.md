CoronaSDK-win-native
====================

A simple integration to Corona SDK to enable a simulated TextField on Windows.
It's quite raw and buggy, actually, but it can be useful ;)


## HOW TO USE: ##
Download [win_fix.lua](https://raw.github.com/ProGM/CoronaSDK-win-native/master/win_fix.lua) file and add to your project directory, then add this on your main.lua:

    if "Win" == system.getInfo( "platformName" ) then
    	require("win_fix")
    end

## TODO LIST ##
 -  Implement all the parameters for the userInput event
 -  Implement copy/paste
 -  Implement symbols different from a-Z 0-9
