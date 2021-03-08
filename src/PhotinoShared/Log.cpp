#include <iostream>
#include "Log.h"

namespace PhotinoShared
{
    void Log::WriteLine(std::string message)
    {
        std::cout << message << std::endl;
    }

    void Log::WriteMetrics(Metrics *metrics)
    {
        std::string instances = std::to_string(metrics->CurrentInstanceCount());

        uint32_t usageValue = metrics->CurrentMemoryUsage();
        std::string usageUnit = "Bytes";

        if (usageValue >= 1024 && usageValue < (usageValue * (1024 * 1024)))
        {
            usageValue = usageValue / 1024;
            usageUnit = "KB";
        }

        std::string usage = std::to_string(usageValue);

        Log::WriteLine("Memory Usage: " + usage + " " + usageUnit + ", Instances: " + instances);
    }
}
