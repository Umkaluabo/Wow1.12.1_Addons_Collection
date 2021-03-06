--[[
Name: AceDebug-2.0
Revision: $Rev: 4536 $
Author(s): Kaelten (kaelten@gmail.com)
Inspired By: AceDebug 1.x by Turan (<email here>)
Website: http://www.wowace.com/
Documentation: http://wiki.wowace.com/index.php/AceDebug-2.0
SVN: http://svn.wowace.com/root/trunk/Ace2/AceDebug-2.0
Description: Mixin to allow for simple debugging capabilities.
Dependencies: AceLibrary, AceOO-2.0
]]

local MAJOR_VERSION = "AceDebug-2.0"
local MINOR_VERSION = "$Revision: 4536 $"

if not AceLibrary then error(MAJOR_VERSION .. " requires AceLibrary") end
if not AceLibrary:IsNewVersion(MAJOR_VERSION, MINOR_VERSION) then return end

if not AceLibrary:HasInstance("AceOO-2.0") then error(MAJOR_VERSION .. " requires AceOO-2.0") end 

-- localize --
local DEBUGGING = "Debugging"
local TOGGLE_DEBUGGING = "Enable/disable debugging"
-- localize --

local AceOO = AceLibrary:GetInstance("AceOO-2.0")
local AceDebug = AceOO.Mixin {"Debug", "CustomDebug", "IsDebugging", "SetDebugging"}

local function print(text, r, g, b, frame, delay)
	(frame or DEFAULT_CHAT_FRAME):AddMessage(text, r, g, b, 1, delay or 5)
end

local tmp

function AceDebug:CustomDebug(r, g, b, frame, delay, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20)
	if not self.debugging then return end

	local output = string.format("|cff7fff7f(DEBUG) %s:|r", tostring(self))
	
	if string.find(tostring(a1), "%%") then
		output = output .. " " .. string.format(tostring(a1), tostring(a2), tostring(a3), tostring(a4), tostring(a5), tostring(a6), tostring(a7), tostring(a8), tostring(a9), tostring(a10), tostring(a11), tostring(a12), tostring(a13), tostring(a14), tostring(a15), tostring(a16), tostring(a17), tostring(a18), tostring(a19), tostring(a20))
	else
		if not tmp then
			tmp = {}
		end
		
		-- This block dynamically rebuilds the tmp array stopping on the first nil.
		table.insert(tmp, output)
		
		table.insert(tmp, a1)
		table.insert(tmp, a2)
		table.insert(tmp, a3)
		table.insert(tmp, a4)
		table.insert(tmp, a5)
		table.insert(tmp, a6)
		table.insert(tmp, a7)
		table.insert(tmp, a8)
		table.insert(tmp, a9)
		table.insert(tmp, a10)
		table.insert(tmp, a11)
		table.insert(tmp, a12)
		table.insert(tmp, a13)
		table.insert(tmp, a14)
		table.insert(tmp, a15)
		table.insert(tmp, a16)
		table.insert(tmp, a17)
		table.insert(tmp, a18)
		table.insert(tmp, a19)
		table.insert(tmp, a20)
		while tmp[table.getn(tmp)] == nil do
			table.remove(tmp)
		end
		for k = 1, table.getn(tmp) do
			tmp[k] = tostring(tmp[k])
		end
		
		output = table.concat(tmp, " ")
		
		for k,v in tmp do
			tmp[k] = nil
		end
		table.setn(tmp, 0)
	end

	print(output, r, g, b, frame or self.debugFrame, delay)
end

function AceDebug:Debug(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20)
	AceDebug.CustomDebug(self, nil, nil, nil, nil, nil, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20)
end

function AceDebug:IsDebugging() 
	return self.debugging
end

function AceDebug:SetDebugging(debugging)
	self.debugging = debugging
end

local options
function AceDebug:GetAceOptionsDataTable(target)
	if not options then
		options = {
			debug = {
				name = DEBUGGING,
				desc = TOGGLE_DEBUGGING,
				type = "toggle",
				get = "IsDebugging",
				set = "SetDebugging",
			}
		}
	end
	return options
end
AceLibrary:Register(AceDebug, MAJOR_VERSION, MINOR_VERSION, AceDebug.activate)
AceDebug = AceLibrary(MAJOR_VERSION)
