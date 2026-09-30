extends CanvasLayer

# O % acessa nós marcados como "Unique Name" (nome único) na cena
@onready var health_bar: ProgressBar = %HealthBar
@onready var kills_label: Label = %KillsLabel
@onready var time_label: Label = %TimeLabel


func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	# Mostra a vida inicial e passa a "escutar" o sinal do cavaleiro
	health_bar.max_value = player.max_health
	health_bar.value = player.health
	player.health_changed.connect(_on_player_health_changed)


func _process(_delta: float) -> void:
	kills_label.text = "Goblins: %d" % GameManager.enemies_defeated

	var minutes := floori(GameManager.time_elapsed / 60)
	var seconds := int(GameManager.time_elapsed) % 60
	time_label.text = "%02d:%02d" % [minutes, seconds]


func _on_player_health_changed(current: int, maximum: int) -> void:
	health_bar.max_value = maximum
	health_bar.value = current
