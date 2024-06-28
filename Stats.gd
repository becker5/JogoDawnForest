extends Node
class_name PLayerStats

var shielding:bool = false
var base_health:int = 10
var base_mana:int = 10
var base_attack:int = 1
var base_madic_attack:int = 3
var base_defense:int = 1

var bonus_health:int = 0
var bonus_mana:int = 0
var bonus_attack:int = 0
var bonus_magic_attack:int = 0
var bonus_defense:int = 0

var max_health:int
var max_mana:int
var current_mana:int
var current_xp:int = 0
var current_health:int
var level:int = 1

var level_dict:Dictionary = {
	"1":25,
	"2":30, 
	'3':40,
	'4':50,
	'5':65,
	'6':85, 
	'7':100,
	'8':125,
	'9':150,
	'10':200
}

func _ready():
	base_mana = base_mana + bonus_mana
	max_mana = current_mana
	base_health = base_health + bonus_health

func update_xp(value:int)->void:
	current_xp += value 
	if current_xp > level_dict[str(level)]:
		var left_over:int = current_xp - level_dict[str(level)]
		current_xp = left_over
		level += 1

func on_level_up()->void:
	current_mana += bonus_mana
	current_health += bonus_health

func update_health(type:String, value:int)->void:
	match type:
		'Increase':
			current_health += value
			if current_health >= max_health:
				current_health = max_health
		'Decrease':
			verify_shield(value)
			if current_health <= 0:
				pass

func verify_shield(value:int)->void:
	if shielding:
		if(base_defense+bonus_defense)>=value:
			return
		var damege = abs((base_defense+bonus_defense)-value)
		current_health -= damege
	else:
		current_health -= value

func update_mana(type:String,value:int)->void:
	match type:
		'Increase':
			current_mana += value
			if current_mana >= max_mana:
				current_mana = max_mana
		'Decrease':
			current_mana -= value


