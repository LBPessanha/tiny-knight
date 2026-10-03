extends Node

# Aviso para quem quiser saber que o jogo acabou (usaremos no Game Over do Lab)
signal game_over

var time_elapsed: float = 0.0
var enemies_defeated: int = 0
var is_game_over: bool = false

# Área andável da ilha (preenchida pelo game.gd)
var world_rect: Rect2 = Rect2()


func _process(delta: float) -> void:
	# O relógio só anda enquanto o jogo está rolando
	if not is_game_over:
		time_elapsed += delta


func end_game() -> void:
	if is_game_over:
		return
	is_game_over = true
	game_over.emit()


func reset() -> void:
	time_elapsed = 0.0
	enemies_defeated = 0
	is_game_over = false
