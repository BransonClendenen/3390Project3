extends Control

@onready var username_field: TextEdit = $MainMenuView/VBoxContainer/usernameField
@onready var password_field: TextEdit = $MainMenuView/VBoxContainer/passwordField
@onready var status: Label = $MainMenuView/VBoxContainer/Status

var http_request = SceneManager.http_request
var API_BASE = SceneManager.API_BASE
#var auth_token:= SceneManager.auth_token
#var last_action := SceneManager.last_action
var auth_token = ""
var last_action = ""

func _ready() -> void:
	#print("username_field:", username_field)
	#print("password_field:", password_field)
	#print("status_label:", status_label)
	#print("http_request:", http_request)
	#http_request.request_completed.connect(_on_request_completed)
	
	http_request.request_completed.connect(_on_request_completed)
	if http_request == null:
		http_request = HTTPRequest.new()
		add_child(http_request)
	
	http_request.request_completed.connect(_on_request_completed)

func _on_LoginButton_pressed() -> void:
	last_action = "login"
	SceneManager.last_action = last_action
	
	var payload := {
		"username": username_field.text,
		"password": password_field.text
	}
	
	status.text = "logging in"
	var headers = ["Content-Type: application/json"]
	var url = API_BASE + "/login"
	
	var err = http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(payload))
	if err != OK:
		status.text = "Request error: %d" % err

func _on_create_account_pressed() -> void:
	_on_Create_Account()
	username_field.text = ""
	password_field.text = ""
	status.text = "account created, please log in"

func _on_Create_Account() -> void:
	last_action = "register" 
	SceneManager.last_action = last_action
	#SceneManager.load_ui("res://Scenes/UI/MainMenu.tscn")
	
	var payload := {
		"username": username_field.text,
		"password": password_field.text
	}
	
	print("CREATE ACCOUNT PAYLOAD:", payload)
	status.text = "Creating account!"
	
	var headers = ["Content-Type: application/json"]
	var url = API_BASE + "/register"
	
	var err = http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(payload))
	if err != OK:
		status.text = "Request error: %d" % err

func _on_request_completed(_result:int, response_code:int, _headers:PackedStringArray, body:PackedByteArray) -> void:
	var raw = body.get_string_from_utf8()
	print("RAW RESPONSE FROM API:", raw, " CODE:", response_code) #debag
	
	var response = JSON.parse_string(raw)
	
	if typeof(response) != TYPE_DICTIONARY:
		status.text = "Invalid response: " + raw
		return
	
	if response_code >= 200 and response_code < 300:
		if response.has("token"):
			auth_token = response["token"]
			#var user = response.get("user", {})
			#var username = user.get("username", "unknown")
			SceneManager.auth_token = auth_token #push to global
			
			var user = response.get("user", {})
			var username = user.get("username", "unknown")
			#only do this if SceneManager has a username var defined, otherwise skip
			#SceneManager.username = username
			
			if last_action == "login":
				status.text = "Logged in as %s" % username
			elif last_action == "register":
				status.text = "Account made for %s" % username
				SceneManager.load_ui("res://Scenes/UI/MainMenu.tscn") #goes back to main menu automatically after creating the acc
			else:
				status.text = "Success for %s" % username
		
		else:
			status.text = "Success, but no token in response :(" # sus
	else:
		var err_msg = "HTTP %d" % response_code
		
		if response.has("error"):
			err_msg = str(response["error"])
		status.text = "Request error: %s" % err_msg

signal set_username(String)

func _on_sign_in_pressed() -> void:
	_on_LoginButton_pressed()
	emit_signal("set_username",username_field.text)
	SceneManager.load_ui("res://Scenes/UI/MainMenu.tscn")
