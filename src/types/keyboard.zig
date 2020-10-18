const wlr = @import("../wlroots.zig");

const wayland = @import("wayland");
const wl = wayland.server.wl;

const xkb = @import("xkbcommon");

pub const KeyState = extern enum {
    released,
    pressed,
};

pub const Keyboard = extern struct {
    pub const led = struct {
        pub const num_lock = 1 << 0;
        pub const caps_lock = 1 << 1;
        pub const scroll_lock = 1 << 2;
    };

    pub const modifier = struct {
        pub const shift = 1 << 0;
        pub const caps = 1 << 1;
        pub const ctrl = 1 << 2;
        pub const alt = 1 << 3;
        pub const mod2 = 1 << 4;
        pub const mod3 = 1 << 5;
        pub const logo = 1 << 6;
        pub const mod5 = 1 << 7;
    };

    pub const Modifiers = extern struct {
        depressed: xkb.ModMask,
        latched: xkb.ModMask,
        locked: xkb.ModMask,
        group: xkb.ModMask,
    };

    pub const event = struct {
        pub const Key = extern struct {
            time_msec: u32,
            keycode: u32,
            update_state: bool,
            state: KeyState,
        };
    };

    const Impl = opaque {};

    impl: *const Impl,
    group: ?*wlr.KeyboardGroup,

    keymap_string: [*:0]u8,
    keymap_size: usize,
    keymap: ?*xkb.Keymap,
    xkb_state: ?*xkb.State,
    led_indexes: [3]xkb.LED_Index,
    mod_indexes: [8]xkb.ModIndex,

    keycodes: [32]u32,
    num_keycodes: usize,
    modifiers: Modifiers,

    repeat_info: extern struct {
        rate: i32,
        delay: i32,
    },

    events: extern struct {
        key: wl.Signal(*event.Key),
        modifiers: wl.Signal(*Keyboard),
        keymap: wl.Signal(*Keyboard),
        repeat_info: wl.Signal(*Keyboard),
        destroy: wl.Signal(*Keyboard),
    },

    data: ?*c_void,

    extern fn wlr_keyboard_set_keymap(kb: *Keyboard, keymap: *xkb.Keymap) bool;
    pub const setKeymap = wlr_keyboard_set_keymap;

    extern fn wlr_keyboard_keymaps_match(km1: ?*xkb.Keymap, km2: ?*xkb.Keymap) bool;
    pub const keymapsMatch = wlr_keyboard_keymaps_match;

    extern fn wlr_keyboard_set_repeat_info(kb: *Keyboard, rate: i32, delay: i32) void;
    pub const setRepeatInfo = wlr_keyboard_set_repeat_info;

    extern fn wlr_keyboard_led_update(keyboard: *Keyboard, leds: u32) void;
    pub const ledUpdate = wlr_keyboard_led_update;

    extern fn wlr_keyboard_get_modifiers(keyboard: *Keyboard) u32;
    pub const getModifiers = wlr_keyboard_get_modifiers;
};
