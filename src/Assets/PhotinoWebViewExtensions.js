const PhotinoApp = {
    events: {
        handlers: {},
        addEventHandler: function (type, handler) {
            if (typeof type === 'string'
                && typeof handler === 'function'
            ) {
                if (Object.keys(PhotinoApp.events.handlers).indexOf(type) === -1) {
                    PhotinoApp.events.handlers[type] = [];
                }

                PhotinoApp.events.handlers[type].push(handler);
            }

            return PhotinoApp.events;
        },
        emitEvent: function (type, message) {
            if (typeof type === 'string'
                && typeof message === 'string'
            ) {
                const handlers = PhotinoApp.events.handlers[type];

                if (!handlers || handlers.length === 0) {
                    return true;
                }

                for (let i = 0; i < handlers.length; i++) {
                    handlers[i](message);
                }

                return true;
            }

            return false;
        }
    },
    messages: {
        send: function(message) {
            if (typeof message === 'string') {
                window.webkit
                    .messageHandlers
                    .photinoIPC
                    .postMessage(message);
            }
        },
        receive: function(handler) {
            PhotinoApp.events.addEventHandler('message-received', handler);
            return PhotinoApp.messages;
        }
    }
};