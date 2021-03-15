// Shorthand for the messaging system
const PhotinoEvents = PhotinoApp.events;
const PhotinoMessages = PhotinoApp.messages;

const SubmitForm = document.querySelector('form');
const WindowLocationOutput = document.querySelector('#window-location');
const WindowSizeOutput = document.querySelector('#window-size');

SubmitForm
    .addEventListener('submit', (event) =>
    {
        event.preventDefault();

        const name = document.querySelector('#name').value.trim();

        if (name === "") {
            alert('Please enter your name!');
            return;
        }

        PhotinoMessages.send(name);
    });

PhotinoMessages
    .receive(message => alert(message));

PhotinoEvents
    .addEventHandler('window-did-move', data => {
        const location = JSON.parse(data);
        WindowLocationOutput.querySelector('td:nth-of-type(1)').innerHTML = `${location.left}px`;
        WindowLocationOutput.querySelector('td:nth-of-type(2)').innerHTML = `${location.top}px`;
    })
    .addEventHandler('window-did-resize', data => {
        const size = JSON.parse(data);
        WindowSizeOutput.querySelector('td:nth-of-type(1)').innerHTML = `${size.width}px`;
        WindowSizeOutput.querySelector('td:nth-of-type(2)').innerHTML = `${size.height}px`;
    });