from flask import Flask, request, render_template, make_response

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/insecure_route')
def insecure_route():
    # Vulnerabilidad de Inyección de Comandos (Command Injection)
    user_input = request.args.get('command')
    if user_input:
        import os
        # PELIGRO: Este código es vulnerable. No sanitiza la entrada.
        output = os.popen(user_input).read()
        return f"<pre>{output}</pre>"
    return "No command provided."

@app.route('/login', methods=['POST'])
def login():
    # Vulnerabilidad de Inyección SQL (SQL Injection) simulada
    username = request.form.get('username')
    password = request.form.get('password')
    # PELIGRO: Esta es una simulación de una vulnerabilidad.
    # En un entorno real, se construiría una consulta SQL insegura.
    if username == "admin" and password == "password":
        response = make_response("Login successful!")
        response.set_cookie('session_id', '12345', httponly=False) # Vulnerabilidad de cookies
        return response
    return "Login failed."

if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=5000)