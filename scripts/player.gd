extends CharacterBody2D

signal health_changed(current: int, maximum: int)
signal died

@export var speed: float = 220.0
@export var max_health: int = 100
@export var attack_damage: int = 20
@export var attack_cooldown: float = 0.5

var health: int
var is_dead: bool = false
var is_attacking: bool = false
var attack_timer: float = 0.0

@onready var attack_area: Area2D = $AttackArea
@onready var health_bar: ProgressBar = $HealthBar
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	add_to_group("player")

	health = max_health

	health_bar.max_value = max_health
	health_bar.value = health

	health_changed.emit(health, max_health)


func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		return

	attack_timer = maxf(attack_timer - delta, 0.0)

	# Comienza el ataque al presionar Space
	if Input.is_action_just_pressed("player_attack"):
		start_attack()

	# Termina el ataque al soltar Space
	if Input.is_action_just_released("player_attack"):
		stop_attack()

	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	velocity = direction * speed
	move_and_slide()


func start_attack() -> void:
	if is_dead:
		return

	if attack_timer > 0.0:
		return

	attack_timer = attack_cooldown
	is_attacking = true

	if animated_sprite.sprite_frames.has_animation("attack"):
		animated_sprite.play("attack")

	print("PLAYER ATACA")

	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			if body.has_method("take_damage"):
				body.take_damage(attack_damage)
				print("Golpeó a: ", body.name)


func stop_attack() -> void:
	if not is_attacking:
		return

	is_attacking = false

	if animated_sprite.sprite_frames.has_animation("idle"):
		animated_sprite.play("idle")
	else:
		animated_sprite.stop()


func take_damage(amount: int) -> void:
	if is_dead:
		return

	health = maxi(health - amount, 0)

	health_bar.value = health
	health_changed.emit(health, max_health)

	if health == 0:
		die()


func die() -> void:
	is_dead = true
	is_attacking = false
	velocity = Vector2.ZERO

	if animated_sprite.sprite_frames.has_animation("death"):
		animated_sprite.play("death")
	else:
		animated_sprite.stop()

	died.emit()
