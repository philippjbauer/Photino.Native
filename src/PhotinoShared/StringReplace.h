#pragma once
#include <string>

// @author Gauthier Boaglio
// @see https://stackoverflow.com/a/24315631/2239967
static inline void StringReplace(std::string &str, const std::string& from, const std::string& to)
{
    size_t start_pos = 0;
    while ((start_pos = str.find(from, start_pos)) != std::string::npos) {
        str.replace(start_pos, from.length(), to);
        start_pos += to.length(); // Handles case where 'to' is a substring of 'from'
    }
}
