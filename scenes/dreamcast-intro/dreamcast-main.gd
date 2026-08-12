extends Node3D
@onready var clicked = false
@onready var _hover_areas: Dictionary = {
	&"code": $Main/VSCODE_AREA,
	&"music": $Main/FL_AREA,
	&"gamedev": $Main/GAMECUBE_AREA,
	&"art": $Main/BLENDER_AREA
}
@onready var hover: AudioStreamPlayer = $hover
@onready var plate: CSGTorus3D = $StaticBody3D/CSGTorus3D
@onready var select_fx: AudioStreamPlayer = $select

@onready var _plate_locations: Dictionary = {
	&"code": Vector3(-2.23,1.739,-0.31) ,
	&"music": Vector3(-2.23,1.739,1.825),
	&"gamedev": Vector3(-2.23,0.233,-0.02),
	&"art": Vector3(-2.23,0.374,1.773)
}

@onready var _anims: Dictionary = {
	&"code": $Anims/vscode,
	&"music": $Anims/fruityloops,
	&"gamedev": $Anims/gamecube,
	&"art": $Anims/blender
}

func _ready() ->void:
	plate.visible = false
	for logo_id in _hover_areas.keys():
		_anims[logo_id].play("idle")
		var area: Area3D = _hover_areas[logo_id]
		area.mouse_entered.connect(_on_hover.bind(logo_id))
		area.mouse_exited.connect(_on_unhover.bind(logo_id))
		area.input_event.connect(_on_select.bind(logo_id))
		
@onready var ambience: AudioStreamPlayer = $ambience

func _on_hover(logo_id: StringName):
	if clicked:
		return
	plate.visible = true
	plate.global_position = _plate_locations[logo_id]
	_anims[logo_id].play("hover")
	hover.playing = true
	
func _on_unhover(logo_id: StringName):
	if clicked:
		return
	plate.visible = false
	_anims[logo_id].play("idle")
@onready var disappear_overlay: AnimationPlayer = $CanvasLayer/AnimationPlayer

func _on_select(camera: Camera3D, event: InputEvent, position: Vector3, normal: Vector3,shape_idx: int,logo_id: StringName) -> void:
	if clicked:
		return
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		_anims[logo_id].play("select")
		ambience.stop()
		hover.stop()
		select_fx.play()
		disappear_overlay.play("idle")
		clicked = true
