/// @description a testcase... observe debug output pwease owo...

// testcase begin
show_debug_message("JGT testcase begin");

var m = ds_map_create();

m[? "test"] = 123;
m[? "test2"] = 456;
m[? "list"] = ds_list_create();
m[? "list"][| 0] = "do you like how i walk";
m[? "list"][| 1] = "do you like how i talk";
m[? "list"][| 2] = "do you like how my face";
m[? "list"][| 3] = "disintegrates into chalk";

show_debug_message("m[? \"test2\"] = " + string(m[? "test2"]));
show_debug_message("m[? \"list\"][| 3] = " + m[? "list"][| 3]);

var b = buffer_create(1, buffer_grow, 1);
buffer_write(b, buffer_string, "https://www.youtube.com/watch?v=9MDnhsxarbM");
show_debug_message("b:string = " + buffer_peek(b, 0, buffer_string));

var surf = surface_create(256, 256);
surface_set_target(surf);
draw_clear(c_yellow);
surface_reset_target();
surface_save(surf, "yellow.png");
show_debug_message("surf[0,0] = " + string(surface_getpixel_ext(surf, 0, 0)));

global.wtf = array_create(1);
global.wtf[0] = ds_stack_create();
ds_stack_push(global.wtf[0], 10, 20, 30, 40, 50, 60, 70, 80, 90, 100);
global.wr = weak_ref_create(global.wtf[0]);
delete global.wtf[0];

randomize();

// no destroy calls here at all! :p


// testcase end
show_debug_message("Variables end, should go out of scope now...");
show_debug_message("place breakpoint here");
did = true;