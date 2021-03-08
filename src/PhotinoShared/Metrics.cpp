#include "Metrics.h"

namespace PhotinoShared
{
    Metrics::Metrics()
    {
        this->UsedInstances = 0;
        this->FreedInstances = 0;
        this->UsedMemory = 0;
        this->FreedMemory = 0;
    }

    uint32_t Metrics::CurrentMemoryUsage()
    {
        return this->UsedMemory - this->FreedMemory;
    }

    uint32_t Metrics::CurrentInstanceCount()
    {
        return this->UsedInstances - this->FreedInstances;
    }
}
