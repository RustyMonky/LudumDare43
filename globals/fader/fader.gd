extends CanvasLayer

onready var animation = $faderAnim

var destination

func _ready():
	pass

# fade
# param [String] target
# Takes in a scene path and plays the fade animation
func fade(target):
	destination = target
	animation.play("fade")

# switchScene
# Switches to new scene during fade
func switchScene():
	sceneManager.goto_scene(destination)