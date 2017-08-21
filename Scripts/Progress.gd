extends Node

var MAX_LV_Y = 5
onready var param
onready var level_id = Vector2(1, 0)
onready var down = get_node('/root/Game/Down')
var target
var x = 5
var y = 1
var z = 20
var WAIT = 0.5
var wait = WAIT

class lv_param:
	var min_ene = 0
	var max_ene = 0
	var difficulty_scores = 0
	var has_predator = false
	var has_alarmer = false
	var has_jumper = false
	var has_fb_siders = false
	var has_two_siders = false
	var has_three_siders = false
	var has_all_siders = false
	var has_all_predator = false
	var has_target = false
	var predators_size = 0
	var all_siders_size = 0
	var item

var obj = {
	'NONE': 0,
	'KILL': 1,
	'TERROR': 2,
	'HIDE': 3
}
var type = {
	'TURTLE': 0,
	'SPIKY': 1
}

#class progress:
#	var level_id = Vector2(0, 0)
#	var item_stolen = []
#	var enemies_type = []
#	var enemies_xy = []
#	var enemies_pos = []
#	var target = 0
#	var objective = obj.NONE

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func _fixed_process(delta_time):
	
	var wr = weakref(target)
	if not wr.get_ref():
		wait -= delta_time
		down = get_node('/root/Game/Down')
		down.percent = int((WAIT-wait)/WAIT*100)
		if wait <= 0:
			var player = get_tree().get_nodes_in_group('player').back()
			Globals.set('player_xy', pos_to_xy(player.get_pos()))
			wait = WAIT
			get_tree().reload_current_scene()

func loading():
	pass

func saving():
	pass

func new_parameters():
	param = lv_param.new()
	param.min_ene = 3 + int(level_id.x * 1.5)
	param.max_ene = param.min_ene + randi() % int(level_id.y) + 1
	param.difficulty_scores = z + level_id.x * x + level_id.y * y
	if not level_id.y == 1 or not level_id.y == 5:
		param.has_target = true
	if level_id.x == 1 or randi() % 101 > 50 * (1 - level_id.y / MAX_LV_Y):
		param.has_predator = true
	param.has_alarmer = false
	param.has_jumper = false
	param.has_fb_siders = false
	param.has_two_siders = false
	param.has_three_siders = false
	param.has_all_siders = false
	param.has_all_predator = false
	param.item = null
	param.predators_size = 0
	param.all_siders_size = 0

func next_level():
	level_id.y += 1
	if level_id.y == MAX_LV_Y + 1:
		level_id.x += 1
		level_id.y = 1

func pos_to_xy(pos):
	var xy = Vector2(int(pos.x / 32), int(pos.y / 32))
	return xy