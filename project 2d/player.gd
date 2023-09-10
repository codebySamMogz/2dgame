extends CharacterBody2D

var speed = 700
var jump = 900
var gravity = 30
var hp = 100

@onready var sprite = $Sprite2D
@onready var ap = $AnimationPlayer
@onready var atk_cd = $atk_cd
@onready var dmg_counter = $dmg_counter

var attacking = false
var taking_damage = false
var cd = false

func player():
	pass

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity
		
	var LR = Input.get_axis("left", "right")
	velocity.x = speed * LR
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y -= jump
			
	if Input.is_action_pressed("attack"):
		atk_cd.start()
		attacking = true
	
	if velocity.x != 0:
		sprite.flip_h = (velocity.x < 0)
		
	print(hp)
	damage()
	move_and_slide()
	death()
	animation(LR)
	
func animation(LR):
	if attacking == true:
		ap.play("attack")
	else:
		if velocity.y < 0:
			ap.play("jump")
		elif velocity.y > 0:
			ap.play("fall")
		elif LR != 0:
			ap.play("running")
		else:
			ap.play("idle")

func death():
	if hp <= 0:
		get_tree().reload_current_scene()
		
#attack animation delay
func _on_atk_cd_timeout():
	attacking = false

#detects if npc can attack
func _on_hit_box_area_entered(area):
	if area.is_in_group("npc_atk_range"):
		taking_damage = true

func _on_hit_box_area_exited(area):
	if area.is_in_group("npc_atk_range"):
		taking_damage = false

#implement attack damage
func damage():
	if taking_damage and cd:
		dmg_counter.start()
		hp -= 10
		cd =false
		
func _on_dmg_counter_timeout():
	cd = true
	dmg_counter.stop()


