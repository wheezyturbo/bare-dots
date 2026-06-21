/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
static int centered = 1;                    /* -c option; centers dmenu on screen */
static int min_width = 600;                 /* minimum width when centered */
static const float menu_height_ratio = 3.0f;/* vertical position ratio (lower = higher) */
static const unsigned int alpha = 0xe0;     /* Amount of opacity. 0xff is opaque (~88%)  */

/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
	"JetBrainsMono Nerd Font Mono:size=13"
};
static const char *prompt      = NULL;      /* -p  option; prompt to the left of input field */

/*
 * ── Kanagawa Color Scheme (refined) ──
 *
 * Philosophy: selection is a subtle bg shift + accent text color.
 * No garish inverted bars. Highlights use complementary accents
 * that create visual hierarchy without clashing.
 */
static const char *colors[SchemeLast][2] = {
	/*                        fg         bg       */
	[SchemeNorm]          = { "#DCD7BA", "#1F1F28" },  /* fujiWhite on sumiInk1     */
	[SchemeSel]           = { "#7E9CD8", "#2A2A37" },  /* crystalBlue on sumiInk3   */
	[SchemeNormHighlight] = { "#FF9E3B", "#1F1F28" },  /* surimiOrange on sumiInk1  */
	[SchemeSelHighlight]  = { "#FF9E3B", "#2A2A37" },  /* surimiOrange on sumiInk3  */
	[SchemeOut]           = { "#98BB6C", "#1F1F28" },  /* springGreen on sumiInk1   */
};

static const unsigned int alphas[SchemeLast][2] = {
	[SchemeNorm]          = { OPAQUE, alpha },
	[SchemeSel]           = { OPAQUE, alpha },
	[SchemeNormHighlight] = { OPAQUE, alpha },
	[SchemeSelHighlight]  = { OPAQUE, alpha },
	[SchemeOut]           = { OPAQUE, alpha },
};

/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 10;

/* -h option; minimum height of a menu line */
static unsigned int lineheight = 40;
static unsigned int min_lineheight = 8;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";

/* Size of the window border */
static unsigned int border_width = 2;
