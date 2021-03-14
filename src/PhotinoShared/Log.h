#pragma once
#include <iostream>
#include "Metrics.h"

namespace PhotinoShared
{
    namespace Log
    {
        void WriteLine(std::string message);
        void WriteMetrics(Metrics *metrics);
    }
}
