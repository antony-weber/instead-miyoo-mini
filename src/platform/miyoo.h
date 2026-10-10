/*
 * platform/miyoo.h - Platform integration hooks for Miyoo Mini / OnionOS
 */
#ifndef PLATFORM_MIYOO_H
#define PLATFORM_MIYOO_H

#if defined(TARGET_MIYOO)

struct inp_event;

#ifdef __cplusplus
extern "C" {
#endif

/* Initialize Miyoo Mini platform specifics (signals, exception handlers) */
void miyoo_init(void);

/* Save GameSwitcher screenshot before teardown or on exit signal */
int miyoo_save_screenshot(void);

/* Get isolated writable temp path on SD card to prevent RAM exhaustion */
char *miyoo_game_tmp_path(const char *app);

/* Key event mappings for Miyoo Mini gamepad */
int miyoo_is_key_back(struct inp_event *ev);
int miyoo_is_key_look(struct inp_event *ev);

/* Menu filtering for OnionOS ROM mode */
void miyoo_filter_main_menu(void);

#ifdef __cplusplus
}
#endif

#endif /* TARGET_MIYOO */

#endif /* PLATFORM_MIYOO_H */
