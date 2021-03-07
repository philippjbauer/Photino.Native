#include <iostream>
#include "Events.h"

namespace Photino
{
    template<class TEventTypeEnum>
    Events<TEventTypeEnum>::Events()
    {
        _eventMap = new EventMap<TEventTypeEnum>();
    }

    template<class TEventTypeEnum>
    Events<TEventTypeEnum>::~Events()
    {
        delete _eventMap;
    }

    template<class TEventTypeEnum>
    Events<TEventTypeEnum> *Events<TEventTypeEnum>::AddEventAction(TEventTypeEnum eventType, EventAction eventAction)
    {
        EventActions *eventActions = this->GetEventActionsForEventType(eventType);
        eventActions->push_back(eventAction);

        return this;
    }

    template<class TEventTypeEnum>
    EventActions *Events<TEventTypeEnum>::GetEventActionsForEventType(TEventTypeEnum eventType)
    {
        EventMap<TEventTypeEnum> *eventMap = this->GetEventMap();
        EventTypeActions<TEventTypeEnum> *eventTypeActions = eventMap->find(eventType);
        EventActions *eventActions;

        if (eventTypeActions == eventMap->end())
        {
            eventMap->emplace(eventType, eventActions);
        }
        else
        {
            eventActions = eventTypeActions->second;
        }

        return eventActions;
    }

    template<class TEventTypeEnum>
    EventMap<TEventTypeEnum> *Events<TEventTypeEnum>::GetEventMap()
    {
        return _eventMap;
    }

    template<class TEventTypeEnum>
    Events<TEventTypeEnum> *Events<TEventTypeEnum>::EmitEvent(TEventTypeEnum eventType)
    {
        EventActions *eventActions = this->GetEventActionsForEventType(eventType);

        for (EventAction eventAction : *eventActions)
        {
            try
            {
                eventAction();
            }
            catch(const std::exception& e)
            {
                std::cerr << e.what() << '\n';
            }
        }

        return this;
    }

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
