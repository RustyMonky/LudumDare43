extends CenterContainer

onready var label = $patch/patchMargins/label

func _ready():
	pass

func setText(labelText):
	label.text = String(labelText)
