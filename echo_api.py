from flask import Flask, request
import os

app = Flask(__name__)

@app.route('/echo/<message>', methods=['GET'])
def echo(message):
    # create the directoyr i fit doesn't exist
    directory = '/var/lib/echo_api/'
    os.makedirs(directory, exist_ok=True)
     # Save the message to a file
    file_path = os.path.join(directory, message)
    with open(file_path, 'w') as file:
        file.write(message)

         # Return the echoed message
    return message

if __name__ == '__main__':
    app.run(host='localhost', port=8080)
                                    
