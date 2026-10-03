extends Area2D

# Quanto de vida a carne recupera
@export var heal_amount: int = 1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	# Toca a animação de "surgir" e depois fica parada no chão
	sprite.play("spawn")
	await  sprite.animation_finished
	sprite.play("idle")
	
# Conectado pelo editor: Meat (Area2D) > aba Signals > body_entered
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.heal(heal_amount)
		GameManager.meat_collected += 1
		queue_free()
