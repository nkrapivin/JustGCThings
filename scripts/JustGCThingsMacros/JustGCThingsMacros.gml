/*
    Just GC Things, Macros!
    
    Only include this file if you want seamless ds_*_create, buffer_create, etc...
    Otherwise just don't......
*/

// Here we use JGTResolveFunction because macros! Wanna be sure they won't mess with us.

// template:
/*
// above:
function JGTResourceCreate(...arguments) {
    return new JGTResource((JGTResolveFunction("some_resource_create"))(...arguments));
}
// below:
#macro some_resource_create JGTResourceCreate
*/

function JGTDSMapCreate() {
    return new JGTDSMap((JGTResolveFunction("ds_map_create"))());
}

function JGTDSListCreate() {
    return new JGTDSList((JGTResolveFunction("ds_list_create"))());
}

function JGTDSQueueCreate() {
    return new JGTDSQueue((JGTResolveFunction("ds_queue_create"))());
}

function JGTDSGridCreate(argWidthNumber, argHeightNumber) {
    return new JGTDSGrid((JGTResolveFunction("ds_grid_create"))(argWidthNumber, argHeightNumber));
}

function JGTDSStackCreate() {
    return new JGTDSStack((JGTResolveFunction("ds_stack_create"))());
}

function JGTDSPriorityCreate() {
    return new JGTDSPriority((JGTResolveFunction("ds_priority_create"))());
}

function JGTSurfaceCreate(argWidthNumber, argHeightNumber) {
    return new JGTSurface((JGTResolveFunction("surface_create"))(argWidthNumber, argHeightNumber));
}

function JGTBufferCreate(argSizeNumber, argTypeConstant, argAlignmentNumber) {
    return new JGTBuffer((JGTResolveFunction("buffer_create"))(argSizeNumber, argTypeConstant, argAlignmentNumber));
}

function JGTOSGetInfo() {
    // it returns a DS Map that *you* have to clean anyway so why not GC it as well?
    return new JGTDSMap((JGTResolveFunction("os_get_info"))());
}

// and now the funny:
#macro ds_map_create      JGTDSMapCreate
#macro ds_list_create     JGTDSListCreate
#macro ds_queue_create    JGTDSQueueCreate
#macro ds_grid_create     JGTDSGridCreate
#macro ds_stack_create    JGTDSStackCreate
#macro ds_priority_create JGTDSPriorityCreate
#macro surface_create     JGTSurfaceCreate
#macro buffer_create      JGTBufferCreate
#macro os_get_info        JGTOSGetInfo
// add others here...


















// a guarder to prevent from this script getting called e.g. JustGCThingsMacros();
function JustGCThingsMacros() {
    throw "JGT: https://paypal.me/nkrapivindev if you care (you REALLY(!) don't have to though)";
}

