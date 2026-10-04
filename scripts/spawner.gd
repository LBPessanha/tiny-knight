extends Node2D

# Qual cena vai ser "fabricada" (arraste o goblin.tscn no Inspector)
@export var enemy_scene: PackedScene
# A que distância do cavaleiro os inimigos nascem (fora da tela)
@export var spawn_distance: float = 700.0
# Limite de inimigos vivos ao mesmo tempo (protege o desempenho)
@export var max_enemies: int = 30
# Qual grupo contar para respeitar o limite ("enemies", "sheep"...)
@export var count_group: String = "enemies"


# Conectado pelo editor: Timer > aba Signals > timeout
func _on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player")

	# Sem cavaleiro, ou cavaleiro morto: para de gerar
	if player == null or player.is_dead:
		return

	# Já tem goblin demais? Espera a próxima vez
	if get_tree().get_node_count_in_group(count_group) >= max_enemies:
		return

	spawn_enemy(player.global_position)

func spawn_enemy(center: Vector2) -> void:
	# 1. Fabrica uma cópia nova da cena
	var enemy = enemy_scene.instantiate()

	# 2. Coloca no mundo (como filho do Game, "irmão" do cavaleiro)
	get_parent().add_child(enemy)

	# 3. Posiciona num ponto válido DENTRO da ilha
	enemy.global_position = find_spawn_position(center)
	enemy.reset_physics_interpolation()
	
func find_spawn_position(center: Vector2) -> Vector2:
	var rect:Rect2 = GameManager.world_rect
	
	# Sem limites definidos? Usa o círculo normal
	if not rect.has_area():
		return center + Vector2.RIGHT.rotated(randf() * TAU) * spawn_distance
	
	# Tenta até 10 ângulos sorteados até achar um ponto DENTRO da ilha
	for i in 10:
		var pos := center + Vector2.RIGHT.rotated(randf() * TAU) * spawn_distance
		if rect.has_point(pos):
			return pos
	
	# Não achou? "Empurra" o ponto para dentro da ilha
	var fallback := center + Vector2.RIGHT.rotated(randf() * TAU) * spawn_distance
	return fallback.clamp(rect.position, rect.end)
		
	
