extends Node2D

@export var flight_time: float = 0.8   # quanto tempo a dinamite fica no ar
@export var arc_height: float = 80.0   # altura do arco do arremesso
@export var explosion_scene: PackedScene

# Preenchidos pelo goblin TNT antes de entrar no jogo
var target: Vector2
var damage: int = 1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	sprite.play("spin")

	# 1. Voa em linha reta até o alvo...
	var flight := create_tween()
	flight.tween_property(self, "global_position", target, flight_time)

	# 2. ...enquanto o DESENHO sobe e desce, criando a ilusão de um arco
	var arc := create_tween()
	arc.tween_property(sprite, "position:y", -arc_height, flight_time / 2) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	arc.tween_property(sprite, "position:y", 0.0, flight_time / 2) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	await flight.finished
	explode()


func explode() -> void:
	if explosion_scene:
		var explosion = explosion_scene.instantiate()
		explosion.position = position
		explosion.damage = damage
		get_parent().add_child(explosion)
	queue_free()
