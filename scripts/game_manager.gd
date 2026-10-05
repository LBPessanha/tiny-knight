extends Node

# Aviso para quem quiser saber que o jogo acabou (a tela de Game Over escuta)
signal game_over

# Arquivo onde o recorde fica salvo (funciona no PC e no navegador)
const SAVE_PATH := "user://save.cfg"

var time_elapsed: float = 0.0
var enemies_defeated: int = 0
var meat_collected: int = 0
var is_game_over: bool = false

# Recorde
var best_time: float = 0.0
var is_new_record: bool = false

# Área andável da ilha (preenchida pelo game.gd)
var world_rect: Rect2 = Rect2()


func _ready() -> void:
	load_record()


func _process(delta: float) -> void:
	# O relógio só anda enquanto o jogo está rolando
	if not is_game_over:
		time_elapsed += delta


func end_game() -> void:
	if is_game_over:
		return
	is_game_over = true

	# Bateu o recorde? Guarda no arquivo
	if time_elapsed > best_time:
		best_time = time_elapsed
		is_new_record = true
		save_record()

	game_over.emit()


func reset() -> void:
	time_elapsed = 0.0
	enemies_defeated = 0
	meat_collected = 0
	is_game_over = false
	is_new_record = false


# Transforma segundos em texto "mm:ss" (ex: 125 -> "02:05")
func format_time(seconds: float) -> String:
	var minutes := floori(seconds / 60)
	var secs := int(seconds) % 60
	return "%02d:%02d" % [minutes, secs]


func save_record() -> void:
	var config := ConfigFile.new()
	config.set_value("record", "best_time", best_time)
	config.save(SAVE_PATH)


func load_record() -> void:
	var config := ConfigFile.new()
	# Se o arquivo ainda não existe (primeira vez jogando), fica com 0
	if config.load(SAVE_PATH) == OK:
		best_time = config.get_value("record", "best_time", 0.0)
