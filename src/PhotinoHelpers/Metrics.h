#pragma once
#include <memory>

namespace PhotinoHelpers
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
