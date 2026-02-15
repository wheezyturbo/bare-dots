//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	{"",		"$HOME/.config/dwmblocks/scripts/sb-cpu",		5,		0},
	{"",		"$HOME/.config/dwmblocks/scripts/sb-memory",		10,		0},
	{"",		"$HOME/.config/dwmblocks/scripts/sb-disk",		300,		0},
	{"",		"$HOME/.config/dwmblocks/scripts/sb-network",		5,		4},
	{"",		"$HOME/.config/dwmblocks/scripts/sb-bluetooth",		0,		5},
	{"",		"$HOME/.config/dwmblocks/scripts/sb-brightness",	0,		2},
	{"",		"$HOME/.config/dwmblocks/scripts/sb-volume",		0,		1},
	{"",		"$HOME/.config/dwmblocks/scripts/sb-battery",		30,		3},
	{"",		"$HOME/.config/dwmblocks/scripts/sb-datetime",		60,		0},
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = "  ";
static unsigned int delimLen = 5;
