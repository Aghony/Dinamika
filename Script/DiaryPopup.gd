extends Control

@onready var diary_text: RichTextLabel = $DimmerBackground/BookPanel/DiaryRichText
@onready var close_btn: Button = $DimmerBackground/BookPanel/CloseButton


func _ready() -> void:
	hide()
	diary_text.bbcode_enabled = true
	diary_text.scroll_active = true
	close_btn.pressed.connect(hide)


func open_popup() -> void:
	_build_diary_content()
	show()


func _build_diary_content() -> void:
	if GameState.diary_logs.is_empty():
		diary_text.text = "Belum ada catatan yang tertulis."
		return
		
	var combined_text := ""
	for entry in GameState.diary_logs:
		combined_text += "[b]Ronde %d - %s[/b]\n%s\n\n" % [
			entry["round"],
			entry["session"],
			entry["text"]
		]
		
	diary_text.text = combined_text
