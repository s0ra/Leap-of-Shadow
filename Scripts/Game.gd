extends Node

export var window_zoom = 1
onready var __board = self.get_node('Board')
onready var __Pathfinding = self.get_node('Pathfinding')
var map

func __set_screen():
	var board_size = (self.__board.dimension) * self.__board.__tile_collection.tile_size
	self.get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_MODE_2D, board_size)
	OS.set_window_size(window_zoom * board_size)

func _ready():
	randomize()
	self.__board.fetch_tiles('res://Scenes/TileSet.tscn', 'Floors/1')
	map = self.__board.generate_maze()
	self.__board.make_board(map, self.__board.dimension)
	
	self.__set_screen()
	#set_process_input(true)

#func _input(event):
#	if event.is_action_pressed('mouse_left'):
#		print(__Pathfinding.search(map, Vector2(1, 1), Vector2(11, 15)))
#		for xy in __Pathfinding.search(map, Vector2(1, 1), Vector2(11, 15)):
#			__board.__add_tile(__board.__rand_tile(__board.__tile_collection.item.items), xy)
#		