extends CanvasLayer

# Tempo para o jogador ver o cavaleiro caindo antes da tela aparecer
@export var show_delay: float = 1.5

@onready var stats_label: Label = %StatsLabel
@onready var record_label: Label = %RecordLabel
@onready var restart_button: Button = %RestartButton


func _ready() -> void:
	hide()
	# "Escuta" o aviso do GameManager
	GameManager.game_over.connect(_on_game_over)


func _on_game_over() -> void:
	await get_tree().create_timer(show_delay).timeout

	stats_label.text = "Tempo: %s\nGoblins derrotados: %d\nCarnes coletadas: %d" % [
		GameManager.format_time(GameManager.time_elapsed),
		GameManager.enemies_defeated,
		GameManager.meat_collected,
	]

	if GameManager.is_new_record:
		record_label.text = "NOVO RECORDE!"
	else:
		record_label.text = "Recorde: %s" % GameManager.format_time(GameManager.best_time)
	
	$Background.modulate.a = 0.0
	show()
	create_tween().tween_property($Background, "modulate:a", 1.0, 0.6)
		
	# Foco no botão: Enter, Espaço ou o botão do controle já "clicam" nele
	restart_button.grab_focus()


# Conectado pelo editor: RestartButton > Signals > pressed
func _on_restart_button_pressed() -> void:
	GameManager.reset()
	get_tree().reload_current_scene()
