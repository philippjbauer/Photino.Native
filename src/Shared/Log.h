#pragma once
#include <iostream>
#include "Metrics.h"

class Log
{
    public:
        static void WriteLine(std::string message);
        static void WriteMetrics(Metrics metrics);
};
