extends Node2D

@onready var crystal_label: Label = $UI/HUD/CrystalLabel


func _ready() -> void:
	if not QuestManager.quest_updated.is_connected(update_crystal_label):
		QuestManager.quest_updated.connect(update_crystal_label)

	update_crystal_label()


func update_crystal_label() -> void:
	crystal_label.text = "Cristales: %d / %d" % [
		QuestManager.collected_crystals,
		QuestManager.required_crystals
	]
