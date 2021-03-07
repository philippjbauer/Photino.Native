#pragma once
#include <functional>
#include <map>
#include <vector>

namespace Photino
{
    // EventAction
    using EventAction = void (*)();

    //EventActions
    typedef std::vector<EventAction> EventActions;

    // EventTypeActions
    template<class TEventTypeEnum>
    using EventTypeActions = std::pair<TEventTypeEnum, EventActions>;

    // EventMap
    template<class TEventTypeEnum>
    using EventMap = std::map<TEventTypeEnum, EventActions>;

    template<class TEventTypeEnum>
    class Events
    {
        private:
            EventMap<TEventTypeEnum> *_eventMap;

        public:
            Events();
            ~Events();

            Events<TEventTypeEnum> *AddEventAction(TEventTypeEnum eventType, EventAction eventAction);

            EventMap<TEventTypeEnum> *GetEventMap();

            EventActions *GetEventActionsForEventType(TEventTypeEnum eventType);

            Events<TEventTypeEnum> *EmitEvent(TEventTypeEnum eventType);

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
}
