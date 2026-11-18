extends Control

@onready var pause_panel = $Panel2
@onready var pause_button = $Button

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_panel.hide()
	pause_button.show()
	get_tree().paused = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			_on_resume_pressed()
		else:
			_on_button_pressed()

# Tombol Pause
func _on_button_pressed():
	pause_panel.show()
	pause_button.hide()
	get_tree().paused = true

# Tombol Resume
func _on_resume_pressed():
	get_tree().paused = false
	pause_panel.hide()
	pause_button.show()

# Tombol Restart
func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
	
# Tombol Quit
func _on_quit_pressed():
	get_tree().paused = false
	get_tree().quit()
