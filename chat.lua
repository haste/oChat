--[[ This was once a really old version of idChat :D ]]

local blacklist = {
	[ChatFrame2] = true,
	[ChatFrame4] = true,
}

-- 1: index, 2: channelname, 3: twatt
-- Examples are based on this: [1. Channel] Otravi: Hi
--local str = "[%2$.3s] %s" -- gives: [Cha] Otravi: Hi
--local str = "[%d. %2$.3s] %s" -- gives: [1. Cha] Otravi: Hi
local str = "%d|h %3$s" -- gives: 1 Otravi: Hi
local channel = function(...)
	return str:format(...)
end

local type = type
local math_floor = math.floor

local ts = "|cffffffff|HoChat|h%s|h|||r %s"
local origs = {}
local AddMessage = function(self, text, ...)
	if(type(text) == "string") then
		local _, size = self:GetFont()
		size = math_floor(size + .5)

		-- Simplify channel display.
		text = text:gsub('|Hchannel:(%d+)|h%[?(.-)%]?|h.+(|Hplayer.+)', channel)

		-- Make the in-line textures match the font-size.
		text = text:gsub('(|T[^:]+:)(%d+:*%d*)', ('%%1%d:%1$d'):format(size))

		-- Timestamp in the start.
		text = ts:format(date"%H%M.%S", text)
	end

	return origs[self](self, text, ...)
end

for i=1, NUM_CHAT_WINDOWS do
	local cf = _G["ChatFrame"..i]

	cf:SetFading(false)

	if(not blacklist[cf]) then
		origs[cf] = cf.AddMessage
		cf.AddMessage = AddMessage
	end

	local bFrame = _G['ChatFrame' .. i .. 'ButtonFrame']
	bFrame.Show = bFrame.Hide
	bFrame:Hide()

	local eb = _G['ChatFrame' .. i .. 'EditBox']
	eb:ClearAllPoints()
	if(i ~= 2) then
		eb:SetPoint("BOTTOMLEFT",  cf, "TOPLEFT", -5, 20)
		eb:SetPoint("BOTTOMRIGHT", cf, "TOPRIGHT", 5, 20)
	else
		eb:SetPoint("BOTTOMLEFT",  cf, "TOPLEFT", -5, 45)
		eb:SetPoint("BOTTOMRIGHT", cf, "TOPRIGHT", 5, 45)
	end
	eb:SetAltArrowKeyMode(false)

	_G['ChatFrame' .. i .. 'EditBoxLeft']:Hide()
	_G['ChatFrame' .. i .. 'EditBoxMid']:Hide()
	_G['ChatFrame' .. i .. 'EditBoxRight']:Hide()

	_G['ChatFrame' .. i .. 'EditBoxFocusLeft']:SetTexture(nil)
	_G['ChatFrame' .. i .. 'EditBoxFocusMid']:SetTexture(nil)
	_G['ChatFrame' .. i .. 'EditBoxFocusRight']:SetTexture(nil)
end

FriendsMicroButton.Show = FriendsMicroButton.Hide
FriendsMicroButton:Hide()

ChatFrameMenuButton.Show = ChatFrameMenuButton.Hide
ChatFrameMenuButton:Hide()
