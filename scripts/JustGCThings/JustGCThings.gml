/*
    Just GC Things, a single script library by Nikita Krapivin (aka *the* idiot).
    enjoy.
    
    The magic is in @@Dispose@@ and valueOf.
    
    Argument notation:
    `arg`Nameofargument`Argumenttype`[OrArgumenttype]`[Opt;Ref]`
    Opt - this argument is optional
    Ref - this argument will be modified (if it's a struct)
    Types:
    Number, Struct, Function, Constant
    
    Objects:
    JGTBase - the base class for all things collectable resources (plz dont modify)
    JGTDS* - Data Structures
    JGTBuffer - buffers
    JGTSurface - surfaces
    you are free to add your own!
    
    If you want even more magic, include JustGCThingsMacros. 
*/

// set to false if you do not wish any silly debug spam.
#macro JGT_DO_DEBUG_SPAM true

// a guarder to prevent from this script getting called e.g. JustGCThings();
function JustGCThings() {
    throw "JGT: Why are you doing *this* when you are the architect of your own vision, of your own adventure, of your own creation?";
}

// gml function cache
global.JGTCache = {
    /* key = string, value = method */
};

/// @description Resolves a runtime function, also useful if it's overridden by a macro.
/// @param argTargetFunctionOrString runtime function name or the function itself
function JGTResolveFunction(argTargetFunctionOrString) {
    if (is_string(argTargetFunctionOrString)) {
        if (!variable_struct_exists(global.JGTCache, argTargetFunctionOrString)) {
            var ingmlscripts = false;
            // false - parsing runtime functions
            // true  - parsing gml scripts
            for (var i = 0; true; ++i) {
                var n = script_get_name(i); // script name OR "<undefined>" OR "<unknown>"
                
                // "<unknown>" or "<undefined>", no func names can contain < anyway.
                if (string_char_at(n, 1) == "<") {
                    if (!ingmlscripts) {
                        // do gml scripts now.
                        ingmlscripts = true;
                        i = 100000;
                        // gml script indexes start at 100000 plus one. (100000 will return <unknown>)
                        continue;
                    }
                    
                    break;
                }
                
                // found?
                if (n == argTargetFunctionOrString) {
                    // cast to a runtime method for faster execution.
                    var rm = method(undefined, i);
                    global.JGTCache[$ n] = rm;
                    return rm;
                }
            }
        }
        
        return global.JGTCache[$ argTargetFunctionOrString];
    }
    
    // already a method?
    return argTargetFunctionOrString;
}

// a dummy function in case a resource type doesn't have it's own (good example - network sockets, no network_exists)
function JGTDummyAlive(argIndexNumber)      { return (argIndexNumber >= 0                      ); }
// alive checkers that only take ONE! argument, wrappers around ds_exists...
function JGTDSMapAlive(argIndexNumber)      { return ds_exists(argIndexNumber, ds_type_map     ); }
function JGTDSListAlive(argIndexNumber)     { return ds_exists(argIndexNumber, ds_type_list    ); }
function JGTDSGridAlive(argIndexNumber)     { return ds_exists(argIndexNumber, ds_type_grid    ); }
function JGTDSPriorityAlive(argIndexNumber) { return ds_exists(argIndexNumber, ds_type_priority); }
function JGTDSQueueAlive(argIndexNumber)    { return ds_exists(argIndexNumber, ds_type_queue   ); }
function JGTDSStackAlive(argIndexNumber)    { return ds_exists(argIndexNumber, ds_type_stack   ); }

function JGTBase(argIndexNumber, argDeleterFunctionOrString, argCheckerFunctionOrString = undefined)
    constructor {
    // private:
    
    // @description the resource index.
    m_value   = argIndexNumber;
    
    // @description a function that takes m_value and destroys it.
    m_deleter = JGTResolveFunction(argDeleterFunctionOrString);
    
    // @description a function that takes m_value and returns true if it's alive, false otherwise.
    m_checker = JGTResolveFunction(argCheckerFunctionOrString) ?? JGTResolveFunction("JGTDummyAlive");
    
    // public: THOSE ARE NOT STATICS INTENTIONALLY, JUST SO THE INHERITANCE STUFF WON'T BREAK!!!
    
    // @description This is so you can pass JGTBase objects to runtime functions
    // @returns {number} the index
    valueOf   = function() {
        // this is the magic function that allows us to pass objects to runtime functions just fine.
        return m_value;  
    };
    
    // @description Pretends as if it stringified the index, just so string(mydsmap) works
    // @returns {string} index stringified
    toString  = function() {
        // just in case, to be suuuper sneaky.
        return string(m_value);
    };
    
    // @description explicitly disposes a resource, example usage s = s.Dispose();
    Dispose   = function() {
        m_deleter(m_value);
        // unset index to a negative value.
        m_value = -1;
        if (JGT_DO_DEBUG_SPAM) {
            show_debug_message("JGT: Internal YY @@Dispose@@ call, " + instanceof(self) + " disposed, deleter is " + script_get_name(method_get_index(m_deleter)));
        }
        // just so the s = s.Dispose(); can be used (both disposes and unsets to undefined)
        return undefined;
    };
    
    // @description Can be used to explicitly check whether a resource is alive or not.
    // @returns {bool} is resource alive or not
    IsAlive   = function() {
        return m_checker(m_value);
    };
    
    // runtime shit, thank you yoyogames, no, really, as much as I dislike opera's GX business practics
    // that's kewl, *hugs*
    dispose   = Dispose; // internal runtime name 1 (old YYJS stuff, doesn't really work)
    self[$ "@@Dispose@@"] = Dispose; // internal runtime name 2, used in effect structs since 2022+.
    
    // log:
    if (JGT_DO_DEBUG_SPAM) {
        show_debug_message("JGT: Allocated, value is " + string(m_value) + ", checker is " + script_get_name(method_get_index(m_checker)) + ", deleter is " + script_get_name(method_get_index(m_deleter)));
    }
}

function JGTDSMap(argIndexNumber) :
    // inheritance arguments cannot be non-constants, apparently ds_map_destroy (a function) is NOT considered a constant ;-;
    JGTBase(argIndexNumber, "ds_map_destroy", "JGTDSMapAlive")
    constructor {
    // what did you expect?
}

function JGTDSList(argIndexNumber) :
    // inheritance arguments cannot be non-constants, apparently ds_map_destroy (a function) is NOT considered a constant ;-;
    JGTBase(argIndexNumber, "ds_list_destroy", "JGTDSListAlive")
    constructor {
    // what did you expect?
}

function JGTDSGrid(argIndexNumber) :
    // inheritance arguments cannot be non-constants, apparently ds_map_destroy (a function) is NOT considered a constant ;-;
    JGTBase(argIndexNumber, "ds_grid_destroy", "JGTDSGridAlive")
    constructor {
    // what did you expect?
}

function JGTDSPriority(argIndexNumber) :
    // inheritance arguments cannot be non-constants, apparently ds_map_destroy (a function) is NOT considered a constant ;-;
    JGTBase(argIndexNumber, "ds_priority_destroy", "JGTDSPriorityAlive")
    constructor {
    // what did you expect?
}

function JGTDSQueue(argIndexNumber) :
    // inheritance arguments cannot be non-constants, apparently ds_map_destroy (a function) is NOT considered a constant ;-;
    JGTBase(argIndexNumber, "ds_queue_destroy", "JGTDSQueueAlive")
    constructor {
    // what did you expect?
}

function JGTDSStack(argIndexNumber) :
    // inheritance arguments cannot be non-constants, apparently ds_map_destroy (a function) is NOT considered a constant ;-;
    JGTBase(argIndexNumber, "ds_stack_destroy", "JGTDSStackAlive")
    constructor {
    // what did you expect?
}

function JGTSurface(argIndexNumber) :
    // inheritance arguments cannot be non-constants, apparently ds_map_destroy (a function) is NOT considered a constant ;-;
    JGTBase(argIndexNumber, "surface_free", "surface_exists")
    constructor {
    // what did you expect?
}

function JGTBuffer(argIndexNumber) :
    // inheritance arguments cannot be non-constants, apparently ds_map_destroy (a function) is NOT considered a constant ;-;
    JGTBase(argIndexNumber, "buffer_delete", "buffer_exists")
    constructor {
    // what did you expect?
}

// add your own here...
