from erlport.erlterms import Atom
from erlport.erlproto import Protocol, Port

class ChatProtocol(Protocol):
    def __init__(self):
        self.port = Port(use_stdio=True)

    def handle_info(self, message):
        print("Received message:", message)

    def create_user(self, username):
        self.port.write((Atom('create_user'), username))

    def create_group(self, groupname):
        self.port.write((Atom('create_group'), groupname))

    def join_group(self, username, groupname):
        self.port.write((Atom('join_group'), username, groupname))

    def send_message(self, username, groupname, message):
        self.port.write((Atom('send_message'), username, groupname, message))

    def get_messages(self, groupname):
        self.port.write((Atom('get_messages'), groupname))
        # En una implementación real, aquí deberías manejar la recepción de mensajes
        return "Messages retrieved"

def main():
    protocol = ChatProtocol()
    protocol.run()

if __name__ == "__main__":
    main()
