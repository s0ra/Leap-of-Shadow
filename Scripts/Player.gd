extends AnimatedSprite

onready var __states = self.get_node('root/Game/States')
onready var __state = self.__states.get_node('IdlePlayer')