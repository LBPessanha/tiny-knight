extends CharacterBody2D

@export var speed: float = 60.0
@export var health: int = 2
@export var damage: int = 1
@export var min_range: float = 200.0      # perto demais? recua
@export var max_range: float = 350.0      # longe demais? se aproxima
@export var throw_cooldown: float = 2.5   # segundos entre um lançamento e outro
@export var dynamite_scene: PackedScene

@export_group("Drop")
@export var drop_scene: PackedScene
@export_range(0.0, 1.0) var drop_chance: float = 0.25

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var player: Node2D
var is_throwing: bool = false
var cooldown: float = 0.0


func _ready() -> void:
	add_to_group("enemies")
	add_to_group("tnt")
	player = get_tree().get_first_node_in_group("player")
	# Começa com uma espera sorteada, para os TNTs não lançarem todos juntos
	cooldown = randf() * throw_cooldown


func _physics_process(delta: float) -> void:
	if player == null or player.is_dead:
		if not is_throwing:
			sprite.play("idle")
		return

	cooldown -= delta

	if is_throwing:
		return

	var to_player := player.global_position - global_position
	var distance := to_player.length()
	var direction := to_player.normalized()

	if abs(direction.x) > 0.1:
		sprite.flip_h = direction.x < 0

	# Mantém distância: nem perto, nem longe demais
	if distance > max_range:
		velocity = direction * speed       # se aproxima
	elif distance < min_range:
		velocity = -direction * speed      # recua
	else:
		velocity = Vector2.ZERO            # na distância ideal
		if cooldown <= 0:
			throw()

	move_and_slide()

	if not is_throwing:
		sprite.play("run" if velocity != Vector2.ZERO else "idle")


func throw() -> void:
	is_throwing = true
	cooldown = throw_cooldown
	sprite.play("throw")


func launch_dynamite() -> void:
	if dynamite_scene == null or player == null:
		return
	var dynamite = dynamite_scene.instantiate()
	dynamite.position = position
	dynamite.target = player.global_position   # mira onde o cavaleiro ESTÁ agora
	dynamite.damage = damage
	get_parent().add_child(dynamite)


func take_damage(amount: int) -> void:
	health -= amount

	modulate = Color.RED
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)

	if health <= 0:
		die()


func die() -> void:
	GameManager.enemies_defeated += 1
	try_drop()
	queue_free()


func try_drop() -> void:
	if drop_scene and randf() < drop_chance:
		var drop = drop_scene.instantiate()
		drop.position = position
		get_parent().add_child.call_deferred(drop)


# Conectado pelo editor: AnimatedSprite2D > Signals > frame_changed
func _on_animated_sprite_2d_frame_changed() -> void:
	if not is_node_ready():
		return
	# No quadro 3 do arremesso, a dinamite sai da mão
	if sprite.animation == "throw" and sprite.frame == 3:
		launch_dynamite()


# Conectado pelo editor: AnimatedSprite2D > Signals > animation_finished
func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "throw":
		is_throwing = false
