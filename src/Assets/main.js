// Shorthand for the messaging system
const PhotinoMessages = PhotinoApp.messages;

document
    .querySelector('button[type="submit"]')
    .addEventListener('click', (target) =>
    {
        const name = document.querySelector('#name').value.trim();

        if (name === "") {
            alert('Please enter your name!');
            return;
        }

        PhotinoMessages.send(name);
    });

PhotinoMessages
    .receive(message => alert(message));