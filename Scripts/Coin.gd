extends Area2D

#export var energy_restored = 20
#onready var animation_player = self.get_node('../AnimationPlayer')


func _ready():
    self.connect('area_enter', self, '__on_area_enter')

func __on_area_enter(player_area):
	get_node('../AnimationPlayer').play('coin')
#	get_parent().queue_free()
	