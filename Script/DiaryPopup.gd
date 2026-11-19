extends Control

@onready var book_bg: TextureRect = $DimmerBackground/BookContainer
@onready var day_title_label: Label = $DimmerBackground/BookContainer/DayTitleLabel
@onready var page_num_label: Label = $DimmerBackground/BookContainer/PageNumberLabel
@onready var diary_text: RichTextLabel = $DimmerBackground/BookContainer/DiaryTextLabel
@onready var prev_btn: TextureButton = $DimmerBackground/BookContainer/PrevPageButton
@onready var next_btn: TextureButton = $DimmerBackground/BookContainer/NextPageButton
@onready var close_btn: Button = $DimmerBackground/BookContainer/CloseButton

const BUKU_DIR := "res://Assets/UI/Buku/"

# Menyimpan daftar halaman yang sudah dikelompokkan per hari: Array[Dictionary]
var pages: Array[Dictionary] = []
var current_page_index: int = 0


func _ready() -> void:
	hide()
	_load_book_assets()
	
	prev_btn.pressed.connect(_on_prev_pressed)
	next_btn.pressed.connect(_on_next_pressed)
	close_btn.pressed.connect(close_popup)
	diary_text.bbcode_enabled = true


func _load_book_assets() -> void:
	if book_bg.texture == null and ResourceLoader.exists(BUKU_DIR + "book_bg.png"):
		book_bg.texture = load(BUKU_DIR + "book_bg.png")
	if prev_btn.texture_normal == null and ResourceLoader.exists(BUKU_DIR + "book_prev.png"):
		prev_btn.texture_normal = load(BUKU_DIR + "book_prev.png")
	if next_btn.texture_normal == null and ResourceLoader.exists(BUKU_DIR + "book_next.png"):
		next_btn.texture_normal = load(BUKU_DIR + "book_next.png")


# Ubah fungsi open_popup() dan close_popup() di DiaryPopup.gd menjadi:
func open_popup() -> void:
	_build_pages_from_logs()
	current_page_index = maxi(0, pages.size() - 1)
	_render_current_page()
	AudioManager.play_paper_turn()
	show()


func close_popup() -> void:
	AudioManager.play_paper_turn()
	hide()


func _build_pages_from_logs() -> void:
	pages.clear()
	var grouped_by_round: Dictionary = {}
	
	for entry in GameState.diary_logs:
		var r: int = entry.get("round", 1)
		if not grouped_by_round.has(r):
			grouped_by_round[r] = []
		grouped_by_round[r].append(entry)
		
	var sorted_rounds: Array = grouped_by_round.keys()
	sorted_rounds.sort()
	
	for r in sorted_rounds:
		var entries: Array = grouped_by_round[r]
		var formatted_lines: Array[String] = []
		
		for item in entries:
			var session_str: String = item.get("session", "Pagi")
			var txt: String = item.get("text", "")
			formatted_lines.append("[b][%s][/b]\n%s" % [session_str, txt])
			
		pages.append({
			"round": r,
			"body": "\n\n".join(formatted_lines)
		})
		
	if pages.is_empty():
		pages.append({
			"round": 1,
			"body": "Belum ada catatan perjalanan hari ini."
		})


func _render_current_page() -> void:
	var page_data: Dictionary = pages[current_page_index]
	day_title_label.text = "Catatan Evakuasi — Hari ke-%d" % page_data["round"]
	diary_text.text = page_data["body"]
	page_num_label.text = "Halaman %d / %d" % [current_page_index + 1, pages.size()]
	
	# Atur status aktif & transparansi tombol navigasi halaman
	var has_prev: bool = current_page_index > 0
	var has_next: bool = current_page_index < (pages.size() - 1)
	
	prev_btn.disabled = not has_prev
	prev_btn.modulate.a = 1.0 if has_prev else 0.35
	
	next_btn.disabled = not has_next
	next_btn.modulate.a = 1.0 if has_next else 0.35


func _on_prev_pressed() -> void:
	if current_page_index > 0:
		current_page_index -= 1
		_render_current_page()


func _on_next_pressed() -> void:
	if current_page_index < pages.size() - 1:
		current_page_index += 1
		_render_current_page()
