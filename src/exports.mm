#include "exports.h"

extern "C"
{
    EXPORTED Photino::App *PhotinoApp_ctor() { return new Photino::App(); }
}
