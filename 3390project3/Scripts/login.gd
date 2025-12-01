extends Control

#@onready var status_label = $StatusLabel
#@onready var password_field = $passwordField
#@onready var username_field = $usernameField
#@onready var http_request = $HTTPRequest

var API_BASE:="http://localhost:3000/api/auth"
var auth_token:= ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	http_request.request_completed.connect(_on_request_completed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_LoginButton_pressed() -> void:
	var payload := {
		"username": username_field.text,
		"password": password_field.text
		}
		
	status_label.text = "DURRRRRRRR"
	var headers := ["Content-Type: application/json"]
	var url := API_BASE + "/login"
	
	var err := http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(payload))
	if err != OK:
		status_label.text = "Request errawr: %d" % err
	

func _on_create_account_pressed() -> void:
	#SceneManager.load_ui("res://Scenes/UI/MainMenu.tscn")
	var payload := {
		"username": username_field.text,
		"password": password_field.text
	}
	
	status_label.text = "Creating da account, please wait......."
	
	var headers := ["Content-Type: application/json"]
	var url := API_BASE + "/register"
	
	var err := http_request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(payload))
	if err != OK:
		status_label.text = "Request errawr: %d" % err
		
	func _on_request_completed(result:int, response_code:int, headers:PackedStringArray, body:PackedByteArray) -> void:
		var raw := body.get_string_from_utf8()
		var response := JSON.parse_string(raw)
	
	if typeof(response) != TYPE_DICTIONARY:
		status_label.text = "Invalid response: " + raw
		return
	

if response_code  >= 200 and response_code < 300:
	if response.has("token"):
			auth_token = response["token"]
			var user = response.get("user", {})
			var username := user.get("username", "unknown")
			
			status_label.text = "Logged in as %s" % username
			
			#session storage will get moved to main menu maybe 

func _on_sign_in_pressed() -> void:
	SceneManager.load_ui("res://Scenes/UI/MainMenu.tscn")

# func login PAOLAPAOLAPAOLA
#func _on_LoginButton_pressed():
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
#func _on_request_completed(result, response_code, headers, body):
	#var data = JSON.parse_string(body.get_string_from_utf8())

	if response_code == 200:
		status_label.text = "successful login, %s" % data["username"]
		# TODO: store token or switch scene
	else:
		status_label.text = "Error %d: %s" % [response_code, str(data)]
