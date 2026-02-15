/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft = 0;    /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;        /* 0 means no systray */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "JetBrainsMono Nerd Font Mono:size=12" };
static const char dmenufont[]       = "JetBrainsMono Nerd Font Mono:size=12";

/* Kanagawa color scheme */
static const char col_bg[]          = "#1F1F28"; /* sumiInk1 */
static const char col_fg[]          = "#DCD7BA"; /* fujiWhite */
static const char col_border[]      = "#223249"; /* waveBlue1 */
static const char col_sel[]         = "#7E9CD8"; /* dragonBlue */
static const char col_urgent[]      = "#C34043"; /* autumnRed */

static const char *colors[][3]      = {
	/*               fg       bg       border   */
	[SchemeNorm] = { col_fg,  col_bg,  col_border },
	[SchemeSel]  = { col_bg,  col_sel, col_sel    },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */
static const int refreshrate = 120;  /* refresh rate (per second) for client move/resize */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_bg, "-nf", col_fg, "-sb", col_sel, "-sf", col_bg, NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *rofi[]     = { "rofi", "-show", "drun", NULL };
static const char *flameshot[] = { "flameshot", "gui", NULL };
static const char *netmgr[]  = { "st", "-e", "nmtui", NULL };
static const char *volmgr[]  = { "pavucontrol", NULL };
static const char *keybinds[] = { "/home/rubyciide/.config/dwm/scripts/keybinds.sh", NULL };
static const char *ctrlcenter[] = { "/home/rubyciide/.config/dwm/scripts/control-center.sh", NULL };
static const char *filemgr[]  = { "kitty", "-e", "yazi", NULL };
static const char *browser[]  = { "chromium", NULL };

#include <X11/XF86keysym.h>

static const Key keys[] = {
	/* modifier                     key        function        argument */

	/* ── Launchers ── */
	{ MODKEY,                       XK_a,      spawn,          {.v = rofi } },
	{ MODKEY|ShiftMask,             XK_a,      spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_n,      spawn,          {.v = netmgr } },
	{ MODKEY,                       XK_v,      spawn,          {.v = volmgr } },
	{ MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY|ShiftMask,             XK_slash,  spawn,          {.v = keybinds } },
	{ MODKEY,                       XK_x,      spawn,          {.v = ctrlcenter } },

	/* ── Apps ── */
	{ MODKEY,                       XK_e,      spawn,          {.v = filemgr } },
	{ MODKEY,                       XK_b,      spawn,          {.v = browser } },

	/* ── Window Management ── */
	{ MODKEY|ShiftMask,             XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY,                       XK_q,      killclient,     {0} },

	/* ── Layouts ── */
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },

	/* ── Tags ── */
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },

	/* ── Monitors ── */
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },

	/* ── Media Keys ── */
	{ 0, XF86XK_AudioRaiseVolume,  spawn, SHCMD("vol=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+%' | head -1 | tr -d '%'); [ \"$vol\" -lt 100 ] && pactl set-sink-volume @DEFAULT_SINK@ +5%; pkill -RTMIN+1 dwmblocks") },
	{ 0, XF86XK_AudioLowerVolume,  spawn, SHCMD("pactl set-sink-volume @DEFAULT_SINK@ -5%; pkill -RTMIN+1 dwmblocks") },
	{ 0, XF86XK_AudioMute,         spawn, SHCMD("pactl set-sink-mute @DEFAULT_SINK@ toggle; pkill -RTMIN+1 dwmblocks") },
	{ 0, XF86XK_MonBrightnessUp,   spawn, SHCMD("brightnessctl s +5%; pkill -RTMIN+2 dwmblocks") },
	{ 0, XF86XK_MonBrightnessDown, spawn, SHCMD("brightnessctl s 5%-; pkill -RTMIN+2 dwmblocks") },
	{ 0, XF86XK_AudioPlay,         spawn, SHCMD("playerctl play-pause") },
	{ 0, XF86XK_AudioNext,         spawn, SHCMD("playerctl next") },
	{ 0, XF86XK_AudioPrev,         spawn, SHCMD("playerctl previous") },
	{ 0,                            XK_Print,  spawn,          {.v = flameshot } },

	/* ── Tag keys ── */
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)

	/* ── Session ── */
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
