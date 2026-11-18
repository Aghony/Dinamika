class_name EventData
extends Resource

enum EventType { YES_NO, ITEM_CHOICE }
enum SessionType { PAGI, MALAM, KEDUANYA }

@export var event_id: String = ""
@export var event_type: EventType = EventType.YES_NO
@export var allowed_session: SessionType = SessionType.KEDUANYA
@export var required_companions: Array[String] = []
@export_multiline var story_text: String = ""

@export_group("Opsi Tipe YES_NO")
@export var yes_choice: EventChoice
@export var no_choice: EventChoice

@export_group("Opsi Tipe ITEM_CHOICE")
@export var item_choice_1: EventChoice
@export var item_choice_2: EventChoice   # Kosongkan jika hanya ada 1 opsi barang
@export var ignore_choice: EventChoice   # Dijalankan jika tombol panah ditekan tanpa memilih item
