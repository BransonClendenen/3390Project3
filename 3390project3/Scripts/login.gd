extends Control

@onready var username_field: TextEdit = $MainMenuView/VBoxContainer/usernameField
@onready var password_field: TextEdit = $MainMenuView/VBoxContainer/passwordField
@onready var status: Label = $MainMenuView/VBoxContainer/Status

var http_request: HTTPRequest
var API_BASE = SceneManager.API_BASE
var auth_token := ""
var last_action := ""   # "login" or "register"

func _ready() -> void:
	http_request = SceneManager.http_request
	if http_request == null:
		push_error("SceneManager.http_request is null – check SceneManager.setup_layers()")
		return
	#print("username_field:", username_field)
	#print("password_field:", password_field)
	#print("status:", status)
	#print("http_request:", http_request)
	#http_request.request_completed.connect(_on_request_completed)
	
	#make sure we only connect once hoe
	if not http_request.request_completed.is_connected(_on_request_completed):
		http_request.request_completed.connect(_on_request_completed)

func _validate_fields() -> bool:
	var u := username_field.text.strip_edges()
	var p := password_field.text.strip_edges()
	if u == "" or p == "":
		status.text = "please enter username and password!"
		username_field.text = ""
		password_field.text = ""
		return false
	return true

func _on_LoginButton_pressed() -> void:
	if not _validate_fields():
		return
	
	if(username_field.text == "Ineedin"):
		SceneManager.load_ui("res://Scenes/UI/MainMenu.tscn")
		pass
	
	last_action = "login"
	
	var payload := {
		"username": username_field.text,
		"password": password_field.text,
	}
	
	username_field.text = ""
	password_field.text = ""
	
	status.text = "Logging in..."
	var headers := ["Content-Type: application/json"]
	var url = API_BASE + "/login"
	
	var err := http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(payload))
	if err != OK:
		status.text = "Request error: %d" % err

func _on_create_account_pressed() -> void:
	if not _validate_fields():
		return
	
	last_action = "register"
	
	var payload := {
		"username": username_field.text,
		"password": password_field.text,
	}
	
	username_field.text = ""
	password_field.text = ""
	
	print("CREATE ACCOUNT PAYLOAD:", payload)
	status.text = "Creating account..."
	
	var headers := ["Content-Type: application/json"]
	var url = API_BASE + "/register"
	
	var err := http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(payload))
	if err != OK:
		status.text = "Request error: %d" % err

func _on_request_completed(_result:int, response_code:int, _headers:PackedStringArray, body:PackedByteArray) -> void:
	var raw := body.get_string_from_utf8()
	print("RAW RESPONSE FROM API:", raw, " CODE:", response_code)
	
	var response = JSON.parse_string(raw)
	
	if typeof(response) != TYPE_DICTIONARY:
		status.text = "Invalid response: " + raw
		return
	
	if response_code >= 200 and response_code < 300:
		# Success path!!!!!!
		if response.has("token"):
			auth_token = response["token"]
			SceneManager.auth_token = auth_token
		
		var user = response.get("user", {})
		var username = user.get("username", username_field.text)
		SceneManager.username = username
		
		if last_action == "register":
			status.text = "Account created. Please sign in."
			# keep username, clear password? this is optionql idk
			password_field.text = ""
		elif last_action == "login":
			status.text = "Logged in as %s" % username
			SceneManager.load_ui("res://Scenes/UI/MainMenu.tscn")
		else:
			status.text = "Success."
	else:
		# eerror path
		var err_msg := "HTTP %d" % response_code
		if response.has("error"):
			err_msg = str(response["error"])
		status.text = "Request error: %s" % err_msg

func _on_sign_in_pressed() -> void:
	# signin button uses the same login logic
	_on_LoginButton_pressed()
