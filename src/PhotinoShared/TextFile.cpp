#include "TextFile.h"

namespace PhotinoShared
{
    TextFile::TextFile(std::string path)
    {
        this->SetPath(path)
            ->SetContent(this->Read());
    }

    std::string TextFile::Read()
    {
        std::ifstream filestream(this->GetPath());

        if (!filestream.is_open())
        {
            throw std::invalid_argument("Path \"" + this->GetPath() + "\" does not exist.");
        }

        std::string content = std::string(
            (std::istreambuf_iterator<char>(filestream)),
            std::istreambuf_iterator<char>());

        filestream.close();

        return content;
    }

    std::string TextFile::GetPath() { return _path; }
    TextFile* TextFile::SetPath(std::string value)
    {
        _path = value;
        return this;
    }

    std::string TextFile::GetContent() { return _content; }
    TextFile* TextFile::SetContent(std::string value)
    {
        _content = value;
        return this;
    }

    std::vector<std::string> TextFile::GetLines()
    {
        std::istringstream stream(this->GetContent());

        std::vector<std::string> lines;
        std::string line;

        while (std::getline(stream, line))
        {
            lines.push_back(line);
        }

        return lines;
    }
}
