@tool
class_name Fade
extends ColorRect

signal faded_in
signal faded_out

@export var fade_in_duration: float = 1.0
@export var fade_in_transaction_type: Tween.TransitionType
@export var fade_in_ease_type: Tween.EaseType
@export var fade_in_on_start: bool = true
@export var fade_out_duration: float = 1.0
@export var fade_out_transaction_type: Tween.TransitionType
@export var fade_out_ease_type: Tween.EaseType
var progress: float = 0.0 :
	set(value):
		progress = value
		_update_progress(value)
var tween: Tween

func _ready() -> void:
	visible = false
	if not Engine.is_editor_hint():
		if fade_in_on_start:
			fade_in()
	else:
		layout_mode = 1
		#mouse_filter = Control.MOUSE_FILTER_IGNORE
		color = Color(0, 0, 0)
		add_to_group("fade", true)
		set_anchors_preset(PRESET_FULL_RECT, true)


func fade_in():
	if tween:
		tween.kill()
	else:
		progress = 1.0
	visible = true
	tween = get_tree().create_tween()
	tween.set_trans(fade_in_transaction_type)
	tween.set_ease(fade_in_ease_type)
	tween.tween_property(self, "progress", 0.0, fade_in_duration)
	await tween.finished
	faded_in.emit()
	visible = false


func fade_out():
	if tween:
		tween.kill()
	else:
		progress = 0.0
	visible = true
	tween = get_tree().create_tween()
	tween.set_trans(fade_out_transaction_type)
	tween.set_ease(fade_out_ease_type)
	tween.tween_property(self, "progress", 1.0, fade_in_duration)
	await tween.finished
	faded_out.emit()


func _update_progress(value: float) -> void:
	modulate.a = progress
