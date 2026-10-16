extends CanvasLayer

@onready var panel: PanelContainer = $PanelContainer
@onready var name_label: Label = $PanelContainer/VBoxContainer/NameLabel
@onready var dialogue_label: Label = $PanelContainer/VBoxContainer/DialogueLabel
@onready var continue_button: Button = $PanelContainer/VBoxContainer/ContinueButton

var current_dialogues: Array[String] = []
var dialogue_index: int = 0

var is_open: bool:
	get:
		if not is_instance_valid(panel):
			return false
		return panel.visible


func _ready() -> void:
	panel.hide()

	if not continue_button.pressed.is_connected(next_dialogue):
		continue_button.pressed.connect(next_dialogue)


func _unhandled_input(event: InputEvent) -> void:
	if panel.visible and event.is_action_pressed("interact"):
		next_dialogue()
		get_viewport().set_input_as_handled()


func show_dialogue(character_name: String, dialogues: Array) -> void:
	if dialogues.is_empty():
		return

	current_dialogues.clear()

	for dialogue in dialogues:
		current_dialogues.append(str(dialogue))

	dialogue_index = 0

	name_label.text = character_name
	dialogue_label.text = current_dialogues[0]

	panel.show()

	print("DIALOGO ABIERTO")


func next_dialogue() -> void:
	if not panel.visible:
		return

	dialogue_index += 1

	if dialogue_index >= current_dialogues.size():
		close_dialogue()
		return

	dialogue_label.text = current_dialogues[dialogue_index]


func close_dialogue() -> void:
	panel.hide()
	dialogue_index = 0
	current_dialogues.clear()

	print("DIALOGO CERRADO")
