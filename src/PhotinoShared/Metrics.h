#pragma once
#include <memory>

namespace PhotinoShared
{
    struct Metrics
    {
        uint32_t UsedInstances;
        uint32_t FreedInstances;
        uint32_t UsedMemory;
        uint32_t FreedMemory;

        Metrics();

        uint32_t CurrentMemoryUsage();
        uint32_t CurrentInstanceCount();
    };
}
