extends CharacterBody2D

@export var speed: float = 40.0
@export var flee_speed: float = 120.0
@export var health: int = 2

@export_group("Drop")
@export var drop_scene: PackedScene
@export_range(0.0, 1.0) var drop_chance: float = 1.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction: Vector2 = Vector2.ZERO
var state_time: float = 0.0
var is_fleeing: bool = false

func _ready() -> void:
	add_to_group("sheep")
	choose_new_state()
	
func _physics_process(delta: float) -> void:
	# Contagem regressiva: quando chega a zero, a ovelha "decide" de novo
	state_time -= delta
	if state_time <= 0:
		choose_new_state()
	
	var current_speed := flee_speed if is_fleeing else speed

	# Só anda nos quadros em que está no ar (pulinhos!)
	var in_air := sprite.animation == "move" and sprite.frame >= 1 and sprite.frame <= 4
	if in_air or is_fleeing:
		velocity = direction * current_speed
	else:
		velocity = Vector2.ZERO

		move_and_slide()

	# Bateu em algo enquanto andava? Quica e segue no sentido oposto
	if get_slide_collision_count() > 0 and not is_fleeing and velocity != Vector2.ZERO:
		var normal := get_slide_collision(0).get_normal()
		direction = direction.bounce(normal)
	
	
	if direction.x != 0:
		sprite.flip_h = direction.x < 0
	sprite.play("move" if direction != Vector2.ZERO else "idle")
	
func choose_new_state() -> void:
	is_fleeing = false
	# Fica nesse estado por um tempo aleatório entre 1.5 e 3.5 segundos
	state_time = randf_range(1.5, 3.5)
	
	# Cara ou coroa: metade das vezes pasta parada, metade passeia
	if randf() < 0.5:
		direction = Vector2.ZERO
	else:
		direction = Vector2.RIGHT.rotated(randf() * TAU)
		
func take_damage(amount: int) -> void:
	health -= amount
	
	modulate = Color.RED
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
	
	if health <= 0:
		die()
		return
	
	flee()
	
func flee() -> void:
		# Corre na direção OPOSTA ao cavaleiro por 1 segundo
		var player = get_tree().get_first_node_in_group("player")
		if player == null:
			return
		direction = player.global_position.direction_to(global_position)
		is_fleeing = true
		state_time = 1.0
		
func die() -> void:
		try_drop()
		queue_free()
		
func try_drop() -> void:
		if drop_scene and randf() < drop_chance:
			var drop = drop_scene.instantiate()
			drop.position = position
			get_parent().add_child.call_deferred(drop)
			
