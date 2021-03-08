#pragma once
#include <functional>
#include <map>
#include <vector>

namespace Photino
{
    // EventAction
    using EventAction = void (*)();

    //EventActions
    using EventActions = std::vector<EventAction>;

    // EventTypeActions
    template<class TEventTypeEnum>
    using EventTypeActions = std::pair<TEventTypeEnum, EventActions*>;

    // EventMap
    template<class TEventTypeEnum>
    using EventMap = std::map<TEventTypeEnum, EventActions*>;

    template<class TEventTypeEnum>
    class Events
    {
        private:
            EventMap<TEventTypeEnum> *_eventMap;

        public:
            Events() 
            {
                _eventMap = new EventMap<TEventTypeEnum>();
            }

            ~Events()
            {
                delete _eventMap;
            }

            Events<TEventTypeEnum> *AddEventAction(TEventTypeEnum eventType, EventAction eventAction)
            {
                EventActions *eventActions = this->GetEventActionsForEventType(eventType);
                eventActions->push_back(eventAction);

                return this;
            }

            EventActions *GetEventActionsForEventType(TEventTypeEnum eventType)
            {
                EventMap<TEventTypeEnum> *eventMap = this->GetEventMap();
                auto eventTypeActions = eventMap->find(eventType);
                EventActions *eventActions;

                if (eventTypeActions == eventMap->end())
                {
                    eventActions = new EventActions();
                    eventMap->insert(EventTypeActions<TEventTypeEnum>(eventType, eventActions));
                }
                else
                {
                    eventActions = eventTypeActions->second;
                }

                return eventActions;
            }

            EventMap<TEventTypeEnum> *GetEventMap()
            {
                return _eventMap;
            }

            Events<TEventTypeEnum> *EmitEvent(TEventTypeEnum eventType)
            {
                EventActions *eventActions = this->GetEventActionsForEventType(eventType);
                
                if (eventActions->size() == 0)
                {
                    std::cout << "No actions registered for event\n";
                }

                for (EventAction eventAction : *eventActions)
                {
                    try
                    {
                        std::cout << "Emitting event\n";
                        eventAction();
                        std::cout << "Emitted event\n";
                    }
                    catch(const std::exception& e)
                    {
                        std::cerr << e.what() << '\n';
                    }
                }

                return this;
            }

            // template<typename P>
            // Events<TEventTypeEnum> *EmitEvent<P>(TEventTypeEnum eventType, P arg1);

            // template <typename P, typename H>
            // Events<TEventTypeEnum> *EmitEvent<P, H>(TEventTypeEnum eventType, P arg1, H arg2);

            // template<typename P, typename H, typename O>
            // Events<TEventTypeEnum> *EmitEvent<P, H, O>(TEventTypeEnum eventType, P arg1, H arg2, O arg3);

            // template<typename P, typename H, typename O, typename T>
            // Events<TEventTypeEnum> *EmitEvent<P, H, O, T>(TEventTypeEnum eventType, P arg1, H arg2, O arg3, T arg4);

            // template<typename P, typename H, typename O, typename T, typename I>
            // Events<TEventTypeEnum> *EmitEvent<P, H, O, T, I>(TEventTypeEnum eventType, P arg1, H arg2, O arg3, T arg4, I arg5);

            // template<typename P, typename H, typename O, typename T, typename I, typename N>
            // Events<TEventTypeEnum> *EmitEvent<P, H, O, T, I, N>(TEventTypeEnum eventType, P arg1, H arg2, O arg3, T arg4, I arg5, N arg6);

            // // Can't use O twice, so C ... looks close enough
            // template<typename P, typename H, typename O, typename T, typename I, typename N, typename C>
            // Events<TEventTypeEnum> *EmitEvent<P, H, O, T, I, N, C>(TEventTypeEnum eventType, P arg1, H arg2, O arg3, T arg4, I arg5, N arg6, C arg7);
    };

    // template<class TEventTypeEnum, typename P>
    // Events<TEventTypeEnum> *Events<TEventTypeEnum>::EmitEvent(TEventTypeEnum eventType, P arg1)
    // {
    //     return this;
    // }

    // template <class TEventTypeEnum, typename P, typename H>
    // Events<TEventTypeEnum> *Events<TEventTypeEnum>::EmitEvent<P, H>(TEventTypeEnum eventType, P arg1, H arg2)
    // {
    //     return this;
    // }

    // template<class TEventTypeEnum, typename P, typename H, typename O>
    // Events<TEventTypeEnum> *Events<TEventTypeEnum>::EmitEvent<P, H, O>(TEventTypeEnum eventType, P arg1, H arg2, O arg3)
    // {
    //     return this;
    // }

    // template<class TEventTypeEnum, typename P, typename H, typename O, typename T>
    // Events<TEventTypeEnum> *Events<TEventTypeEnum>::EmitEvent<P, H, O, T>(TEventTypeEnum eventType, P arg1, H arg2, O arg3, T arg4)
    // {
    //     return this;
    // }

    // template<class TEventTypeEnum, typename P, typename H, typename O, typename T, typename I>
    // Events<TEventTypeEnum> *Events<TEventTypeEnum>::EmitEvent<P, H, O, T, I>(TEventTypeEnum eventType, P arg1, H arg2, O arg3, T arg4, I arg5)
    // {
    //     return this;
    // }

    // template<class TEventTypeEnum, typename P, typename H, typename O, typename T, typename I, typename N>
    // Events<TEventTypeEnum> *Events<TEventTypeEnum>::EmitEvent<P, H, O, T, I, N>(TEventTypeEnum eventType, P arg1, H arg2, O arg3, T arg4, I arg5, N arg6)
    // {
    //     return this;
    // }

    // template<class TEventTypeEnum, typename P, typename H, typename O, typename T, typename I, typename N, typename C>
    // Events<TEventTypeEnum> *Events<TEventTypeEnum>::EmitEvent<P, H, O, T, I, N, C>(TEventTypeEnum eventType, P arg1, H arg2, O arg3, T arg4, I arg5, N arg6, C arg7)
    // {
    //     return this;
    // }
}
