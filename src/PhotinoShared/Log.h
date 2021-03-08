#pragma once
#include <iostream>
#include "Metrics.h"

namespace PhotinoShared
{
    class Log
    {
        public:
            static void WriteLine(std::string message);
            static void WriteMetrics(Metrics *metrics);
    };
}
