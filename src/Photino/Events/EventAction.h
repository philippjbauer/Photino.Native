#pragma once
#include <functional>
#include <iostream>

namespace Photino
{
    template <class TEventClass>
    using EventActionNoArgs = std::function<void(TEventClass *sender)>;

    template <class TEventClass, typename P>
    using EventActionOneArgs = std::function<void(TEventClass *sender, P args1)>;

    template <class TEventClass>
    class EventAction
    {
        private:
            TEventActionType _handler;
        
        public:
            EventAction() { }

            template<typename TEventActionType>
            this *Add(TEventActionType handler)
            {
                std::cout << "EventAction: " << &handler << "\n";
                _handler = handler;
            }

            void Invoke(TEventClass *sender)
            {
                std::cout << "Invoke: " << &_handler << "\n";
                _handler(sender);
            }

            template<typename P>
            void Invoke(TEventClass *sender, P args1)
            {
                std::cout << "Invoke: " << &_handler << "\n";
                _handler(sender, args1);
            }
    };
}
