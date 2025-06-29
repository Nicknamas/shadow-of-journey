extends CanvasLayer

signal on_transition_finished

@onready var color_rect : ColorRect = $ColorRect
@onready var animation_player : AnimationPlayer = $AnimationPlayers


func _ready() -> void:
	self.color_rect.visible = false
	self.animation_player.animation_finished.connect(self._on_animation_finished)


func _on_animation_finished(animation_name : String) -> void:
	if animation_name == "fade_to_black":
		on_transition_finished.emit()
		self.animation_player.play("fade_to_normal")
	elif animation_name == "fade_to_normal":
		self.color_rect.visible = false


func transition():
	self.color_rect.visible = true
	self.animation_player.play("fade_to_black")
