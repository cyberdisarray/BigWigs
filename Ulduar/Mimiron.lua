----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Mimiron"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33350		-- Most of the fight you fight vehicles .. does that matter..?
--  Leviathan MKII(33432), VX-001(33651), Aerial Command Unit(33670), 
mod.toggleoptions = {"phase", -1, "plasma", "shock", "laser", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local started = nil
local phase = nil
local pName = UnitName("player")
local fmt = string.format

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	["MKII"] = "Leviathan MKII",
	["VX-001"] = "VX-001",
	["Aerial"] = "Aerial Command Unit",

	cmd = "Mimiron",

	phase = "Phases",
	phase_desc = "Warn for phase changes.",
	phase2_warning = "Phase 2!",
	phase2_trigger = "Behold the VX-001 Anti-personnel Assault Cannon! You might want to take cover.",
	phase3_warning = "Phase 3!",
	phase3_trigger = "Isn't it beautiful? I call it the magnificent aerial command unit!",

	starttrigger = "We haven't much time, friends! You're going to help me test out my latest and greatest creation. Now, before you change your minds, remember that you kind of owe it to me after the mess you made with the XT-002.",

	plasma = "Plasma Blast",
	plasma_desc = "Warns when Plasma Blast is casting.",
	plasma_warning = "Casting Plasma Blast!",
	plasma_soon = "Plasma Blast soon!",

	shock = "Shock Blast",
	shock_desc = "Warns when Shock Blast is casting.",
	shock_warning = "Casting Shock Blast!",

	laser = "Laser Barrage",
	laser_desc = "Warn when Laser Barrage is active!",
	laser_soon = "Laser Barrage soon!",
	laser_bar = "Next Laser Barrage",

	--hard mode abilities:

	flamesuppressant = "Flame Suppressant",
	flamesuppressant_desc = "Warns when Flame Suppressant is casting.",
	flamesuppressant_warning = "Casting Flame Suppressant!",

	frostbomb = "Frost Bomb",
	frostbomb_desc = "Warns when Frost Bomb is casting.",
	frostbomb_warning = "Casting Frost Bomb!",
	frostbomb_soon = "Frost Bomb soon!",

	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	["MKII"] = "Leviathan MKII",
	["VX-001"] = "VX-001",
	["Aerial"] = "Aerial Command Unit",

	phase = "단계",
	phase_desc = "단계 변화를 알립니다.",
	phase2_warning = "2 단계!",
	--phase2_trigger = "Behold the VX-001 Anti-personnel Assault Cannon! You might want to take cover.",
	phase3_warning = "3 단계!",
	--phase3_trigger = "Isn't it beautiful? I call it the magnificent aerial command unit!",

	--starttrigger = "We haven't much time, friends! You're going to help me test out my latest and greatest creation. Now, before you change your minds, remember that you kind of owe it to me after the mess you made with the XT-002.",

	plasma = "플라스마 폭발",
	plasma_desc = "플라스마 폭발 시전을 알립니다.",
	plasma_warning = "플라스마 폭발 시전!",
	plasma_soon = "곧 플라스마 폭발!",

	shock = "충격파",
	shock_desc = "충격파 시전을 알립니다.",
	shock_warning = "충격파 시전!",

	laser = "레이저 탄막",
	laser_desc = "레이저 탄막 활동을 알립니다!",
	laser_soon = "곧 레이저 탄막!",
	laser_bar = "디음 레이저 탄막",
	
	flamesuppressant = "화염 억제",
	flamesuppressant_desc = "화염 억제 시전을 알립니다.",
	flamesuppressant_warning = "화염 억제 시전!",
	
	frostbomb = "서리 폭탄",
	frostbomb_desc = "서리 폭탄 시전을 알립니다.",
	frostbomb_warning = "서리 폭탄 시전!",
	frostbomb_soon = "잠시후 서리 폭탄!",
		
	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 transcriptor로 저장된 데이터 보내주시기 바랍니다.",
} end )

L:RegisterTranslations("frFR", function() return {
	["MKII"] = "Léviathan Mod. II",
	["VX-001"] = "VX-001",
	["Aerial"] = "Unité de commandement aérien",

	phase = "Phases",
	phase_desc = "Prévient quand la recontre entre dans une nouvelle phase.",
	phase2_warning = "Phase 2 !",
	phase2_trigger = "Je vous présente le canon d'assaut antipersonnel VX-001 ! Il pourrait être judicieux de vous mettre à l'abri.",
	phase3_warning = "Phase 3 !",
	phase3_trigger = "Elle est belle, hein ? Je l'ai appelée la magnifique unité de commandement aérien !",

	starttrigger = "Nous n'avons pas beaucoup de temps, les amis ! Vous allez m'aider à tester ma dernière création en date, la plus grande de toutes. Avant de changer d'avis, n'oubliez pas que vous me devez bien ça après m'avoir complètement déglingué le XT-002.",

	plasma = "Explosion de plasma",
	plasma_desc = "Prévient quand une Explosion de plasma est incantée.",
	plasma_warning = "Explosion de plasma en incantation !",
	plasma_soon = "Explosion de plasma imminente !",

	shock = "Horion explosif",
	shock_desc = "Prévient quand un Horion explosif est incanté.",
	shock_warning = "Horion explosif en incantation !",

	laser = "Barrage laser",
	laser_desc = "Prévient quand un Barrage laser est actif.",
	laser_soon = "Barrage laser imminent !",
	laser_bar = "Prochain Barrage laser",

	flamesuppressant = "Coupe-flamme",
	flamesuppressant_desc = "Prévient quand un Coupe-flamme est incanté.",
	flamesuppressant_warning = "Coupe-flamme en incantation !",

	frostbomb = "Bombe de givre",
	frostbomb_desc = "Prévient quand une Bombe de givre est incantée.",
	frostbomb_warning = "Bombe de givre en incantation !",
	frostbomb_soon = "Bombe de givre imminente !",

	log = "|cffff0000"..boss.."|r : ce boss a besoin de données, merci d'activer votre /combatlog ou Transcriptor et de nous transmettre les logs.",
} end )

--[[
		Needs cooldowns off the spells.

		Plasma Blast seems to be only cast every ~30s in our limited 10man trys
		Shock Blast didn't produce an accurate prediction.
]]
------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Plasma", 62997, 64529)
	self:AddCombatListener("SPELL_CAST_START", "Shock", 63631) -- H id missing
	self:AddCombatListener("SPELL_CAST_START", "FlameSuppressant", 64570)
	self:AddCombatListener("SPELL_CAST_START", "FrostBomb", 64623)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Laser", 63274)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Spinning", 63414)
	--self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("BigWigs_RecvSync")

	db = self.db.profile

	BigWigs:Print(L["log"])
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:FlameSuppressant(_, spellID)
	if db.flamesuppressant then
		self:IfMessage(L["flamesuppressant_warning"], "Important", spellID)
		self:Bar(L["flamesuppressant"], 2, spellID)
	end
end

function mod:FrostBomb(_, spellID)
	if db.frostbomb then
		self:IfMessage(L["frostbomb_warning"], "Important", spellID)
		self:Bar(L["frostbomb_warning"], 2, spellID)
		self:Bar(L["frostbomb"], 40, spellID)
		self:DelayedMessage(38, L["frostbomb_soon"], "Attention")
	end
end

function mod:Plasma(_, spellID)
	if db.plasma then
		self:IfMessage(L["plasma_warning"], "Important", spellID)
		self:Bar(L["plasma_warning"], 3, spellID)
		self:Bar(L["plasma"], 30, spellID)
		self:DelayedMessage(27, L["plasma_soon"], "Attention")
	end
end

function mod:Shock(_, spellID)
	if db.shock then
		self:IfMessage(L["shock_warning"], "Important", spellID)
		self:Bar(L["shock"], 5, spellID)
	end
end

local last = 0
function mod:Laser(unit, spellID)
	local time = GetTime()
	if (time - last) > 4 then
		last = time
		if unit == L["VX-001"] and db.laser then
			self:IfMessage(L["laser"], "Important", spellID)
			self:Bar(L["laser"], 15, spellID)
			self:Bar(L["laser_bar"], 60, spellID)
		end
	end
end

function mod:Spinning(_, spellID)
	if db.laser then
		self:IfMessage(L["laser_soon"], "Important", spellID)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg:match(L["starttrigger"]) then
		phase = 1
		if db.plasma then
			self:Bar(L["plasma"], 20, spellID)
			self:DelayedMessage(17, L["plasma_soon"], "Attention")
		end
	elseif msg:match(L["phase2_trigger"]) then
		phase = 2
		self:CancelAllScheduledEvents()
		self:TriggerEvent("BigWigs_StopBar", self, L["plasma"])
		if db.phase then
			self:Message(L["phase2_warning"], "Attention")
		end
	elseif msg:match(L["phase2_trigger"]) then
		phase = 3
		self:CancelAllScheduledEvents()
		self:TriggerEvent("BigWigs_StopBar", self, L["plasma"])
		if db.phase then
			self:Message(L["phase3_warning"], "Attention")
		end
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
