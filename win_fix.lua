local _SELECTED = nil


function native.newTextField( left, top, width, height, listener )
	local group = display.newGroup( )
	group._selected = false
	local element = display.newText{
		text = "",
		x = left, y = top,
		width = width, height = height,
		fontSize=16
	}
	element:setFillColor( 0, 0, 0 )
	local bkg = display.newRect( left, top, width, height )
	bkg:setFillColor(0.7, 0.7, 0.7)
	bkg:setStrokeColor( 0, 0, 0 )
	bkg.strokeWidth = 1
	group:insert(bkg)
	group:insert(element)
	function group:tap(e)
		if _SELECTED ~= nil then
			_SELECTED:_setSelected(false)
		end
		self:_setSelected(true)
		local event = {name="userInput", target=group, phase="began"}
		group:dispatchEvent(event)
		return true
	end
	group:addEventListener( "tap", group )

	function group:_setSelected(bool)
		if bool then
			bkg:setFillColor(1, 1, 1)
			_SELECTED = self
		else
			local event = {name="userInput", target=self, phase="ended"}
			self:dispatchEvent(event)
			bkg:setFillColor(0.7, 0.7, 0.7)
			if _SELECTED == self then
				_SELECTED = nil
			end
		end
		self._selected = bool
	end

	group._old_removeSelf = group.removeSelf

	function group:removeSelf()
		self:_setSelected(false)
		self:removeEventListener("tap", listener)
		self:_old_removeSelf()
	end

	if listener ~= nil then
		group:addEventListener( "userInput", listener )
	end

	local mt = getmetatable( group )
	local newMT = {}
	for k,v in pairs(mt) do
		newMT[k] = v
	end
	local oldn = newMT.__newindex
	local old = newMT.__index
	function newMT.__index(table, key)
		if key == "text" then
			return element.text
		end
		return old(table, key)
	end
	function newMT.__newindex(table, key, value)
		if key == "text" and value then
			element.text = value
			table[key] = nil
			return false
		end
		oldn(table, key, value)
	end
	setmetatable( group, newMT )

	return group
end
function native.newTextBox( left, top, width, height, listener )
	return native.newTextField( left, top, width, height, listener )
end


local function onKeyEvent( event )
	if _SELECTED == nil then return false end
	if event.phase == "up" then return false end
	if event.keyName == "deleteBack" then
		_SELECTED.text = _SELECTED.text:sub(0, #_SELECTED.text - 1)
		return true
	end
	if event.keyName == "space" then
		event.keyName = " "
	end
	if event.keyName:len() > 1 then
		return false
	end
	if event.isShiftDown then
		event.keyName = event.keyName:upper()
	end
	local newText = _SELECTED.text .. event.keyName
	local event = {name="userInput", target=_SELECTED, phase="editing", newCharacters = event.keyName, oldText = _SELECTED.text, startPosition = #_SELECTED.text, text = newText}
	_SELECTED.text = newText
	_SELECTED:dispatchEvent(event)
    return true
end
Runtime:addEventListener( "key", onKeyEvent )

local function disableTap(e)
	if _SELECTED == nil then return false end
	_SELECTED:_setSelected(false)
	return true
end
Runtime:addEventListener( "tap", disableTap )

