extends Node

class_name PlayerStats

var shielding:bool = false
var base_health:int = 10
var base_mana:int = 10
var base_attack:int = 1
var base_magic_attack:int = 3
var base_defense:int = 1
	
var bonus_health:int = 0
var bonus_mana:int = 0
var bonus_attack:int = 0
var bonus_magic_attack:int = 0
var bonus_defense:int = 0

var current_health:int
var current_mana:int

var max_health:int
var max_mana:int

var current_xp:int = 0
var level:int = 1

var level_dict:Dictionary = {
	"1":25,
	"2":30,
	"3":40,
	"4":60,
	"5":90,
	"6":120,
	"7":150,
	"8":200,
	"9":260,
	"10":350
}

func _ready():
	base_mana = base_mana +bonus_mana
	max_mana = current_mana
	base_health = base_health + bonus_health
	
	
func update_xp(value:int):
	current_xp = current_xp + value
	if current_xp >= level_dict[str(level)] and level < 10:
		var left_over:int = current_xp - level_dict[str(level)]
		current_xp = left_over
		level += 1
	elif current_xp >= level_dict[str(level)] and level == 9:
		current_xp = level_dict[str(level)]

func on_level_up():
	current_mana = current_mana + bonus_mana
	current_health = current_health + bonus_health
	
func update_health(type:String, value:int)-> void:
	match type:
		"Increase":
			current_health += value
			if current_health >= max_health:
				current_health = max_health
		"Decrease":
			verify_shield(value)
			
func verify_shield(value:int)-> void:
	if shielding:
		if(base_defense+bonus_defense)>=value:
			return
		var damage = abs((base_defense+bonus_defense)-value)
		current_health -= damage
	else:
		current_health -= value

func update_mana(type:String,value:int)->void:
	match type:
		"Increse":
			current_mana += value
			if current_mana >= max_mana:
				current_mana = max_mana
		"Decrease":
			verify_shield(value)
			if current_health <= 0:
				pass
			
			current_mana -= value #cada ataque magico consome 5p
		
			
