extends Control

@onready var status_label: TextEdit = $MainMenuView/VBoxContainer/Status/statusLabel
@onready var http_request: HTTPRequest = $HTTPRequest
@onready var username_field: TextEdit = $MainMenuView/VBoxContainer/usernameField
@onready var password_field: TextEdit = $MainMenuView/VBoxContainer/passwordField



var API_BASE:= SceneManager.API_BASE
#var auth_token:= SceneManager.auth_token
#var last_action := SceneManager.last_action
var auth_token:= ""
var last_action := ""

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
		
	status_label.text = "you shouldnt be logging in with a loser like me, or should you"
	var headers := ["Content-Type: application/json"]
	var url := API_BASE + "/login"
	
	var err := http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(payload))
	if err != OK:
		status_label.text = "Request error: %d" % err



func _on_create_account_pressed() -> void:
	last_action = "register" 
	SceneManager.last_action = last_action
	#SceneManager.load_ui("res://Scenes/UI/MainMenu.tscn")
	
	var payload := {
		"username": username_field.text,
		"password": password_field.text
	}
	status_label.text = "Creating account!"
	
	var headers := ["Content-Type: application/json"]
	var url := API_BASE + "/register"
	
	var err := http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(payload))
	if err != OK:
		status_label.text = "Request error: %d" % err
		
func _on_request_completed(_result:int, response_code:int, _headers:PackedStringArray, body:PackedByteArray) -> void:
	var raw := body.get_string_from_utf8()
	var response = JSON.parse_string(raw)
	
	if typeof(response) != TYPE_DICTIONARY:
		status_label.text = "Invalid response: " + raw
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
				status_label.text = "Logged in as %s" % username
			elif last_action == "register":
				status_label.text = "Account made for %s" % username
			else:
				status_label.text = "Success for %s" % username
				
			# here is where you could auto-swap to main menu ask branso first:
			#SceneManager.load_ui("res://Scenes/UI/MainMenu.tscn")

		else:
			status_label.text = "Success, but no token in response :(" # sus
	else:
		var err_msg := "HTTP %d" % response_code
		if response.has("error"):
			err_msg = str(response["error"])
		status_label.text = "Request error: %s" % err_msg

func _on_sign_in_pressed() -> void:
	SceneManager.load_ui("res://Scenes/UI/MainMenu.tscn")

#func _on_LoginButton_pressed():
	# collect username and password from fields
#	var username = username_field.text
#	var password = password_field.text

#	var payload = {
#		"username": username,
#		"password": password
#	}

#	var json = JSON.stringify(payload)

#	var url = "http://localhost:3000/login" # pls remember to change to api endpoint later
#	var headers = ["Content-Type: application/json"]

#	var http_request = HTTPRequest.new()
#	add_child(http_request)
#	http_request.request_completed.connect(_on_request_completed)
#	http_request.request(url, headers, HTTPClient.METHOD_POST, json)

# clear field when entering anything atp lolol
# handling api response below; this is supposed to send JSON payload to da API and shows results inside the label
#func _on_request_completed(result, response_code, headers, body):
	#var data = JSON.parse_string(body.get_string_from_utf8())

	#if response_code == 200:
		#status_label.text = "successful login, %s" % data["username"]
		## TODO: store token or switch scene
	#else:
		#status_label.text = "Error %d: %s" % [response_code, str(data)]
