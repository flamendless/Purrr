local Assets = {}
local states = {}

function states.splash()
	return {
		images = {
			{ id = "flamendless", path = "assets/anim/flamendless.png" },
		},
		sources = {
			{ id = "sfx_transition", path = "assets/sounds/cat/deep_meow.ogg", kind = "stream" },
			{ id = "sfx_alert", path = "assets/sounds/sfx/alert.ogg", kind = "static" },
			{ id = "sfx_back", path = "assets/sounds/sfx/back.ogg", kind = "static" },
			{ id = "sfx_forward", path = "assets/sounds/sfx/forward.ogg", kind = "static" },
			{ id = "sfx_hover1", path = "assets/sounds/sfx/hover1.ogg", kind = "static" },
			{ id = "sfx_click1", path = "assets/sounds/sfx/click1.ogg", kind = "static" },
			{ id = "sfx_click2", path = "assets/sounds/sfx/click2.ogg", kind = "static" },
			{ id = "sfx_click3", path = "assets/sounds/sfx/click3.ogg", kind = "static" },
			{ id = "sfx_click4", path = "assets/sounds/sfx/click4.ogg", kind = "static" },
			{ id = "sfx_click5", path = "assets/sounds/sfx/click5.ogg", kind = "static" },
			{ id = "sfx_wrong", path = "assets/sounds/sfx/wrong.ogg", kind = "static" },
			{ id = "sfx_page_turn", path = "assets/sounds/sfx/page_turn.ogg", kind = "static" },
			{ id = "sfx_buy", path = "assets/sounds/sfx/buy.ogg", kind = "static" },
			{ id = "sfx_coins1", path = "assets/sounds/sfx/coins1.ogg", kind = "static" },
			{ id = "sfx_coins2", path = "assets/sounds/sfx/coins2.ogg", kind = "static" },
			{ id = "sfx_coins3", path = "assets/sounds/sfx/coins3.ogg", kind = "static" },
			{ id = "cat_purrr", path = "assets/sounds/cat/cat_purrr.ogg", kind = "static" },
			{ id = "cat_snore", path = "assets/sounds/cat/cat_snore.ogg", kind = "static" },
		},
		fonts = {
			{ id = "vera", path = "assets/fonts/vera.ttf", sizes = { 18, 24, 32 } },
			{ id = "bmdelico", path = "assets/fonts/bmdelico.ttf", sizes = { 18, 24, 32, 42 } },
			{ id = "trashhand", path = "assets/fonts/trashhand.ttf", sizes = {18, 28, 32, 36, 42, 48} },
		}
	}
end

function states.menu()
	return {
		images = {
			{ id = "title", path = "assets/images/title.png" },
			{ id = "btn_play", path = "assets/gui/play.png" },
			{ id = "btn_play_hovered", path = "assets/gui/play_hovered.png" },
			{ id = "btn_leave", path = "assets/gui/leave.png" },
			{ id = "btn_leave_hovered", path = "assets/gui/leave_hovered.png" },
			{ id = "window_red", path = "assets/gui/window_red.png" },
			{ id = "window_green", path = "assets/gui/window_green.png" },
			{ id = "window_blue", path = "assets/gui/window_blue.png" },
			{ id = "button_accept", path = "assets/gui/button_accept.png" },
			{ id = "button_accept_hovered", path = "assets/gui/button_accept_hovered.png" },
			{ id = "button_back", path = "assets/gui/button_back.png" },
			{ id = "button_back_hovered", path = "assets/gui/button_back_hovered.png" },
			{ id = "button_cancel", path = "assets/gui/button_cancel.png" },
			{ id = "button_cancel_hovered", path = "assets/gui/button_cancel_hovered.png" },
			{ id = "items_base", path = "assets/gui/items_base.png" },
			{ id = "items_base_hovered", path = "assets/gui/items_base_hovered.png" },
			{ id = "window_settings1", path = "assets/gui/window_settings1.png" },
			{ id = "window_settings2", path = "assets/gui/window_settings2.png" },
			{ id = "window_settings3", path = "assets/gui/window_settings3.png" },
			{ id = "window_settings4", path = "assets/gui/window_settings4.png" },
			{ id = "bg", path = "assets/images/bg.png" },
		},
		sources = {
			{ id = "bgm_menu", path = "assets/sounds/bgm/menu.ogg", kind = "stream" },
			{ id = "bgm_main_menu", path = "assets/sounds/bgm/main_menu.ogg", kind = "stream" },
		},
		fonts = {
			{ id = "upheaval", path = "assets/fonts/upheavalpro.ttf", sizes = {18, 28, 32, 36, 42} },
		},
	}
end

function states.intro()
	return {
		images = {
			{ id = "spritesheet", path = "assets/anim/space.png" }
		},
		sources = {
			{ id = "bgm_intro", path = "assets/sounds/bgm/intro.ogg", kind = "stream" },
		},
	}
end

function states.customization()
	return {
		images = {
			{ id = "pattern1", path = "assets/images/pattern1.png" },
			{ id = "pattern2", path = "assets/images/pattern2.png" },
			{ id = "pattern3", path = "assets/images/pattern3.png" },
			{ id = "pattern4", path = "assets/images/pattern4.png" },
			{ id = "pattern5", path = "assets/images/pattern5.png" },
			{ id = "pattern6", path = "assets/images/pattern6.png" },
			{ id = "pattern7", path = "assets/images/pattern7.png" },
			{ id = "pattern8", path = "assets/images/pattern8.png" },
			{ id = "pattern9", path = "assets/images/pattern9.png" },
			{ id = "btn_back", path = "assets/gui/button_back.png" },
			{ id = "btn_back_hovered", path = "assets/gui/button_back_hovered.png" },
			{ id = "btn_forward", path = "assets/gui/button_forward.png" },
			{ id = "btn_forward_hovered", path = "assets/gui/button_forward_hovered.png" },
			{ id = "btn_yellow", path = "assets/gui/button_yellow.png" },
			{ id = "btn_yellow_hovered", path = "assets/gui/button_yellow_hovered.png" },
			{ id = "btn_green", path = "assets/gui/button_green.png" },
			{ id = "btn_green_hovered", path = "assets/gui/button_green_hovered.png" },
			{ id = "btn_purple", path = "assets/gui/button_purple.png" },
			{ id = "btn_purple_hovered", path = "assets/gui/button_purple_hovered.png" },
			{ id = "btn_red", path = "assets/gui/button_red.png" },
			{ id = "btn_red_hovered", path = "assets/gui/button_red_hovered.png" },
			{ id = "btn_blue", path = "assets/gui/button_blue.png" },
			{ id = "btn_blue_hovered", path = "assets/gui/button_blue_hovered.png" },
			{ id = "btn_grayscale", path = "assets/gui/button_grayscale.png" },
			{ id = "btn_grayscale_hovered", path = "assets/gui/button_grayscale_hovered.png" },
			{ id = "btn_softmilk", path = "assets/gui/button_softmilk.png" },
			{ id = "btn_softmilk_hovered", path = "assets/gui/button_softmilk_hovered.png" },
			{ id = "btn_black", path = "assets/gui/button_black.png" },
			{ id = "btn_black_hovered", path = "assets/gui/button_black_hovered.png" },
			{ id = "btn_white", path = "assets/gui/button_white.png" },
			{ id = "btn_white_hovered", path = "assets/gui/button_white_hovered.png" },
			{ id = "btn_lime", path = "assets/gui/button_lime.png" },
			{ id = "btn_lime_hovered", path = "assets/gui/button_lime_hovered.png" },
			{ id = "btn_orange", path = "assets/gui/button_orange.png" },
			{ id = "btn_orange_hovered", path = "assets/gui/button_orange_hovered.png" },
			{ id = "btn_pink", path = "assets/gui/button_pink.png" },
			{ id = "btn_pink_hovered", path = "assets/gui/button_pink_hovered.png" },
			{ id = "lock", path = "assets/images/lock.png" },
			{ id = "bg_space", path = "assets/images/title_space.png" },
			{ id = "window", path = "assets/gui/window.png" },
			{ id = "header", path = "assets/gui/header.png" },
			{ id = "sheet_cat_attack", path = "assets/anim/cat_attack.png" },
			{ id = "sheet_cat_blink", path = "assets/anim/cat_blink.png" },
			{ id = "sheet_cat_dizzy", path = "assets/anim/cat_dizzy.png" },
			{ id = "sheet_cat_heart", path = "assets/anim/cat_heart.png" },
			{ id = "sheet_cat_heart", path = "assets/anim/cat_heart.png" },
			{ id = "sheet_cat_hurt", path = "assets/anim/cat_hurt.png" },
			{ id = "sheet_cat_mouth", path = "assets/anim/cat_mouth.png" },
			{ id = "sheet_cat_sleep", path = "assets/anim/cat_sleep.png" },
			{ id = "sheet_cat_snore", path = "assets/anim/cat_snore.png" },
			{ id = "sheet_cat_spin", path = "assets/anim/cat_spin.png" },
			{ id = "pal_attack_source", path = "assets/palettes/source/attack.png" },
			{ id = "pal_blink_source", path = "assets/palettes/source/blink.png" },
			{ id = "pal_dizzy_source", path = "assets/palettes/source/dizzy.png" },
			{ id = "pal_heart_source", path = "assets/palettes/source/heart.png" },
			{ id = "pal_hurt_source", path = "assets/palettes/source/hurt.png" },
			{ id = "pal_mouth_source", path = "assets/palettes/source/mouth.png" },
			{ id = "pal_sleep_source", path = "assets/palettes/source/sleep.png" },
			{ id = "pal_snore_source", path = "assets/palettes/source/snore.png" },
			{ id = "pal_spin_source", path = "assets/palettes/source/spin.png" },
			{ id = "pal_attack_softmilk", path = "assets/palettes/softmilk/attack.png" },
			{ id = "pal_blink_softmilk", path = "assets/palettes/softmilk/blink.png" },
			{ id = "pal_dizzy_softmilk", path = "assets/palettes/softmilk/dizzy.png" },
			{ id = "pal_heart_softmilk", path = "assets/palettes/softmilk/heart.png" },
			{ id = "pal_hurt_softmilk", path = "assets/palettes/softmilk/hurt.png" },
			{ id = "pal_mouth_softmilk", path = "assets/palettes/softmilk/mouth.png" },
			{ id = "pal_sleep_softmilk", path = "assets/palettes/softmilk/sleep.png" },
			{ id = "pal_snore_softmilk", path = "assets/palettes/softmilk/snore.png" },
			{ id = "pal_spin_softmilk", path = "assets/palettes/softmilk/spin.png" },
			{ id = "pal_attack_blue", path = "assets/palettes/blue/attack.png" },
			{ id = "pal_blink_blue", path = "assets/palettes/blue/blink.png" },
			{ id = "pal_dizzy_blue", path = "assets/palettes/blue/dizzy.png" },
			{ id = "pal_heart_blue", path = "assets/palettes/blue/heart.png" },
			{ id = "pal_hurt_blue", path = "assets/palettes/blue/hurt.png" },
			{ id = "pal_mouth_blue", path = "assets/palettes/blue/mouth.png" },
			{ id = "pal_sleep_blue", path = "assets/palettes/blue/sleep.png" },
			{ id = "pal_snore_blue", path = "assets/palettes/blue/snore.png" },
			{ id = "pal_spin_blue", path = "assets/palettes/blue/spin.png" },
			{ id = "pal_attack_green", path = "assets/palettes/green/attack.png" },
			{ id = "pal_blink_green", path = "assets/palettes/green/blink.png" },
			{ id = "pal_dizzy_green", path = "assets/palettes/green/dizzy.png" },
			{ id = "pal_heart_green", path = "assets/palettes/green/heart.png" },
			{ id = "pal_hurt_green", path = "assets/palettes/green/hurt.png" },
			{ id = "pal_mouth_green", path = "assets/palettes/green/mouth.png" },
			{ id = "pal_sleep_green", path = "assets/palettes/green/sleep.png" },
			{ id = "pal_snore_green", path = "assets/palettes/green/snore.png" },
			{ id = "pal_spin_green", path = "assets/palettes/green/spin.png" },
			{ id = "pal_attack_grayscale", path = "assets/palettes/grayscale/attack.png" },
			{ id = "pal_blink_grayscale", path = "assets/palettes/grayscale/blink.png" },
			{ id = "pal_dizzy_grayscale", path = "assets/palettes/grayscale/dizzy.png" },
			{ id = "pal_heart_grayscale", path = "assets/palettes/grayscale/heart.png" },
			{ id = "pal_hurt_grayscale", path = "assets/palettes/grayscale/hurt.png" },
			{ id = "pal_mouth_grayscale", path = "assets/palettes/grayscale/mouth.png" },
			{ id = "pal_sleep_grayscale", path = "assets/palettes/grayscale/sleep.png" },
			{ id = "pal_snore_grayscale", path = "assets/palettes/grayscale/snore.png" },
			{ id = "pal_spin_grayscale", path = "assets/palettes/grayscale/spin.png" },
		},
		fonts = {
			{ id = "header", path = "assets/fonts/upheavalpro.ttf", sizes = { 32, 36, 42, 48 } },
			{ id = "buttons", path = "assets/fonts/futurehandwritten.ttf", sizes = { 24, 30, 32, 36, 42, 48 } },
			{ id = "upheaval", path = "assets/fonts/upheavalpro.ttf", sizes = {18, 28, 32, 36, 42} },
		},
		sources = {
			{ id = "bgm_customization", path = "assets/sounds/bgm/customization.ogg", kind = "stream" },
		},
	}
end

function states.lobby()
	return {
		images = {
			{ id = "energy_full", path = "assets/gui/energy_full.png" },
			{ id = "energy_half", path = "assets/gui/energy_half.png" },
			{ id = "energy_empty", path = "assets/gui/energy_empty.png" },
			{ id = "window", path = "assets/gui/window.png" },
			{ id = "display_lobby", path = "assets/images/display_lobby.png" },
			{ id = "name", path = "assets/gui/name.png" },
			{ id = "pattern1", path = "assets/images/pattern1.png" },
			{ id = "pattern2", path = "assets/images/pattern2.png" },
			{ id = "pattern3", path = "assets/images/pattern3.png" },
			{ id = "pattern4", path = "assets/images/pattern4.png" },
			{ id = "pattern5", path = "assets/images/pattern5.png" },
			{ id = "pattern6", path = "assets/images/pattern6.png" },
			{ id = "pattern7", path = "assets/images/pattern7.png" },
			{ id = "pattern8", path = "assets/images/pattern8.png" },
			{ id = "pattern9", path = "assets/images/pattern9.png" },
			{ id = "header", path = "assets/gui/header.png" },
			{ id = "sheet_cat_attack", path = "assets/anim/cat_attack.png" },
			{ id = "sheet_cat_blink", path = "assets/anim/cat_blink.png" },
			{ id = "sheet_cat_dizzy", path = "assets/anim/cat_dizzy.png" },
			{ id = "sheet_cat_heart", path = "assets/anim/cat_heart.png" },
			{ id = "sheet_cat_heart", path = "assets/anim/cat_heart.png" },
			{ id = "sheet_cat_hurt", path = "assets/anim/cat_hurt.png" },
			{ id = "sheet_cat_mouth", path = "assets/anim/cat_mouth.png" },
			{ id = "sheet_cat_sleep", path = "assets/anim/cat_sleep.png" },
			{ id = "sheet_cat_snore", path = "assets/anim/cat_snore.png" },
			{ id = "sheet_cat_spin", path = "assets/anim/cat_spin.png" },
			{ id = "pal_attack_source", path = "assets/palettes/source/attack.png" },
			{ id = "pal_blink_source", path = "assets/palettes/source/blink.png" },
			{ id = "pal_dizzy_source", path = "assets/palettes/source/dizzy.png" },
			{ id = "pal_heart_source", path = "assets/palettes/source/heart.png" },
			{ id = "pal_hurt_source", path = "assets/palettes/source/hurt.png" },
			{ id = "pal_mouth_source", path = "assets/palettes/source/mouth.png" },
			{ id = "pal_sleep_source", path = "assets/palettes/source/sleep.png" },
			{ id = "pal_snore_source", path = "assets/palettes/source/snore.png" },
			{ id = "pal_spin_source", path = "assets/palettes/source/spin.png" },
			{ id = "pal_attack_softmilk", path = "assets/palettes/softmilk/attack.png" },
			{ id = "pal_blink_softmilk", path = "assets/palettes/softmilk/blink.png" },
			{ id = "pal_dizzy_softmilk", path = "assets/palettes/softmilk/dizzy.png" },
			{ id = "pal_heart_softmilk", path = "assets/palettes/softmilk/heart.png" },
			{ id = "pal_hurt_softmilk", path = "assets/palettes/softmilk/hurt.png" },
			{ id = "pal_mouth_softmilk", path = "assets/palettes/softmilk/mouth.png" },
			{ id = "pal_sleep_softmilk", path = "assets/palettes/softmilk/sleep.png" },
			{ id = "pal_snore_softmilk", path = "assets/palettes/softmilk/snore.png" },
			{ id = "pal_spin_softmilk", path = "assets/palettes/softmilk/spin.png" },
			{ id = "pal_attack_blue", path = "assets/palettes/blue/attack.png" },
			{ id = "pal_blink_blue", path = "assets/palettes/blue/blink.png" },
			{ id = "pal_dizzy_blue", path = "assets/palettes/blue/dizzy.png" },
			{ id = "pal_heart_blue", path = "assets/palettes/blue/heart.png" },
			{ id = "pal_hurt_blue", path = "assets/palettes/blue/hurt.png" },
			{ id = "pal_mouth_blue", path = "assets/palettes/blue/mouth.png" },
			{ id = "pal_sleep_blue", path = "assets/palettes/blue/sleep.png" },
			{ id = "pal_snore_blue", path = "assets/palettes/blue/snore.png" },
			{ id = "pal_spin_blue", path = "assets/palettes/blue/spin.png" },
			{ id = "pal_attack_green", path = "assets/palettes/green/attack.png" },
			{ id = "pal_blink_green", path = "assets/palettes/green/blink.png" },
			{ id = "pal_dizzy_green", path = "assets/palettes/green/dizzy.png" },
			{ id = "pal_heart_green", path = "assets/palettes/green/heart.png" },
			{ id = "pal_hurt_green", path = "assets/palettes/green/hurt.png" },
			{ id = "pal_mouth_green", path = "assets/palettes/green/mouth.png" },
			{ id = "pal_sleep_green", path = "assets/palettes/green/sleep.png" },
			{ id = "pal_snore_green", path = "assets/palettes/green/snore.png" },
			{ id = "pal_spin_green", path = "assets/palettes/green/spin.png" },
			{ id = "pal_attack_grayscale", path = "assets/palettes/grayscale/attack.png" },
			{ id = "pal_blink_grayscale", path = "assets/palettes/grayscale/blink.png" },
			{ id = "pal_dizzy_grayscale", path = "assets/palettes/grayscale/dizzy.png" },
			{ id = "pal_heart_grayscale", path = "assets/palettes/grayscale/heart.png" },
			{ id = "pal_hurt_grayscale", path = "assets/palettes/grayscale/hurt.png" },
			{ id = "pal_mouth_grayscale", path = "assets/palettes/grayscale/mouth.png" },
			{ id = "pal_sleep_grayscale", path = "assets/palettes/grayscale/sleep.png" },
			{ id = "pal_snore_grayscale", path = "assets/palettes/grayscale/snore.png" },
			{ id = "pal_spin_grayscale", path = "assets/palettes/grayscale/spin.png" },
			{ id = "button_bag", path = "assets/gui/button_bag.png" },
			{ id = "button_bag_hovered", path = "assets/gui/button_bag_hovered.png" },
			{ id = "button_play", path = "assets/gui/button_play.png" },
			{ id = "button_play_hovered", path = "assets/gui/button_play_hovered.png" },
			{ id = "button_store", path = "assets/gui/button_store.png" },
			{ id = "button_store_hovered", path = "assets/gui/button_store_hovered.png" },
			{ id = "button_home", path = "assets/gui/button_home.png" },
			{ id = "button_home_hovered", path = "assets/gui/button_home_hovered.png" },
			{ id = "button_store", path = "assets/gui/button_store.png" },
			{ id = "button_store_hovered", path = "assets/gui/button_store_hovered.png" },
			{ id = "button_home", path = "assets/gui/button_home.png" },
			{ id = "button_home_hovered", path = "assets/gui/button_home_hovered.png" },
			{ id = "button_settings", path = "assets/gui/button_settings.png" },
			{ id = "button_settings_hovered", path = "assets/gui/button_settings_hovered.png" },
			{ id = "button_mute", path = "assets/gui/button_mute.png" },
			{ id = "button_mute_hovered", path = "assets/gui/button_mute_hovered.png" },
			{ id = "button_volume", path = "assets/gui/button_volume.png" },
			{ id = "button_volume_hovered", path = "assets/gui/button_volume_hovered.png" },
			{ id = "button_cat", path = "assets/gui/button_cat.png" },
			{ id = "button_cat_hovered", path = "assets/gui/button_cat_hovered.png" },
			{ id = "button_star", path = "assets/gui/button_star.png" },
			{ id = "button_star_hovered", path = "assets/gui/button_star_hovered.png" },
			{ id = "button_twitter", path = "assets/gui/button_twitter.png" },
			{ id = "button_twitter_hovered", path = "assets/gui/button_twitter_hovered.png" },
			{ id = "button_forward", path = "assets/gui/button_forward.png" },
			{ id = "button_forward_hovered", path = "assets/gui/button_forward_hovered.png" },
		},
		sources = {
			{ id = "bgm_lobby1", path = "assets/sounds/bgm/lobby1.ogg", kind = "stream" },
			{ id = "bgm_lobby2", path = "assets/sounds/bgm/lobby2.ogg", kind = "stream" },
		},
		fonts = {
			{ id = "header", path = "assets/fonts/upheavalpro.ttf", sizes = { 32, 36, 42, 48 } },
			{ id = "buttons", path = "assets/fonts/futurehandwritten.ttf", sizes = { 24, 30, 32, 36, 42, 48 } },
			{ id = "upheaval", path = "assets/fonts/upheavalpro.ttf", sizes = {18, 28, 32, 36, 42, 48 }},
		}
	}
end

function states.map()
	return {
		images = {
			{ id = "btn_back", path = "assets/gui/button_back.png" },
			{ id = "btn_back_hovered", path = "assets/gui/button_back_hovered.png" },
			{ id = "btn_forward", path = "assets/gui/button_forward.png" },
			{ id = "btn_forward_hovered", path = "assets/gui/button_forward_hovered.png" },
			{ id = "level_complete", path = "assets/images/level_complete.png" },
			{ id = "level_complete_hovered", path = "assets/images/level_complete_hovered.png" },
			{ id = "level_not", path = "assets/images/level_not.png" },
			{ id = "level_not_hovered", path = "assets/images/level_not_hovered.png" },
			{ id = "level_current", path = "assets/images/level_current.png" },
			{ id = "level_current_hovered", path = "assets/images/level_current_hovered.png" },
			{ id = "lock", path = "assets/images/lock.png" },
			{ id = "map_mars", path = "assets/images/map_mars.png" },
			{ id = "map_underground", path = "assets/images/map_underground.png" },
			{ id = "map_space", path = "assets/images/map_space.png" },
			{ id = "map_earth", path = "assets/images/map_earth.png" },
			{ id = "display_mars", path = "assets/images/display_mars.png" },
			{ id = "display_caverns", path = "assets/images/display_caverns.png" },
			{ id = "display_space", path = "assets/images/display_space.png" },
			{ id = "display_earth", path = "assets/images/display_earth.png" },
		},
		sources = {
			{ id = "bgm_map1", path = "assets/sounds/bgm/map1.ogg", kind = "stream" },
			{ id = "bgm_map2", path = "assets/sounds/bgm/map2.ogg", kind = "stream" },
		},
		fonts = {
			{ id = "header", path = "assets/fonts/upheavalpro.ttf", sizes = { 32, 36, 42, 48 } },
			{ id = "buttons", path = "assets/fonts/futurehandwritten.ttf", sizes = { 24, 30, 32, 36, 42, 48 } },
			{ id = "upheaval", path = "assets/fonts/upheavalpro.ttf", sizes = {18, 28, 32, 36, 42, 48} },
			{ id = "level", path = "assets/fonts/trashhand.ttf", sizes = {18, 28, 32, 36, 42, 48} },
		}
	}
end

function Assets:load(state)
	return states[string.lower(state)]()
end

return Assets
