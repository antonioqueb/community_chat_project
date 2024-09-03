document.getElementById('createUserForm').addEventListener('submit', function(e) {
    e.preventDefault();
    var username = document.getElementById('username').value;
    fetch('/create_user', {
        method: 'POST',
        body: new URLSearchParams('username=' + username)
    }).then(response => response.json()).then(data => {
        console.log('User created:', data);
    });
});

document.getElementById('createGroupForm').addEventListener('submit', function(e) {
    e.preventDefault();
    var groupname = document.getElementById('groupname').value;
    fetch('/create_group', {
        method: 'POST',
        body: new URLSearchParams('groupname=' + groupname)
    }).then(response => response.json()).then(data => {
        console.log('Group created:', data);
    });
});

document.getElementById('joinGroupForm').addEventListener('submit', function(e) {
    e.preventDefault();
    var username = document.getElementById('usernameJoin').value;
    var groupname = document.getElementById('groupnameJoin').value;
    fetch('/join_group', {
        method: 'POST',
        body: new URLSearchParams('username=' + username + '&groupname=' + groupname)
    }).then(response => response.json()).then(data => {
        console.log('Joined group:', data);
    });
});

document.getElementById('sendMessageForm').addEventListener('submit', function(e) {
    e.preventDefault();
    var username = document.getElementById('usernameMsg').value;
    var groupname = document.getElementById('groupnameMsg').value;
    var message = document.getElementById('message').value;
    fetch('/send_message', {
        method: 'POST',
        body: new URLSearchParams('username=' + username + '&groupname=' + groupname + '&message=' + message)
    }).then(response => response.json()).then(data => {
        console.log('Message sent:', data);
    });
});

function loadMessages() {
    var groupname = document.getElementById('groupnameMsg').value;
    fetch('/get_messages?groupname=' + groupname)
    .then(response => response.json())
    .then(data => {
        var messagesDiv = document.getElementById('messages');
        messagesDiv.innerHTML = '';
        data.messages.forEach(msg => {
            messagesDiv.innerHTML += '<p><strong>' + msg.user + ':</strong> ' + msg.message + '</p>';
        });
    });
}

setInterval(loadMessages, 3000);
