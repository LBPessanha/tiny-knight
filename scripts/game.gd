extends Node2D

# Distância (em pixels) entre a borda da ilha e a "parede invisível"
@export var wall_margin: float = 32.0
@export var camera_margin: float = 128.0

@onready var ground: TileMapLayer = $Ground

func  _ready() -> void:
	# 1. Descobre o tamanho da ilha a partir dos tiles pintados no Ground
	var	tile_size := Vector2(ground.tile_set.tile_size)
	var used := ground.get_used_rect()  # em TILES (ex: 40 x 25)
	var map_rect := Rect2(Vector2(used.position) * tile_size, Vector2(used.size) * tile_size) # Em PIXEL
	
	# 2. A câmera não mostra nada além da ilha
	setup_camera_limits(map_rect.grow(camera_margin))
	
	# 3. Área andável = ilha um pouco "encolhida" (para não pisar na beira da água)
	var walk_rect := map_rect.grow(-wall_margin)
	GameManager.world_rect = walk_rect
	create_walls(walk_rect)

func setup_camera_limits(rect: Rect2) -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	var camera: Camera2D = player.get_node("Camera2D")
	camera.limit_left = int(rect.position.x)
	camera.limit_top = int(rect.position.y)
	camera.limit_right = int(rect.end.x)
	camera.limit_bottom = int(rect.end.y)
	
func create_walls(rect: Rect2) -> void:
	# Um corpo estático (não se move) na camada 1 = "world"
	var walls := StaticBody2D.new()
	walls.name = "WorldWalls"
	add_child(walls)
	
	# 4 "linhas infinitas", cada uma empurrando para DENTRO da ilha
	var sides := [
		[Vector2(rect.position.x, 0), Vector2.RIGHT],  # parede da esquerda
		[Vector2(rect.end.x, 0), Vector2.LEFT],        # parede da direita
		[Vector2(0, rect.position.y), Vector2.DOWN],   # parede de cima
		[Vector2(0, rect.end.y), Vector2.UP],          # parede de baixo
		
	]
	
	for side in sides:
		var shape := WorldBoundaryShape2D.new()
		shape.normal = side[1]
		var collision := CollisionShape2D.new()
		collision.shape = shape
		collision.position = side[0]
		walls.add_child(collision)
	
	
