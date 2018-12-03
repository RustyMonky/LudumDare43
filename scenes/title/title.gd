extends Container

onready var play = $play
onready var sfx = $sfx

func _ready():
	pass

# Signals

func _on_play_pressed():
	play.disabled = true
	sfx.play()
	fader.fade("res://scenes/game/game.tscn")
