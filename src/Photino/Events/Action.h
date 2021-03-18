#pragma once
#include <functional>
#include <unordered_map>

namespace Photino
{
    template<typename Sender, typename ...Args>
    struct Action
    {
        using IndexT = size_t;
        
        Action(Sender *sender) : _sender(sender) { }

        //slots can be used to more easily disconnect _actions
        struct Slot
        {
            Action *_action = nullptr;
            IndexT _slotIndex{};

            Slot() = default;
            Slot(Action *s, IndexT i) : _action(s), _slotIndex(i) {}
            ~Slot()
            {
                if (_action)
                    _action->disconnect(_slotIndex);
            }
            void disconnect()
            {
                if (_action)
                {
                    _action->disconnect(_slotIndex);
                    _action = nullptr;
                }
            }
            void release()
            {
                _action = nullptr;
            }
            void emit(const Args &...args)
            {
                if (_action)
                    _action->emit(_sender, args...);
            }

        };

        template<typename Func>
        IndexT connect(Func &&action)
        {
            _actions.emplace(++_actionIndex, std::forward<Func>(action));
            return _actionIndex;
        }

        template<typename Func>
        [[nodiscard]] Slot connectWithSlot(Func &&action)
        {
            //TODO: support slots that outlive the signal, maybe via enable_shared_from_this?
            return Slot{ this, connect(std::forward<Func>(action)) };
        }

        bool disconnect(IndexT actionIndex)
        {
            return _actions.erase(actionIndex);
        }

        void disconnectAll()
        {
            _actions.clear();
        }

        void emit(const Args &...args)
        {
            for (auto& [idx, action] : _actions)
            {
                action(_sender, args...);
            }
        }

        private:
            Sender *_sender;

            IndexT _actionIndex = 0;
            std::unordered_map<IndexT, std::function<void(Args...)>> _actions;
    };
}