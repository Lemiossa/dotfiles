//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/		/*Command*/			/*Update Interval*/	/*Update Signal*/
	{"", "$HOME/.dwm/blocks/mem.sh",	30,			0},
	{"", "$HOME/.dwm/blocks/cpu.sh",	 2,			0},
	{"", "$HOME/.dwm/blocks/disk.sh",	60,			0},
	{"", "$HOME/.dwm/blocks/vol.sh",	 1,			0},
	{"", "$HOME/.dwm/blocks/date.sh",	 5,			0},
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 3;
