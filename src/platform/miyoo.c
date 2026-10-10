/*
 * platform/miyoo.c - Platform integration implementation for Miyoo Mini / OnionOS
 */
#if defined(TARGET_MIYOO)

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <execinfo.h>
#include <ucontext.h>
#include <limits.h>

#include "externals.h"
#include "internals.h"
#include "platform/miyoo.h"

static volatile sig_atomic_t s_screenshot_taken = 0;

static void crash_handler(int sig, siginfo_t *info, void *ucontext)
{
	void *bt[32];
	int nptrs;
	fprintf(stderr, "\n*** CRASH: Caught signal %d (%s) at address %p ***\n",
		sig, (sig == SIGSEGV) ? "SIGSEGV" : ((sig == SIGBUS) ? "SIGBUS" : "UNKNOWN"),
		info ? info->si_addr : NULL);
#ifdef __arm__
	if (ucontext) {
		ucontext_t *uc = (ucontext_t *)ucontext;
		fprintf(stderr, "ARM REGISTERS: PC=%p, LR=%p, SP=%p, CPSR=0x%lx\n",
			(void*)uc->uc_mcontext.arm_pc,
			(void*)uc->uc_mcontext.arm_lr,
			(void*)uc->uc_mcontext.arm_sp,
			(unsigned long)uc->uc_mcontext.arm_cpsr);
	}
#endif
	fflush(stderr);
	nptrs = backtrace(bt, 32);
	fprintf(stderr, "=== BACKTRACE (%d frames) ===\n", nptrs);
	backtrace_symbols_fd(bt, nptrs, 2);
	fprintf(stderr, "=== MEMORY MAPS ===\n");
	FILE *f = fopen("/proc/self/maps", "r");
	if (f) {
		char line[256];
		while (fgets(line, sizeof(line), f)) {
			fputs(line, stderr);
		}
		fclose(f);
	}
	fflush(stderr);
	_exit(128 + sig);
}

static void term_handler(int sig)
{
	/* Best-effort emergency screenshot dump before termination */
	fprintf(stderr, "\n[GameSwitcher] Caught signal %d (%s), saving emergency snapshot...\n",
		sig, (sig == SIGTERM) ? "SIGTERM" : ((sig == SIGINT) ? "SIGINT" : "UNKNOWN"));
	miyoo_save_screenshot();
	_exit(128 + sig);
}

void miyoo_init(void)
{
	struct sigaction sa;
	memset(&sa, 0, sizeof(sa));
	sa.sa_flags = SA_SIGINFO;
	sa.sa_sigaction = crash_handler;
	sigaction(SIGSEGV, &sa, NULL);
	sigaction(SIGBUS, &sa, NULL);
	sigaction(SIGILL, &sa, NULL);
	sigaction(SIGFPE, &sa, NULL);

	struct sigaction st;
	memset(&st, 0, sizeof(st));
	st.sa_handler = term_handler;
	sigaction(SIGTERM, &st, NULL);
	sigaction(SIGINT, &st, NULL);
}

int miyoo_save_screenshot(void)
{
	if (s_screenshot_taken)
		return 0;

	const char *env_path = getenv("GAMESWITCHER_PATH");
	const char *path = (env_path && *env_path) ? env_path : "/tmp/screenshot.png";

	int ret = gfx_save_screen_png(path);
	if (ret != 0) {
		fprintf(stderr, "[GameSwitcher] Failed to save screenshot to %s\n", path);
		return -1;
	}

	s_screenshot_taken = 1;
	fprintf(stderr, "[GameSwitcher] Successfully saved %s\n", path);
	return 0;
}

char *miyoo_game_tmp_path(const char *app)
{
	static char tmp[PATH_MAX];
	if (!app || !*app)
		return NULL;

	snprintf(tmp, sizeof(tmp), "%s/tmp", app);
	mkdir(tmp, 0755);
	return tmp;
}

int miyoo_is_key_back(struct inp_event *ev)
{
	if (!ev || !ev->sym)
		return 0;
	/* On Miyoo Mini:
	 * X button (Left Shift) and Y button (Left Alt) perform cancel/back */
	return (!strcmp(ev->sym, "left shift") || !strcmp(ev->sym, "left alt"));
}

int miyoo_is_key_look(struct inp_event *ev)
{
	if (!ev || !ev->sym)
		return 0;
	/* On Miyoo Mini: R2 button (Backspace) triggers Look action */
	return !strcmp(ev->sym, "backspace");
}

void miyoo_filter_main_menu(void)
{
	/* Menu filtering is handled in menu.c via menu_strip_tag */
}

#endif /* TARGET_MIYOO */
