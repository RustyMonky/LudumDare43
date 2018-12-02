extends CenterContainer

onready var label = $patch/patchMargins/label
onready var vertScroll = $patch/vertScroll

func _ready():
	pass

func setText(labelText):
	label.text = String(labelText)
