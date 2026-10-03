extends CharacterBody2D

# Sinal próprio: avisa quem quiser saber que a vida mudou (a HUD escuta)
signal health_changed(current: int, maximum: int)

@export var speed: float = 200.0
@export var sword_damage: int = 1
@export var max_health: int = 5

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sword_area: Area2D = $SwordArea

var health: int
var is_attacking: bool = false
var is_invincible: bool = false
var is_dead: bool = false

func _ready() -> void:
	add_to_group("player")
	health = max_health


func _physics_process(_delta: float) -> void:
	# Morto não se mexe
	if is_dead:
		return
	
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if not is_attacking:
		if direction.x != 0:
			sprite.flip_h = direction.x < 0

		if Input.is_action_just_pressed("attack"):
			attack(direction)
		else:
			sprite.play("run" if direction != Vector2.ZERO else "idle")

	velocity = Vector2.ZERO if is_attacking else direction * speed
	move_and_slide()


func attack(direction: Vector2) -> void:
	is_attacking = true

	# Escolhe a animação E posiciona a hitbox da espada no lado do golpe
	if abs(direction.y) > abs(direction.x):
		if direction.y < 0:
			sprite.play("attack_up")
			sword_area.position = Vector2(0, -40)
		else:
			sprite.play("attack_down")
			sword_area.position = Vector2(0, 50)
	else:
		sprite.play("attack_side")
		sword_area.position = Vector2(-50 if sprite.flip_h else 50, 0)

	# Espera o momento em que a espada "corta" (quadro 3 de 6, a 15 FPS)
	await get_tree().create_timer(0.2).timeout
	deal_damage()


func deal_damage() -> void:
	# Pega todos os corpos que estão dentro da área da espada agora
	for body in sword_area.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			body.take_damage(sword_damage)

func take_damage(amount: int) -> void:
	# Invencível ou morto? Ignora o golpe
	if is_invincible or is_dead:
		return
 
	health -= amount
	health_changed.emit(health, max_health)
 
	if health <= 0:
		die()
		return
 
	# Invencibilidade temporária: pisca 5 vezes (1 segundo)
	is_invincible = true
	var tween := create_tween().set_loops(5)
	tween.tween_property(sprite, "modulate:a", 0.3, 0.1)
	tween.tween_property(sprite, "modulate:a", 1.0, 0.1)
	await tween.finished
	is_invincible = false

func heal(amount: int) -> void:
	if is_dead:
		return
	# min() garante que a vida nunca passe do máximo
	health = min(health + amount, max_health)
	health_changed.emit(health, max_health)

func die() -> void:
	is_dead = true
	velocity = Vector2.ZERO
	sprite.stop()
	GameManager.end_game()
 
	# Fica vermelho e some aos poucos
	sprite.modulate = Color.RED
	var tween := create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 1.0)

func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation.begins_with("attack"):
		is_attacking = false
