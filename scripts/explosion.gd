extends Area2D

# Preenchido pela dinamite antes de entrar no jogo
var damage: int = 1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	sprite.play("explode")

	# Uma Area2D recém-criada precisa de um instante de física
	# para "enxergar" quem está dentro dela
	await get_tree().physics_frame
	await get_tree().physics_frame

	for body in get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(damage)

	# Espera a animação da explosão terminar e some
	await sprite.animation_finished
	queue_free()
