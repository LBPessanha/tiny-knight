extends CharacterBody2D

@export var speed: float = 80.0
@export var health: int = 3
@export var damage: int = 1
@export var attack_range: float = 60.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var player: Node2D
var is_attacking: bool = false


func _ready() -> void:
	add_to_group("enemies")
	player = get_tree().get_first_node_in_group("player")


func _physics_process(_delta: float) -> void:
	#Sem jogador, ou jogador morto: fica parado comemorando
	if player == null or player.is_dead:
		if not is_attacking:
			sprite.play("idle")
		return
	# Durante o ataque, fica parado esperando a animação terminar
	if is_attacking:
		return	

	var direction := global_position.direction_to(player.global_position)
	var distance := global_position.distance_to(player.global_position)
	
	if abs(direction.x) > 0.1:
		sprite.flip_h = direction.x < 0
	
	# Perto o suficiente? Ataca. Senão, persegue.
	if distance <= attack_range:
		attack(direction)
	else:
		velocity = direction * speed
		move_and_slide()
		sprite.play("run")	

func attack(direction: Vector2) -> void:
	is_attacking = true
	if abs(direction.y) > abs(direction.x):
		sprite.play("attack_up" if direction.y < 0 else "attack_down")
	else:
		sprite.play("attack_side")

func try_hit_player() -> void:
	# O cavaleiro ainda está no alcance? (ele pode ter fugido durante o golpe)
	if global_position.distance_to(player.global_position) <= attack_range + 10:
		player.take_damage(damage)

func take_damage(amount: int) -> void:
	health -= amount

	# Feedback visual: pisca vermelho e volta ao normal em 0.2s
	modulate = Color.RED
	var tween := create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)

	if health <= 0:
		die()


func die() -> void:
	GameManager.enemies_defeated += 1
	queue_free()


# Conectado pelo editor: aba Signals > frame_changed
func _on_animated_sprite_2d_frame_changed() -> void:
	if not is_node_ready():
		return
	# No quadro 3 do ataque a tocha "acerta"
	if sprite.animation.begins_with("attack") and sprite.frame == 3:
		try_hit_player()
 
 
# Conectado pelo editor: aba Signals > animation_finished
func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation.begins_with("attack"):
		is_attacking = false
