extends CharacterBody2D


const SPEED: int = 100
const knockbackforce: int = 100
var Target = null
var health: int = 100
var strength: int = 10
var alive: bool = true
var knockbackvelocity: Vector2 = Vector2.ZERO
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var take_damage_sound: AudioStreamPlayer2D = $TakeDamage
@onready var death_timer: Timer = $DeathTimer
@onready var health_bar: Node2D = $HealthBar
@onready var damage_timer: Timer = $DamageTimer




func _physics_process(delta: float) -> void:
	if alive and Target:
		_attack(delta)
		
	if knockbackvelocity.length() > 1.0:
		move_and_collide(knockbackvelocity *delta)
		knockbackvelocity = knockbackvelocity.move_toward(Vector2.ZERO, knockbackforce * 2.0 * delta)
	else:
		knockbackvelocity = Vector2.ZERO

func _attack(delta: float) -> void:
	var direction = (Target.position - position).normalized()
	var movement = direction * SPEED * delta
	move_and_collide(movement)
	animated_sprite_2d.play("Attack")


func take_damage(damage:int, attacker_position: Vector2) -> void:
	health -= damage
	health_bar.update_health(health)
	print(health)
	if health <= 0:
		_die()
	else:
		take_damage_sound.play()
	
	#knockback
	
	var knockbackdirection = (position - attacker_position).normalized()
	knockbackvelocity = knockbackdirection * knockbackforce * 4.0
	
	
func _die() -> void:
	alive = false
	animated_sprite_2d.play("Death")
	take_damage_sound.pitch_scale = 0.5
	take_damage_sound.play()
	
	#Disable Collision
	$CollisionShape2D.set_deferred("disabled",true)
	$Sight/CollisionShape2D.set_deferred("disabled",true)
	health_bar.queue_free()
	death_timer.start()


func _on_sight_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		Target = body
		print("Player Detected")


func _on_sight_body_exited(body: Node2D) -> void:
	if body.name == 'Player' and alive:
		Target = null
		animated_sprite_2d.play('Idle')


func _on_death_timer_timeout() -> void:
	queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		body.take_damage(strength)
		damage_timer.start()


func _on_damage_timer_timeout() -> void:
	for body in $Hitbox.get_overlapping_bodies():
		if body.name == 'Player':
			body.take_damage(strength)


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body.name == 'Player':
		damage_timer.stop()
