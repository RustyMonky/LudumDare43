extends TextureRect

onready var scrollBar = $scrollBar
onready var scrollLabel = $scrollLabel
onready var submit = $submit

func _ready():
	setMax(gameData.playerFollowerCount)
	set_process(true)

func _process(delta):
	setText(String(scrollBar.value))

# setMax
# param [Float||Integer]
# Updates the scroll bar's max value
func setMax(maxValue):
	scrollBar.set_max(float(maxValue))

# setText
# param [String]
# Sets the text of the scroll label
func setText(labelText):
	scrollLabel.text = labelText

# Signals

# Sets the number of followers to sacrifice
func _on_submit_pressed():
	gameData.playerSacrificeCount = scrollBar.value
	print(gameData.playerSacrificeCount)

# Disables the button
func _on_submit_button_up():
	submit.disabled = true
