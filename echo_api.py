from flask import Flask, request
import os

app = Flask(__name__)

@app.route('/', methods=['POST'])
def echo():
    message = request.get_data().decode('utf-8')

    # Write the message to a file
    filename = f"/var/lib/echo_api/{message}"
    with open(filename, 'w') as file:
        file.write(message)

    return message

if __name__ == '__main__':
    # Ensure the directory exists
    os.makedirs('/var/lib/echo_api/', exist_ok=True)

    app.run(host='0.0.0.0', port=5000)

