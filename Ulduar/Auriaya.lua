----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Auriaya"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33515
mod.toggleoptions = {"fear", "sentinel", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
started = true

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Auriaya",
	
	fear = "Terrifying Screech",
	fear_desc = "Warn when about Horrifying Screech.",
	fear_warning = "Fear soon!",
	fear_bar = "~Fear Cooldown",

	sentinel = "Sentinel Blast",
	sentinel_desc = "Warn when Auriaya casts a Sentinel Blast.",
	sentinel_message = "Sentinel Blast!",
	
	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	fear = "공포의 비명소리",
	fear_desc = "공포의 비명소리에 대해 알립니다.",
	fear_warning = "곧 공포!",
	fear_bar = "~공포 대기시간",

	sentinel = "파수꾼 폭발",
	sentinel_desc = "아우리야의 파수꾼 폭발 시전을 알립니다.",
	sentinel_message = "파수꾼 폭발!",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Fear", 64386)
	self:AddCombatListener("SPELL_CAST_START", "Sentinel", 64392, 64678)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("BigWigs_RecvSync")

	db = self.db.profile

	BigWigs:Print(L["log"])
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Fear(_, spellID)
	if db.fear then
		self:IfMessage(L["fear_message"], "Attention", spellID)
		self:Bar(L["fear_bar"], 35, spellID)
		self:DelayedMessage(32, L["fear_warning"], "Attention")
	end
end

function mod:Sentinel(_, spellID)
	if db.sentinel then
		self:IfMessage(L["sentinel_message"], "Attention", spellID)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then 
			self:UnregisterEvent("PLAYER_REGEN_DISABLED") 
		end
	end
end
