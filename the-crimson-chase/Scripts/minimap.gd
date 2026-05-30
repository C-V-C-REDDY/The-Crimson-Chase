extends Control

const MAP_WIDTH = 150.0
const MAP_HEIGHT = 106.0
const WORLD_SIZE = Vector2(6400, 4496)
const WORLD_ORIGIN = Vector2(-256, -256)
const MARGIN = 10.0

var player: Node2D = null
var safe_zone: Node2D = null
var keys = null
var elite_pooring: Node2D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	safe_zone = get_tree().get_first_node_in_group("safe_zone")
	keys = get_tree().get_first_node_in_group("key")
	elite_pooring = get_tree().get_first_node_in_group("elite_pooring")
	set_position(Vector2(get_viewport_rect().size.x - MAP_WIDTH - MARGIN, MARGIN))


func _process(delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	#BackGround
	draw_rect(Rect2(0, 0, MAP_WIDTH, MAP_HEIGHT), Color(0, 0, 0, 0.6) )
	#Border
	draw_rect(Rect2(0, 0, MAP_WIDTH, MAP_HEIGHT), Color(0.6, 0, 0, 1.0), false, 1.5)
	#safezone dot
	if safe_zone:
		var sz_pos = world_to_map(safe_zone.global_position)
		draw_circle(sz_pos, 5.0 , Color(1.0, 0.6, 0.0, 0.8))
	
	#player dot
	if player:
		var p_pos = world_to_map(player.global_position)
		draw_circle(p_pos, 3.5, Color(0.9, 0.1, 0.1, 1.0))
	
	for keys in get_tree().get_nodes_in_group("key"):
		var k_pos = world_to_map(keys.global_position)
		draw_circle(k_pos, 3.0, Color(1.0, 0.85, 0.0, 1.0))
	
	for elite_pooring in get_tree().get_nodes_in_group("elite_pooring"):
		var ep_pos = world_to_map(elite_pooring.global_position)
		draw_circle(ep_pos , 3.75, Color(0.0, 0.8, 0.4, 1.0))


func world_to_map(world_pos: Vector2) -> Vector2:
	var relative = world_pos - WORLD_ORIGIN
	var normalized = relative / WORLD_SIZE
	return normalized * Vector2(MAP_WIDTH, MAP_HEIGHT)
