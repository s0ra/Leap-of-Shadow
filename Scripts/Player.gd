extends AnimatedSprite

const UNIT_RIGHT = Vector2(1, 0)
const UNIT_DOWN = Vector2(0, 1)
const UNIT_LEFT = Vector2(-1, 0)
const UNIT_UP = Vector2(0, -1)

onready var ray_casts = {
    UNIT_RIGHT: self.get_node('RayCast2DRight'),
    UNIT_DOWN: self.get_node('RayCast2DDown'),
    UNIT_LEFT: self.get_node('RayCast2DLeft'),
    UNIT_UP: self.get_node('RayCast2DUp')
}
onready var __states = self.get_node('/root/Game/States')
onready var __state = self.__states.get_node('IdlePlayer')

func transition_to(state):
	self.__state = state
	self.__state.enter(self)

func _ready():
	self.__state.enter(self)

func _input(event):
	self.__state.input(self, event)

func _fixed_process(delta_time):
	self.__state.update(self, delta_time)