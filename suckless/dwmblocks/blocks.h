//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	{"", "$HOME/.config/dwmblocks/disk.sh", 30, 0},
	{"", "$HOME/.config/dwmblocks/cpu.sh", 5, 0},
	{"", "$HOME/.config/dwmblocks/ram.sh", 5, 0},
	{"", "$HOME/.config/dwmblocks/wifi.sh", 5, 0},
	{"", "$HOME/.config/dwmblocks/vol.sh", 5, 0},
	{"", "$HOME/.config/dwmblocks/battery.sh", 10, 0},
	{"", "$HOME/.config/dwmblocks/date.sh", 60, 0},
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = "  ";
static unsigned int delimLen = 5;
