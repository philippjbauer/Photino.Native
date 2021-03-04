#include <iostream>
#include "Log.h"

void Log::WriteLine(std::string message)
{
    std::cout << message << std::endl;
}

void Log::WriteMetrics(Metrics metrics)
{
    std::string instancesString = std::to_string(metrics.CurrentInstanceCount());
    std::string usageInKbString = std::to_string(metrics.CurrentMemoryUsage() / 1024);

    Log::WriteLine("Memory Usage: " + usageInKbString + " KB, Instances: " + instancesString);
}
