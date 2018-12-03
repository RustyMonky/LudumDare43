extends Container

onready var play = $play

func _ready():
	pass

# Signals

func _on_play_pressed():
	play.disabled = true
	fader.fade("res://scenes/game/game.tscn")
