extends TileMapLayer

@onready var world: TileMapLayer = $"."

func _ready():
	var tilemap = world  # adjust path if needed
	var rect = tilemap.get_used_rect()
	var tile_size = tilemap.tile_set.tile_size
	print("World size in pixels: ", rect.size * tile_size)
	print("World origin in pixels: ", rect.position * tile_size)
