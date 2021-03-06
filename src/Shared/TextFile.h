#pragma once
#include <filesystem>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>

class TextFile
{
    private:
        std::string _path;
        std::string _content;

        std::string Read();

    public:
        TextFile(std::string path);

        std::string GetPath();
        TextFile* SetPath(std::string value);

        std::string GetContent();
        TextFile* SetContent(std::string value);

        std::vector<std::string> GetLines();
};
