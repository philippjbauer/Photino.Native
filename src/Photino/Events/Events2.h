#pragma once
#include <functional>
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>

#include "Action.h"
#include "IEvent.h"
#include "IEventAction.h"

namespace Photino
{
    template<typename Sender, typename ...Args>
    struct Event : IEvent, Action<Sender, Args...>
    {
    };

    template<typename Sender, typename ...Args>
    struct EventAction : IEventAction
    {
    };

    template<typename Sender> 
    struct Events
    {
        Events(Sender *sender) : _sender(sender) { }

        template<typename ...Args>
        void EmitEvent(const Event<Args...> &event, const Args &...args)
        {
            auto actions = _eventActions.find(&event);
            
            if (actions != _eventActions.end())
            {
                auto *eventAction = static_cast<EventAction<Sender *, Args...> *>(actions->second.get());
                eventAction->emit(_sender, args...);
            }
        }

        template<typename Func, typename ...Args>
        // Question: What is "nodiscard" for and why the braces?
        [[nodiscard]] typename Action<Sender, Args...>::Slot AddEventAction(
            const Event<Sender, Args...> &event,
            Func &&action)
        {
            auto actions = _eventActions.find(&event);
            
            if (actions == _eventActions.end())
            {
                auto [newActions, success] = _eventActions
                    .emplace(&event, std::make_unique<EventAction<Sender *, Args...>>());
                actions = newActions;
            }

            auto *eventAction = static_cast(EventAction<Sender *, Args...> *>(actions->second.get()));
            return eventAction->connectWithSlot(std::forward<Func>(action));
        }

        private:
            Sender *_sender;
            // Question How does std::unique_ptr know to be an array?
            std::unordered_map<const IEvent*, std::unique_ptr<IEventAction>> _eventActions;
    };
}
