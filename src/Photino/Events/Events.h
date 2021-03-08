#pragma once
#include <functional>
#include <map>
#include <vector>
#include "../../PhotinoShared/Log.h"

using namespace PhotinoShared;

namespace Photino
{
    // EventAction
    template<class TEventClass>
    using EventAction = void (*)(TEventClass* sender);

    //EventActions
    template<class TEventClass>
    using EventActions = std::vector<EventAction<TEventClass> >;

    // EventTypeActions
    template<class TEventClass, typename TEventTypeEnum>
    using EventTypeActions = std::pair<TEventTypeEnum, EventActions<TEventClass>*>;

    // EventMap
    template<class TEventClass, typename TEventTypeEnum>
    using EventMap = std::map<TEventTypeEnum, EventActions<TEventClass>*>;

    template<class TEventClass, typename TEventTypeEnum>
    class Events
    {
        private:
            TEventClass *_eventClass;
            EventMap<TEventClass, TEventTypeEnum> *_eventMap;

        public:
            Events(TEventClass *eventClass) 
            {
                _eventClass = eventClass;
                _eventMap = new EventMap<TEventClass, TEventTypeEnum>();
            }

            ~Events()
            {
                Log::WriteLine("Destructing Events");
                delete _eventMap;
            }

            Events<TEventClass, TEventTypeEnum> *AddEventAction(TEventTypeEnum eventType, EventAction<TEventClass> eventAction)
            {
                EventActions<TEventClass> *eventActions = this->GetEventActionsForEventType(eventType);
                eventActions->push_back(eventAction);

                return this;
            }

            EventActions<TEventClass> *GetEventActionsForEventType(TEventTypeEnum eventType)
            {
                EventMap<TEventClass, TEventTypeEnum> *eventMap = this->GetEventMap();
                auto eventTypeActions = eventMap->find(eventType);
                EventActions<TEventClass> *eventActions;

                if (eventTypeActions == eventMap->end())
                {
                    eventActions = new EventActions<TEventClass>();
                    eventMap->insert(EventTypeActions<TEventClass, TEventTypeEnum>(eventType, eventActions));
                }
                else
                {
                    eventActions = eventTypeActions->second;
                }

                return eventActions;
            }

            EventMap<TEventClass, TEventTypeEnum> *GetEventMap()
            {
                return _eventMap;
            }

            Events<TEventClass, TEventTypeEnum> *EmitEvent(TEventTypeEnum eventType)
            {
                EventActions<TEventClass> *eventActions = this->GetEventActionsForEventType(eventType);
                
                if (eventActions->size() == 0)
                {
                    return this;
                }

                for (EventAction<TEventClass> eventAction : *eventActions)
                {
                    try
                    {
                        eventAction(_eventClass);
                    }
                    catch(const std::exception& e)
                    {
                        std::cerr << e.what() << '\n';
                    }
                }

                return this;
            }

            // template<typename P>
            // Events<TEventClass, TEventTypeEnum> *EmitEvent<P>(TEventTypeEnum eventType, P arg1);

            // template <typename P, typename H>
            // Events<TEventClass, TEventTypeEnum> *EmitEvent<P, H>(TEventTypeEnum eventType, P arg1, H arg2);

            // template<typename P, typename H, typename O>
            // Events<TEventClass, TEventTypeEnum> *EmitEvent<P, H, O>(TEventTypeEnum eventType, P arg1, H arg2, O arg3);

            // template<typename P, typename H, typename O, typename T>
            // Events<TEventClass, TEventTypeEnum> *EmitEvent<P, H, O, T>(TEventTypeEnum eventType, P arg1, H arg2, O arg3, T arg4);

            // template<typename P, typename H, typename O, typename T, typename I>
            // Events<TEventClass, TEventTypeEnum> *EmitEvent<P, H, O, T, I>(TEventTypeEnum eventType, P arg1, H arg2, O arg3, T arg4, I arg5);

            // template<typename P, typename H, typename O, typename T, typename I, typename N>
            // Events<TEventClass, TEventTypeEnum> *EmitEvent<P, H, O, T, I, N>(TEventTypeEnum eventType, P arg1, H arg2, O arg3, T arg4, I arg5, N arg6);

            // // Can't use O twice, so C ... looks close enough
            // template<typename P, typename H, typename O, typename T, typename I, typename N, typename C>
            // Events<TEventClass, TEventTypeEnum> *EmitEvent<P, H, O, T, I, N, C>(TEventTypeEnum eventType, P arg1, H arg2, O arg3, T arg4, I arg5, N arg6, C arg7);
    };
}
