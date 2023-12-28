extends Node2D

@export var carrot_resource = load("res://Scenes/Objects/carrot.tscn")

@export var x_range: Vector2
@export var y_range: Vector2

func _ready():
	var tilemap: TileMap = get_node("/root/Level/Landscape")
	var tilemap_rect = tilemap.get_used_rect()
	var top_left = tilemap.map_to_local(tilemap_rect.position)
	var bottom_right = tilemap.map_to_local(
		tilemap_rect.position + tilemap_rect.size - Vector2i(1, 1)
	)
	x_range = Vector2(top_left.x, bottom_right.x)
	y_range = Vector2(top_left.y, bottom_right.y)


func _on_timer_timeout():
	var x_coord = randi_range(x_range.x, x_range.y) # map size
	var y_coord = randi_range(y_range.x, y_range.y)
	var query = PhysicsPointQueryParameters2D.new()
	query.position = Vector2(x_coord, y_coord)
	#var result = get_world().direct_space_state.intersect_point(query)
	var world = get_world_2d()
	var bodies_at_point = world.direct_space_state.intersect_point(query)
	if not bodies_at_point:
		var carrot: Carrot = carrot_resource.instantiate()
		carrot.position = Vector2(x_coord, y_coord)
		add_child(carrot)
