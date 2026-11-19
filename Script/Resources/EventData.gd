class_name EventData
extends Resource

enum EventType { YES_NO, ITEM_CHOICE }
enum SessionType { PAGI, MALAM, KEDUANYA }

@export var event_id: String = ""
@export var event_type: EventType = EventType.YES_NO
@export var allowed_session: SessionType = SessionType.KEDUANYA

@export_group("Jadwal Kemunculan Hari")
@export_range(1, 7) var min_day: int = 1
@export_range(1, 7) var max_day: int = 7

@export_multiline var story_text: String = ""
@export var required_companions: Array[String] = []

@export_group("Opsi Ya / Tidak")
@export var yes_choice: EventChoice
@export var no_choice: EventChoice

@export_group("Opsi Gunakan Item")
@export var item_choice_1: EventChoice
@export var item_choice_2: EventChoice
@export var ignore_choice: EventChoice
