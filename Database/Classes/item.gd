extends Node

class_name Item

export(int) var id
export(String) var internal_name = ""
export(String) var Name = ""

export(String,MULTILINE) var description = ""
export(int) var cost
## La id de la categoria, s'hauràn de crear les constants a CONST.gd
export(int,"NONE, STAT_BOOSTS, EFFORT_DROP, MEDICINE, OTHER, IN_A_PINCH, PICKY_HEALING, TYPE_PROTECTION, BAKING_ONLY, COLLECTIBLES, EVOLUTION, SPELUNKING, HELD_ITEMS, CHOICE, EFFORT_TRAINING, BAD_HELD_ITEMS, TRAINING, PLATES, SPECIES_SPECIFIC, TYPE_ENHANCEMENT, EVENT_ITEMS, GAMEPLAY, PLOT_ADVANCEMENT, UNUSED, LOOT, ALL_MAIL, VITAMINS, HEALING, PP_RECOVERY, REVIVAL, STATUS_CURES, NONE2, MULCH, SPECIAL_BALLS, STANDARD_BALLS, DEX_COMPLETION, SCARVES, ALL_MACHINES, FLUTES, APRICORN_BALLS, APRICORN_BOX, DATA_CARDS, JEWELS, MIRACLE_SHOOTER, MEGA_STONES, MEMORIES") var category
export(int,"NONE, ITEMS, MEDICINE, POKÉ_BALLS, TMS_AND_HMS, BERRIES, MAIL, BATTLE_ITEMS, KEY_ITEMS") var bag_pocket

## ATRIBUTOS

export(bool) var countable = false
export(bool) var consumable = false
export(bool) var overworld = false
export(bool) var battle = false
export(bool) var holdable = false
export(bool) var holdable_passive = false
export(bool) var holdable_active = false
export(bool) var underground = false

			
