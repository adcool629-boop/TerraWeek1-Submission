extends CharacterBody2D

signal player_died

const SPEED = 300.0
var Phealth = 100
var LastDirection: Vector2 = Vector2.RIGHT
var IsAttacking
var HitboxOffset: Vector2
var strength: int = 20
@onready var hit_box: Area2D = $HitBox
@onready var Phealth_bar = $"../CanvasLayer/HealthBar"

func _ready() -> void:
	# Initialize HitboxOffset
	HitboxOffset = hit_box.position
	
	
func _physics_process(_delta: float) -> void:
	#Disable HitBox till an attack is triggered
	hit_box.monitoring = false
	
	if Input.is_action_just_pressed('Attack') and not IsAttacking:
		Attack()
		
	if IsAttacking:
		velocity = Vector2.ZERO
		return
	
	process_movement()
	process_animation()
	move_and_slide()

	
	
	#--------------------------------------
	#Movement and Animation
	#--------------------------------------
func process_movement() -> void:
	
	var direction := Input.get_vector("left", "right","up", "down")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		LastDirection = direction
		update_HitBoxOffset()
	else:
		velocity = Vector2.ZERO
	
	
	

func process_animation() -> void:
	if IsAttacking == true:
		return
	if velocity != Vector2.ZERO:
		play_animation('Walk', LastDirection)
	else: 
		play_animation('Idle', LastDirection)
		
		
func play_animation(prefix: String, dir: Vector2) -> void:
	if dir.x != 0:
		$AnimatedSprite2D.flip_h = dir.x < 0
		$AnimatedSprite2D.play(prefix + 'Right')
	elif dir.y > 0: 
		$AnimatedSprite2D.play(prefix + 'Down')
	elif dir.y < 0: 
		$AnimatedSprite2D.play(prefix + 'Up')

#
#ATTACKING
#
func Attack() -> void:
	IsAttacking = true
	hit_box.monitoring = true
	play_animation('Swing',LastDirection)
	print("Attack")
	$SwingSword.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	if IsAttacking:
		IsAttacking = false

#------------------------
#HITBOX
#------------------------
func update_HitBoxOffset() -> void:
	var x := HitboxOffset.x
	var y := HitboxOffset.y
	
	match LastDirection:
		Vector2.LEFT:
			hit_box.position = Vector2(-x,y)
		Vector2.RIGHT:
			hit_box.position = Vector2(x,y)
		Vector2.UP:
			hit_box.position = Vector2(y,-x)
		Vector2.DOWN:
			hit_box.position = Vector2(-y,x)
		
		
		
func _on_hit_box_body_entered(body: Node2D) -> void:
	if IsAttacking and body.name.begins_with("Slime"):
		body.take_damage(strength,position)
func take_damage(amount: int) -> void:
	Phealth -= amount
	print(Phealth)
	var Phealth_bar = $"../CanvasLayer/HealthBar"
	if Phealth_bar:
		Phealth_bar.value = Phealth
	if Phealth <= 0:
		player_died.emit()

func heal(number: int) -> void:
	if Phealth < 100:
		Phealth += number
		print("+ 10 Health, Health is now at", Phealth)
	else: 
		print("Already Full HP")
		return
	if Phealth_bar:
		Phealth_bar.value = Phealth
func damage(numeral: int) -> void:
	Phealth -= numeral
	print(Phealth)
	if Phealth_bar:
		Phealth_bar.value = Phealth
