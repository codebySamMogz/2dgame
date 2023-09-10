extends CharacterBody2D

var npcSpeed = 400
var npcGravity = 30
var npcHP = 80

var player_detect = false
var chase = false
var player_in_range = false
var attacking = false

@onready var zombie = $Sprite2D
@onready var ap1 = $AnimationPlayer
@onready var player1 = null #$"../player"

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += npcGravity*2
		
	if chase:
		velocity = position.direction_to(player1.position) * npcSpeed
	else:
		velocity.x = 0
		
	if velocity.x != 0:
		zombie.flip_h = (velocity.x < 0)
		
	move_and_slide()
	zombie_animation()
	atk()
	npcKilled()

func npcKilled():
	if npcHP <= 0:
		self.queue_free()
	
func atk():
	if player_in_range:
		attacking = true
	else:
		attacking = false

#animations
func zombie_animation():
	if attacking:
		ap1.play("attack")
	else:
		if velocity.x != 0:
			ap1.play("run")
		else:
			ap1.play("idle")
		

#detect player nearby
func _on_detect_player_body_entered(body):
	if body.has_method("player"):
		player1 = body
		chase = true

func _on_detect_player_body_exited(body):
	if body.has_method("player"):
		player1 = null
		chase = false

#detect player if in range then attack
func _on_atk_range_area_entered(area):
	if area.is_in_group("player_hitbox"):
		player_in_range = true

func _on_atk_range_area_exited(area):
	if area.is_in_group("player_hitbox"):
		player_in_range = false


func _on_hit_box_area_entered(area):
	if area.is_in_group("attacking_now"):
		npcHP -= 20
