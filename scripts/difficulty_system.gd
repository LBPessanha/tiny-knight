extends Node

# O Spawner que este sistema vai controlar (arraste o GoblinSpawner no Inspector)
@export var spawner: Node2D

@export_group("Ritmo de goblins (por minuto)")
@export var base_per_minute: float = 30.0      # ritmo no início do jogo
@export var growth_per_minute: float = 20.0    # quanto aumenta a cada minuto
@export var wave_amplitude: float = 15.0       # tamanho da "onda" (sobe e desce)
@export var wave_period: float = 30.0          # duração de uma onda completa (segundos)

@export_group("Goblin TNT")
@export var tnt_spawner: Node2D               # arraste o TNTSpawner no Inspector
@export var tnt_unlock_time: float = 60.0     # segundos até os TNTs aparecerem

@export_group("Limite de goblins vivos")
@export var base_max_enemies: int = 10
@export var max_enemies_growth: float = 5.0    # +5 de limite a cada minuto
@export var max_enemies_cap: int = 40          # teto absoluto (protege o desempenho)

var timer: Timer


func _ready() -> void:
	timer = spawner.get_node("Timer")


func _process(_delta: float) -> void:
	if GameManager.is_game_over:
		return

	var t := GameManager.time_elapsed
	var minutes := t / 60.0

	# A "onda": sin() vai de -1 a +1 e volta, repetindo a cada wave_period segundos
	var wave := sin(t / wave_period * TAU)

	# Ritmo = base + crescimento com o tempo + onda
	var per_minute := base_per_minute + growth_per_minute * minutes + wave_amplitude * wave
	per_minute = max(per_minute, 5.0)  # nunca menos de 5 por minuto

	# Converte "goblins por minuto" em "segundos entre um goblin e outro"
	timer.wait_time = 60.0 / per_minute

	# O limite de goblins vivos também cresce, até o teto
	spawner.max_enemies = mini(base_max_enemies + int(max_enemies_growth * minutes), max_enemies_cap)

	unlock_tnt(t)


func unlock_tnt(t: float) -> void:
	if tnt_spawner == null or t < tnt_unlock_time:
		return
	# Chegou a hora! Liga o Timer do TNTSpawner (uma única vez)
	var tnt_timer: Timer = tnt_spawner.get_node("Timer")
	if tnt_timer.is_stopped():
		tnt_timer.start()
