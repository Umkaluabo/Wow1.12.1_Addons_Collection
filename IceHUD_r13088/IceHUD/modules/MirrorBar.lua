local AceOO = AceLibrary("AceOO-2.0")

-- 2 classes in the same file.. ugly but keeps the idea of
-- "1 module = 1 file" intact


-------------------------------------------------------------------------------
-- MirrorBar                                                                 --
-------------------------------------------------------------------------------

local MirrorBar = AceOO.Class(IceBarElement)

MirrorBar.prototype.timer = nil
MirrorBar.prototype.value = nil
MirrorBar.prototype.maxValue = nil
MirrorBar.prototype.timerScale = nil
MirrorBar.prototype.paused = nil
MirrorBar.prototype.label = nil


-- Constructor --
function MirrorBar.prototype:init(side, offset, name, db)
	MirrorBar.super.prototype.init(self, name)
	self.settings = db
	self.moduleSettings = {}
	self.moduleSettings.side = side
	self.moduleSettings.offset = offset

	-- unregister the event superclass registered, we don't want to register
	-- this to the core
	self:UnregisterEvent(IceCore.Loaded)
end


function MirrorBar.prototype:UpdatePosition(side, offset)
	self.moduleSettings.side = side
	self.moduleSettings.offset = offset
end


function MirrorBar.prototype:Enable(core)
	MirrorBar.super.prototype.Enable(self, core)
	
	self.frame.bottomUpperText:SetWidth(200)
	self.frame.bottomLowerText:SetWidth(200)

	self.frame:Hide()
end


-- OVERRIDE
function MirrorBar.prototype:Create(parent)
	MirrorBar.super.prototype.Create(self, parent)
	
	if (self.timer) then
		self.frame:Show()
	end
end


function MirrorBar.prototype:OnUpdate(elapsed)
	if (self.paused) then
		return
	end
	
	self:Update()

	self.value = self.value + (self.timerScale * elapsed * 1000)
	
	scale = self.value / self.maxValue
	
	if (scale < 0) then -- lag compensation
		scale = 0
	end
	if (scale > 1) then -- lag compensation
		scale = 1
	end

	
	local timeRemaining = (self.value) / 1000
	local remaining = string.format("%.1f", timeRemaining)
	
	if (timeRemaining < 0) then -- lag compensation
		remaining = 0
	end
	if (timeRemaining > self.maxValue/1000) then
		remaining = self.maxValue/1000
	end

	self:UpdateBar(scale, self.timer)
	
	local text = self.label .. " " .. remaining .. "s"
	
	if (math.mod(self.moduleSettings.offset, 2) == 1) then
		self:SetBottomText1(text)
		self:SetBottomText2()
	else
		self:SetBottomText1()
		self:SetBottomText2(text, "Text", 1)
	end
end


function MirrorBar.prototype:MirrorStart(timer, value, maxValue, scale, paused, label)
	self.timer = timer
	self.value = value
	self.maxValue = maxValue
	self.timerScale = scale
	self.paused = (paused > 0)
	self.label = label
	
	self.startTime = GetTime()

	self:Update()
	self.frame:Show()
	self.frame:SetScript("OnUpdate", function() self:OnUpdate(arg1) end)
end


function MirrorBar.prototype:MirrorStop()
	self:CleanUp()
	self.frame:Hide()
	self.frame:SetScript("OnUpdate", nil)
end


function MirrorBar.prototype:MirrorPause(paused)
	if (paused > 0) then
		self.paused = true
	else
		self.paused = false
	end
end


function MirrorBar.prototype:CleanUp()
	self.timer = nil
	self.value = nil
	self.maxValue = nil
	self.timerScale = nil
	self.paused = nil
	self.label = nil
	self.startTime = nil
	self:SetBottomText1()
	self:SetBottomText2()
end





-------------------------------------------------------------------------------
-- MirrorBarHandler                                                          --
-------------------------------------------------------------------------------


local MirrorBarHandler = AceOO.Class(IceElement)

MirrorBarHandler.prototype.bars = nil


-- Constructor --
function MirrorBarHandler.prototype:init()
	MirrorBarHandler.super.prototype.init(self, "MirrorBarHandler")

	self.bars = {}

	self:SetDefaultColor("EXHAUSTION", 1, 0.9, 0)
	self:SetDefaultColor("BREATH", 0, 0.5, 1)
	self:SetDefaultColor("DEATH", 1, 0.7, 0)
	self:SetDefaultColor("FEIGNDEATH", 1, 0.9, 0)
end


function MirrorBarHandler.prototype:GetDefaultSettings()
	local settings = MirrorBarHandler.super.prototype.GetDefaultSettings(self)
	settings["side"] = IceCore.Side.Left
	settings["offset"] = 3
	settings["barFontSize"] = 13
	settings["barFontBold"] = true
	settings["lockTextAlpha"] = true
	settings["textVisible"] = {upper = true, lower = true}
	return settings
end


-- OVERRIDE
function MirrorBarHandler.prototype:GetOptions()
	local opts = MirrorBarHandler.super.prototype.GetOptions(self)
	
	opts["side"] = 
	{
		type = 'text',
		name = '|c' .. self.configColor .. 'Side|r',
		desc = 'Side of the HUD where the bar appears',
		get = function()
			if (self.moduleSettings.side == IceCore.Side.Right) then
				return "Right"
			else
				return "Left"
			end
		end,
		set = function(value)
			if (value == "Right") then
				self.moduleSettings.side = IceCore.Side.Right
			else
				self.moduleSettings.side = IceCore.Side.Left
			end
			self:Redraw()
		end,
		validate = { "Left", "Right" },		
		order = 30
	}
	
	opts["offset"] = 
	{
		type = 'range',
		name = '|c' .. self.configColor .. 'Offset|r',
		desc = 'Offset of the bar',
		min = -1,
		max = 10,
		step = 1,
		get = function()
			return self.moduleSettings.offset
		end,
		set = function(value)
			self.moduleSettings.offset = value
			self:Redraw()
		end,
		order = 31
	}
	
	opts["textSettings"] =
	{
		type = 'group',
		name = '|c' .. self.configColor .. 'Text Settings|r',
		desc = 'Settings related to texts',
		order = 32,
		args = {
			fontsize = {
				type = 'range',
				name = 'Bar Font Size',
				desc = 'Bar Font Size',
				get = function()
					return self.moduleSettings.barFontSize
				end,
				set = function(v)
					self.moduleSettings.barFontSize = v
					self:Redraw()
				end,
				min = 8,
				max = 20,
				step = 1,
				order = 11
			},
			
			fontBold = {
				type = 'toggle',
				name = 'Bar Font Bold',
				desc = 'If you have game default font selected, this option has no effect',
				get = function()
					return self.moduleSettings.barFontBold
				end,
				set = function(v)
					self.moduleSettings.barFontBold = v
					self:Redraw()
				end,
				order = 12
			},
			
			lockFontAlpha = {
				type = "toggle",
				name = "Lock Bar Text Alpha",
				desc = "Locks upper text alpha to 100%",
				get = function()
					return self.moduleSettings.lockTextAlpha
				end,
				set = function(v)
					self.moduleSettings.lockTextAlpha = v
					self:Redraw()
				end,
				order = 13
			},
			
			upperTextVisible = {
				type = 'toggle',
				name = 'Upper text visible',
				desc = 'Toggle upper text visibility',
				get = function()
					return self.moduleSettings.textVisible['upper']
				end,
				set = function(v)
					self.moduleSettings.textVisible['upper'] = v
					self:Redraw()
				end,
				order = 14
			},
			
			lowerTextVisible = {
				type = 'toggle',
				name = 'Lower text visible',
				desc = 'Toggle lower text visibility',
				get = function()
					return self.moduleSettings.textVisible['lower']
				end,
				set = function(v)
					self.moduleSettings.textVisible['lower'] = v
					self:Redraw()
				end,
				order = 15
			},
		}
	}
	
	return opts
end


function MirrorBarHandler.prototype:Enable(core)
	MirrorBarHandler.super.prototype.Enable(self, core)
	self:RegisterEvent("MIRROR_TIMER_START", "MirrorStart")
	self:RegisterEvent("MIRROR_TIMER_STOP", "MirrorStop")
	self:RegisterEvent("MIRROR_TIMER_PAUSE", "MirrorPause")
	
	-- hide blizz mirror bar
	UIParent:UnregisterEvent("MIRROR_TIMER_START");
end


function MirrorBarHandler.prototype:Disable(core)
	MirrorBarHandler.super.prototype.Disable(self, core)
	
	UIParent:RegisterEvent("MIRROR_TIMER_START");
end


function MirrorBarHandler.prototype:Redraw()
	MirrorBarHandler.super.prototype.Redraw(self)
	
	if (not self.moduleSettings.enabled) then
		return
	end

	for i = 1, table.getn(self.bars) do
		self:SetSettings(self.bars[i])
		self.bars[i]:UpdatePosition(self.moduleSettings.side, self.moduleSettings.offset + (i-1))
		self.bars[i]:Create(self.parent)
	end
end


function MirrorBarHandler.prototype:MirrorStart(timer, value, maxValue, scale, paused, label)
	local done = nil
	
	-- check if we can find an already running timer to reverse it
	for i = 1, table.getn(self.bars) do
		if (self.bars[i].timer == timer) then
			done = true
			self.bars[i]:MirrorStart(timer, value, maxValue, scale, paused, label)
		end
	end
	
	-- check if there's a free instance in case we didn't find an already running bar
	if not (done) then
		for i = 1, table.getn(self.bars) do
			if not (self.bars[i].timer) and not (done) then
				done = true
				self.bars[i]:MirrorStart(timer, value, maxValue, scale, paused, label)
			end
		end
	end
	
	-- finally create a new instance if no available ones were found
	if not (done) then
		local count = table.getn(self.bars)
		self.bars[count + 1] = MirrorBar:new(self.moduleSettings.side, self.moduleSettings.offset + count, "MirrorBar" .. tostring(count+1), self.settings)
		self:SetSettings(self.bars[count+1])
		self.bars[count + 1]:Create(self.parent)
		self.bars[count + 1]:Enable()
		self.bars[count + 1]:MirrorStart(timer, value, maxValue, scale, paused, label)
	end
end


function MirrorBarHandler.prototype:MirrorStop(timer)
	for i = 1, table.getn(self.bars) do
		if (self.bars[i].timer == timer) then
			self.bars[i]:MirrorStop()
		end
	end
end


function MirrorBarHandler.prototype:MirrorPause(paused)
	for i = 1, table.getn(self.bars) do
		if (self.bars[i].timer ~= nil) then
			self.bars[i]:MirrorPause(paused > 0)
		end
	end
end



function MirrorBarHandler.prototype:SetSettings(bar)
	bar.moduleSettings.barFontSize = self.moduleSettings.barFontSize
	bar.moduleSettings.barFontBold = self.moduleSettings.barFontBold
	bar.moduleSettings.lockTextAlpha = self.moduleSettings.lockTextAlpha
	bar.moduleSettings.textVisible = self.moduleSettings.textVisible
	bar.moduleSettings.scale = self.moduleSettings.scale
end




-- Load us up
MirrorBarHandler:new()


