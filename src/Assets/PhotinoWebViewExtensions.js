window.__receiveMessageCallbacks = [];

window.__dispatchMessageCallback = function(message)
{
    window.__receiveMessageCallbacks
        .forEach(function(callback) 
        {
            callback(message);
        });
};

window.external = {
    postMessage: function(message)
    {
        window.webkit
            .messageHandlers
            .photinointerop
            .postMessage(message);
    },
    receiveMessage: function(callback)
    {
        window.__receiveMessageCallbacks.push(callback);
    }
};
