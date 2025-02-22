extends Sprite
class_name SpritePlayer
var normal_attack:bool = false
var suffix:String = "Right"

# 24/05/2024: Controlar ações de agachar e defender
var shield_off:bool = false
var crouch_off:bool = false

export(NodePath) onready var animation_player = get_node(animation_player) as AnimationPlayer
export(NodePath) onready var player = get_node(player) as KinematicBody2D
export(NodePath) onready var attack_collision = get_node(attack_collision as CollisionShape2D)

# Função é um bloco ou trecho de código que pode ser reutilizado no programa
func animate(direction:Vector2)->void:
	verify_direction(direction)
	if player.on_hit or player.dead:
		hit_behavior()
	if player.attacking or player.defending or player.crouching or player.next_to_wall():
		action_behavior()
	elif direction.y !=0:
		vertical_behavior(direction)
	elif player.landing == true:
		animation_player.play("Landing")
		player.set_physics_process(false)
	else:
		horizontal_behavior(direction)
	
func vertical_behavior(direction:Vector2):
	if direction.y > 0:
		player.landing = true
		animation_player.play("Fall")
	elif direction.y < 0:
		animation_player.play("Jump")
	
func verify_direction(direction:Vector2)->void:
	if direction.x > 0:
		flip_h = false
		suffix = "Right"
		player.direction = -1
		position = Vector2.ZERO
		player.wall_ray.cast_to = Vector2(5.5, 0)
	elif direction.x < 0:
		flip_h = true
		suffix = "Left"
		player.dirction = 1
		position = Vector2(-2, 0)
		player.wall_ray.cast_to = Vector2(-7.5, 0)
		
func hit_behavior()->void:
	player.set_physics_process(false)
	if player.dead:
		animation_player.play("Dead")
	elif player.on_hit:
		animation_player.play("Hit")

func horizontal_behavior(direction):
	if direction.x != 0:
		animation_player.play("Run")
	else:
		animation_player.play("Idle")

func action_behavior()->void:
	if player.next_to_wall():
		animation_player.play("WallSlide")
	elif player.attacking and normal_attack:
		animation_player.play("Attack"+suffix)
	elif player.defending and shield_off:
		animation_player.play("Shield")
		shield_off = false
	elif player.crouching and crouch_off:
		animation_player.play("Crouch")
		crouch_off = false
	
	
func _on_Animation_animation_finished(anim_name:String):
	match anim_name:
		"Landing":
			player.landing = false
			player.set_physics_process(true)
		"AttackLeft":
			player.attacking = false
			normal_attack = false
		"AttackRight":
			player.attacking = false
			normal_attack = false
		"Hit":
			player.on_hit = false
			player.set_physics_process(true)
			if player.defending:
				animation_player.play("Shield")
			if player.crouching:
				animation_player.play("Crouch")
