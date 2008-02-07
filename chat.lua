--[[-------------------------------------------------------------------------
  Copyright (c) 2007, Trond A Ekseth
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

      * Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
      * Redistributions in binary form must reproduce the above
        copyright notice, this list of conditions and the following
        disclaimer in the documentation and/or other materials provided
        with the distribution.
      * Neither the name of oChat nor the names of its contributors may
        be used to endorse or promote products derived from this
        software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
---------------------------------------------------------------------------]]

--[[ This was once a really old version of idChat :D ]]

local _G = getfenv(0)
local type = type
local tonumber = tonumber
local string_split = string.split

local _AddMessage = ChatFrame1.AddMessage
local _SetItemRef = SetItemRef

local buttons = {"UpButton", "DownButton", "BottomButton"}
local dummy = function() end
local ts = "|cffffffff|HoChat|h%s|h|||r %s"

local blacklist = {
	[ChatFrame2] = true,
	[ChatFrame4] = true,
}

_G.CHAT_GUILD_GET = "g %s:\32"
_G.CHAT_RAID_GET = "r %s:\32"
_G.CHAT_PARTY_GET = "p %s:\32"
_G.CHAT_RAID_WARNING_GET = "w %s:\32"
_G.CHAT_RAID_LEADER_GET = "R %s:\32"
_G.CHAT_OFFICER_GET = "o %s:\32"
_G.CHAT_BATTLEGROUND_GET = "b %s:\32"
_G.CHAT_BATTLEGROUND_LEADER_GET = "B %s:\32"

-- 1: index, 2: channelname, 3: twatt
-- Examples are based on this: [1. Channel] Otravi: Hi
local str = "%d %3$s" -- gives: 1 Otravi: Hi
--local str = "[%2$.3s] %s" -- gives: [Cha] Otravi: Hi
--local str = "[%d. %2$.3s] %s" -- gives: [1. Cha] Otravi: Hi
local channel = function(...)
	return str:format(...)
end

local AddMessage = function(self, text, ...)
	if(type(text) == "string") then
		text = text:gsub("|Hplayer:([^:]+):(%d+)|h%[(.-)%]|h", "|Hplayer:%1:%2|h%3|h")
		text = text:gsub("%[(%d+)%. (.+)%].+(|Hplayer.+)", channel)

		text = ts:format(date"%H%M.%S", text)
	end

	return _AddMessage(self, text, ...)
end

local scroll = function(self, dir)
	if(dir > 0) then
		if(IsShiftKeyDown()) then
			self:ScrollToTop()
		else
			self:ScrollUp()
		end
	elseif(dir < 0) then
		if(IsShiftKeyDown()) then
			self:ScrollToBottom()
		else
			self:ScrollDown()
		end
	end
end

for i=1, NUM_CHAT_WINDOWS do
	local cf = _G["ChatFrame"..i]
	cf:EnableMouseWheel(true)

	cf:SetFading(false)
	cf:SetScript("OnMouseWheel", scroll)

	for k, button in pairs(buttons) do
		button = _G["ChatFrame"..i..button]
		button:Hide()
		button.Show = dummy
	end

	if(not blacklist[cf]) then
		cf.AddMessage = AddMessage
	end
end

buttons = nil

ChatFrameMenuButton:Hide()
ChatFrameMenuButton.Show = dummy

local eb = ChatFrameEditBox
eb:ClearAllPoints()
eb:SetPoint("BOTTOMLEFT",  ChatFrame1, "TOPLEFT", -5, 20)
eb:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 5, 20)
eb:SetAltArrowKeyMode(false)

local a, b, c = select(6, eb:GetRegions())
a:Hide(); b:Hide(); c:Hide()

ChatTypeInfo['SAY'].sticky = 1
ChatTypeInfo['YELL'].sticky = 1
ChatTypeInfo['PARTY'].sticky = 1
ChatTypeInfo['GUILD'].sticky = 1
ChatTypeInfo['OFFICER'].sticky = 1
ChatTypeInfo['RAID'].sticky = 1
ChatTypeInfo['RAID_WARNING'].sticky = 1
ChatTypeInfo['BATTLEGROUND'].sticky = 1
ChatTypeInfo['WHISPER'].sticky = 1
ChatTypeInfo['CHANNEL'].sticky = 1

-- Modified version of MouseIsOver from UIParent.lua
local MouseIsOver = function(frame)
	local s = frame:GetParent():GetEffectiveScale()
	local x, y = GetCursorPosition()
	x = x / s
	y = y / s

	local left = frame:GetLeft()
	local right = frame:GetRight()
	local top = frame:GetTop()
	local bottom = frame:GetBottom()

	-- Hack to fix a symptom not the real issue
	if(not left) then
		return
	end

	if((x > left and x < right) and (y > bottom and y < top)) then
		return 1
	else
		return
	end
end

local borderManipulation = function(...)
	for l = 1, select("#", ...) do
		local obj = select(l, ...)
		if(obj:GetObjectType() == "FontString" and MouseIsOver(obj)) then
			return obj:GetText()
		end
	end
end

SetItemRef = function(link, text, button, ...)
	if(link:sub(1, 5) ~= "oChat") then return _SetItemRef(link, text, button, ...) end

	local text = borderManipulation(SELECTED_CHAT_FRAME:GetRegions())

	if(text) then
		text = text:gsub("|c%x*(.-)|r", "%1")
		text = text:gsub("|HoChat|h(.-)|h", "%1")
		text = text:gsub("|Hplayer:.-|h(.-)|h", "%1")
		eb:Insert(text)
		eb:Show()
		eb:HighlightText()
		eb:SetFocus()
	end
end
