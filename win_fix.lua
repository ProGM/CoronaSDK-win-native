function native.newTextField( left, top, width, height, listener )
	local group = display.newGroup( )
	group._selected = false
	group.text = ""
	local element = display.newText{
		text = "",
		x = left, y = top,
		width = width, height = height,
	}
	element:setFillColor( 1, 1, 1 )
	local bkg = display.newRect( left, top, width, height )
	bkg:setFillColor(0.5, 0.5, 0.5)
	group:insert(bkg)
	group:insert(element)
	function group:tap(e)
		bkg:setFillColor(0.3, 0.3, 0.3)
		group._selected = true
		local event = {name="userInput", target=group, phase="began"}
		group:dispatchEvent(event)
		return true
	end
	group:addEventListener( "tap", group )
	local function onKeyEvent( event )
		if not group._selected then return false end
		if event.phase == "up" then return false end
		if event.keyName == "deleteBack" then
			group.text = group.text:sub(0, #group.text - 1)
			element.text = group.text
			return true
		end			if event.keyName == "space" then
		event.keyName = " "
		end
		if event.keyName:len() > 1 then
			return false
		end
		if event.isShiftDown then
			event.keyName = event.keyName:upper()
		end

		group.text = group.text .. event.keyName
		element.text = group.text

		local event = {name="userInput", target=group, phase="editing", newCharacters = event.keyName}
		group:dispatchEvent(event)
	    return true
	end
	Runtime:addEventListener( "key", onKeyEvent )

	local function disableTap(e)
		bkg:setFillColor(0.5, 0.5, 0.5)
		group._selected = false
		local event = {name="userInput", target=group, phase="ended"}
		group:dispatchEvent(event)
		return true
	end
	if listener ~= nil then
		group:addEventListener( "userInput", listener )
	end
	Runtime:addEventListener( "tap", disableTap )
	group._old_removeSelf = group.removeSelf

	function group:removeSelf()
		Runtime:removeEventListener("tap", disableTap)
		Runtime:removeEventListener( "key", onKeyEvent )
		self:removeEventListener("tap", listener)
		self:_old_removeSelf()
	end
	return group
end
function native.newTextBox( left, top, width, height, listener )
	return native.newTextField( left, top, width, height, listener )
end
