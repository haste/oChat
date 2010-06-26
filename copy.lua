local borderManipulation = function(...)
	for l = 1, select("#", ...) do
		local obj = select(l, ...)
		if(obj:GetObjectType() == "FontString" and obj:IsMouseOver()) then
			return obj:GetText()
		end
	end
end

SetItemRef = function(link, text, button, ...)
	if(link:sub(1, 5) ~= "oChat") then return _SetItemRef(link, text, button, ...) end

	local frame = GetMouseFocus():GetParent()
	local text = borderManipulation(frame:GetRegions())
	if(text) then
		text = text:gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
		text = text:gsub("|H.-|h(.-)|h", "%1")

		local eb
		if(GetCVar("chatStyle") == 'classic') then
			eb = LAST_ACTIVE_CHAT_EDIT_BOX
		else
			eb = _G['ChatFrame' .. frame:GetID() .. 'EditBox']
		end

		eb:Insert(text)
		eb:Show()
		eb:HighlightText()
		eb:SetFocus()
	end
end
