// Status do dwm via dwmblocks.
// As cores usam a sintaxe do patch status2d (^c#RRGGBB^ ... ^d^).
static const Block blocks[] = {
	/*Ícone*/	/*Comando*/						/*Intervalo*/	/*Sinal*/
	{"", "$HOME/.config/dwmblocks/scripts/date.sh",		60,		0},
	{"", "$HOME/.config/dwmblocks/scripts/time.sh",		5,		0},
	{"", "$HOME/.config/dwmblocks/scripts/cpu.sh",		5,		0},
	{"", "$HOME/.config/dwmblocks/scripts/memory.sh",	10,		0},
	{"", "$HOME/.config/dwmblocks/scripts/volume.sh",	10,		0},
	{"", "$HOME/.config/dwmblocks/scripts/wifi.sh",		10,		0},
	{"", "$HOME/.config/dwmblocks/scripts/battery.sh",	20,		0},
};

// ^d^ volta às cores normais antes do separador.
static char delim[] = "^d^  ";
static unsigned int delimLen = 6;
