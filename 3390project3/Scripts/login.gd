extends Node2D

@onready var status_label = $StatusLabel

@onready var password_field = $passwordField
@onready var username_field = $usernameField

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _on_create_account_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu.tscn")

func _on_sign_in_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

# func login PAOLAPAOLAPAOLA
func _on_LoginButton_pressed():
	# collect username and password from fields
	var username = username_field.text
	var password = password_field.text

	var payload = {
		"username": username,
		"password": password
	}

	var json = JSON.stringify(payload)

	var url = "http://localhost:3000/login" # pls remember to change to api endpoint later
	var headers = ["Content-Type: application/json"]

	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	http_request.request(url, headers, HTTPClient.METHOD_POST, json)

# clear field when entering anything atp lolol
# handling api response below; this is supposed to send JSON payload to da API and shows results inside the label
func _on_request_completed(result, response_code, headers, body):
	var data = JSON.parse_string(body.get_string_from_utf8())

	if response_code == 200:
		status_label.text = "successful login, %s" % data["username"]
		# TODO: store token or switch scene
	else:
		status_label.text = "Error %d: %s" % [response_code, str(data)]
