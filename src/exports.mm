#include "exports.h"

extern "C"
{
    EXPORTED PhotinoApp *PhotinoApp_ctor() { return new PhotinoApp(); }
}
