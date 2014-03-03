CoronaSDK-win-native
====================

A simple integration to Corona SDK to enable a simulated TextField on Windows.
It's quite raw and buggy, actually, but it can be useful ;)


## HOWTO: ##

Add this two lines on your main.lua:

    if "Win" == system.getInfo( "platformName" ) then
    	require("windows_fix")
    end
