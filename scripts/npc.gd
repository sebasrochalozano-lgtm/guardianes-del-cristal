extends Node2D

@onready var interactive_area: Area2D = $InteractiveArea

var player_nearby: bool = false


func _ready() -> void:
	if not interactive_area.body_entered.is_connected(_on_interactive_area_body_entered):
		interactive_area.body_entered.connect(_on_interactive_area_body_entered)

	if not interactive_area.body_exited.is_connected(_on_interactive_area_body_exited):
		interactive_area.body_exited.connect(_on_interactive_area_body_exited)


func _process(_delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interact"):
		interact()


func interact() -> void:
	var dialogue_ui = get_tree().current_scene.get_node("DialogueUI")

	if dialogue_ui.is_open:
		return

	match QuestManager.quest_state:

		QuestManager.QuestState.NOT_STARTED:
			dialogue_ui.show_dialogue(
				"Han Solo",
				[
					"Guardian, necesito tu ayuda!",
					"Los enemigos han dispersado los cristales magicos alrededor de la ciudad.",
					"Recuperalos rapido y traemelos antes de que se pierdan."
				]
			)
			QuestManager.start_quest()

		QuestManager.QuestState.ACTIVE:
			dialogue_ui.show_dialogue(
				"Han Solo",
				[
					"Todavia faltan cristales.",
					"Solo encontraste %d de %d" % [
						QuestManager.collected_crystals,
						QuestManager.required_crystals
					]
				]
			)

		QuestManager.QuestState.READY_TO_DELIVER:
			dialogue_ui.show_dialogue(
				"Han Solo",
				[
					"Perfecto, muchas gracias por ayudarme.",
					"Recuperaste todos los cristales a tiempo.",
					"Ahora activaremos el portal a tiempo."
				]
			)
			QuestManager.complete_quest()

		QuestManager.QuestState.COMPLETED:
			dialogue_ui.show_dialogue(
				"Han Solo",
				[
					"Muchas gracias por tu ayuda.",
					"Ahora el portal esta listo para ser utilizado."
				]
			)


func _on_interactive_area_body_entered(body: Node2D) -> void:
	if body.name == "player":
		player_nearby = true


func _on_interactive_area_body_exited(body: Node2D) -> void:
	if body.name == "player":
		player_nearby = false
