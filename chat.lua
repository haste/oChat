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
local tostring = tostring
local _AddMessage = ChatFrame1.AddMessage
local buttons = {"UpButton", "DownButton", "BottomButton"}
local dummy = function() end
local ts = "|cffffffff%s|||r %s"

local blacklist = {
	[ChatFrame2] = true,
	[ChatFrame4] = true,
}

local AddMessage = function(self, text,...)
	text = tostring(text):gsub("%[Guild%].+(|Hplayer.+)", "g %1")
	text = text:gsub("%[Party%].+(|Hplayer.+)", "p %1")
	text = text:gsub("%[Raid%].+(|Hplayer.+)", "r %1")
	text = text:gsub("%[Raid Leader%].+(|Hplayer.+)", "R %1")
	text = text:gsub("%[Raid Warning%].+(|Hplayer.+)", "rw %1")
	text = text:gsub("%[Officer%].+(|Hplayer.+)", "o %1")
	text = text:gsub("%[Battleground%].+(|Hplayer.+)", "b %1")
	text = text:gsub("%[Battleground Leader%].+(|Hplayer.+)", "B %1")
	text = text:gsub("%[(%d+)%. .+%].+(|Hplayer.+)", "%1 %2")

	text = ts:format(date"%H%M.%S", text)

	return _AddMessage(self, text, ...)
end

local scroll = function(self, dir)
	if(dir > 0) then
		if(IsShiftKeyDown) then
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
