const PhotinoApp = {
    messages: {
        handlers: [],
        send: function(message)
        {
            if (typeof message === 'string')
            {
                window.webkit
                    .messageHandlers
                    .photinointerop
                    .postMessage(message);
            }
        },
        receive: function(handler)
        {
            if (typeof handler === 'function')
            {
                PhotinoApp.messages.handlers.push(handler);
            }

            return PhotinoApp.messages;
        },
        dispatch: function(message)
        {
            const handlers = PhotinoApp.messages.handlers;
            for (let i = 0; i < handlers.length; i++)
            {
                handlers[i](message);
            }
        }
    }
};
