------------------------------------------------------------------------------------------------------
-- HolyHope 2.4

-- Addon pour Paladin
-- Gestion des benedictions et Compteur de sympbole des rois

-- Remerciements aux auteurs de Necrosis et KingsCounter

-- Remerciements speciaux à Erosenin, guilde Exodius, Designer de HolyHope

-- Auteur Freeman
-- Pour reporter un bug ou une idée d'amélioration: THEFREEMAN55@free.fr

-- Serveur:
-- Freeman, guilde Exodius, Ner'Zhul FR
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

-- Traditionnal Chinese Translation by BestSteve, Thanks to him :)

------------------------------------------------------------------------------------------------------

if ( GetLocale() == "zhTW" ) then

HOLYHOPE_UNIT_PALADIN = "èé¨å£«";

-- Table des sorts du paladin
HOLYHOPE_SPELL_TABLE = {
	["ID"] = {},
	["Rank"] = {},
	["Name"] = {
		"å¬åè»é¦¬",        --1
		"å¬åæ°é¦¬",        --2
		"åéç¥ç¦",        --3
		"æºæ§ç¥ç¦",        --4
		"æ¯æç¥ç¦",        --5
		"åæç¥ç¦",        --6
		"çèç¥ç¦",        --7
		"åºè­·ç¥ç¦",        --8
		"èªç±ç¥ç¦",        --9
		"ç§ç²ç¥ç¦",        --10
		"å¼·æåéç¥ç¦",  --11
		"å¼·ææºæ§ç¥ç¦",  --12
		"å¼·ææ¯æç¥ç¦",  --13
		"å¼·æåæç¥ç¦",  --14
		"å¼·æçèç¥ç¦",  --15
		"å¼·æåºè­·ç¥ç¦",  --16
		"å½ä»¤èå°",        --17
		"åå­è»èå°",     --18
		"æ­£ç¾©èå°",        --19
		"åæèå°",        --20
		"å¬æ­£èå°",        --21
		"æºæ§èå°",        --22
		"å¯©å¤",              --23
		"æ¤æä¹é",        --24
		"æè´",              --25
		},
	["Mana"] = {}
};

-- Raccourcis claviers
BINDING_HEADER_HOLYHOPE_BIND = "HolyHope";
BINDING_NAME_STEED = "Mount";   
BINDING_NAME_NORMALSTEED = "Normal Mount";
BINDING_NAME_MIGHT = HOLYHOPE_SPELL_TABLE.Name[3];
BINDING_NAME_WISDOM = HOLYHOPE_SPELL_TABLE.Name[4];
BINDING_NAME_SALVATION = HOLYHOPE_SPELL_TABLE.Name[13];
BINDING_NAME_LIGHT = HOLYHOPE_SPELL_TABLE.Name[6];
BINDING_NAME_KINGS = HOLYHOPE_SPELL_TABLE.Name[7];
BINDING_NAME_SANCTUARY = HOLYHOPE_SPELL_TABLE.Name[8];
BINDING_NAME_FREEDOM = HOLYHOPE_SPELL_TABLE.Name[9];
BINDING_NAME_SACRIFICE = HOLYHOPE_SPELL_TABLE.Name[10];
BINDING_NAME_SCOMMAND = HOLYHOPE_SPELL_TABLE.Name[17];
BINDING_NAME_SCRUSADER = HOLYHOPE_SPELL_TABLE.Name[18];
BINDING_NAME_SJUSTICE = HOLYHOPE_SPELL_TABLE.Name[19];
BINDING_NAME_SLIGHT = HOLYHOPE_SPELL_TABLE.Name[20];
BINDING_NAME_SRIGHTEOUSNESS = HOLYHOPE_SPELL_TABLE.Name[21];
BINDING_NAME_SWISDOM = HOLYHOPE_SPELL_TABLE.Name[22];
BINDING_NAME_JUDGEMENT = HOLYHOPE_SPELL_TABLE.Name[23];
BINDING_NAME_WRATH = HOLYHOPE_SPELL_TABLE.Name[24];
BINDING_NAME_REDEMPTION = HOLYHOPE_SPELL_TABLE.Name[25];

-- Table des items du paladin
HOLYHOPE_ITEM = {
	["Kings"] = "çèå°è¨",
	["Hearthstone"] = "çç³",
	["QuirajiMount"] = "å¶æå±é³´æ°´æ¶",
};

-- Traduction
HOLYHOPE_TRANSLATION = {
	["Cooldown"] = "å·å»æé",
	["Rank"] = "ç­ç´ ",
};

-- Message
HOLYHOPE_MESSAGE = {
  ["SLASH"] = {
    ["InitOn"] = "HolyHope åç¨ã /holyhope æè /hh é¡¯ç¤ºé¸é ",
  },
  ["TOOLTIP"] = {
    ["Clic"] = "é»æåæï¼",
    ["RightClic"] = "å³éµé»æï¼çç³",
    ["NotUp"] = " å¼·æç¥ç¦",
    ["Up"] = " æ®éç¥ç¦",
    ["Judgement"] = "é»æä»¥å¯©å¤",
  },
  ["nohearthstone"] = "ä½ çåè£¹è£¡æ²æçç³",
};

-- Monture
MOUNT_ITEM = {
  ["ReinsMount"] = "é¦¬",
  ["RamMount"] = "å±±ç¾",
  ["BridleMount"] = "éç¹©",
  ["BridleMount2"] = "é·çè»ç¨åé¨",
  ["BridleMount3"] = "éç¼å¥å«èçèè§",
  ["MechanostriderMount"] = "æ©æ¢°é¸åé³¥",
  ["QuirajiMount"] = "é»è²å¶æå±é³´æ°´æ¶",
};

-- Menu
HOLYHOPE_MENU = {
  ["Lenght"] = "Lenght",
  ["Actif"] = "Actif",
  ["Drag"] = "Drag",
  ["Unlock"] = "HolyHope's frames are now Unlock",
  ["Lock"] = "HolyHope's frames are now Lock",
  ["Tooltips"] = "Tooltips",
  ["Blessing"] = "ç¥ç¦",
  ["Seal"] = "èå°",
  ["Mount"] = "Mount",
  ["Off"] = "Off",
  ["Partial"] = "Partials",
  ["Tab1"] = "Generals Options",
  ["Tab2"] = "Pop-up and Tooltips",
  ["Total"] = "Totals",  
};

end
