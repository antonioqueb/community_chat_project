from flask import Flask, render_template, request, jsonify
from chat_client import ChatProtocol

app = Flask(__name__)
chat_client = ChatProtocol()

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/create_user', methods=['POST'])
def create_user():
    user = request.form['username']
    chat_client.create_user(user)
    return jsonify(success=True)

@app.route('/create_group', methods=['POST'])
def create_group():
    group = request.form['groupname']
    chat_client.create_group(group)
    return jsonify(success=True)

@app.route('/join_group', methods=['POST'])
def join_group():
    user = request.form['username']
    group = request.form['groupname']
    chat_client.join_group(user, group)
    return jsonify(success=True)

@app.route('/send_message', methods=['POST'])
def send_message():
    user = request.form['username']
    group = request.form['groupname']
    message = request.form['message']
    chat_client.send_message(user, group, message)
    return jsonify(success=True)

@app.route('/get_messages', methods=['GET'])
def get_messages():
    group = request.args.get('groupname')
    messages = chat_client.get_messages(group)
    return jsonify(messages=messages)

if __name__ == '__main__':
    app.run(debug=True)
