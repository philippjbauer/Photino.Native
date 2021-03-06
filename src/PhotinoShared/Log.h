#pragma once
#include <iostream>
#include "../PhotinoHelpers/Metrics.h"

namespace PhotinoShared
{
    class Log
    {
        public:
            static void WriteLine(std::string message);
            static void WriteMetrics(PhotinoHelpers::Metrics metrics);
    };
}
