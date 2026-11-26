// Status do dwm via dwmblocks.
// Cada bloco usa a sintaxe do patch status2d:
//   ^b#RRGGBB^ = fundo, ^c#RRGGBB^ = texto, ^d^ = volta ao normal.
// O foreground escuro é o "crust" do Catppuccin (#11111b).
static const Block blocks[] = {
	/*Ícone*/                               /*Comando*/                                      /*Intervalo*/	/*Sinal*/
	{"^b#cba6f7^^c#11111b^ ",               "$HOME/.config/dwmblocks/scripts/time.sh",        5,		0},
	{"^b#a6e3a1^^c#11111b^ ",               "$HOME/.config/dwmblocks/scripts/cpu.sh",         5,		0},
	{"^b#89b4fa^^c#11111b^ ",               "$HOME/.config/dwmblocks/scripts/memory.sh",      10,		0},
	{"^b#f9e2af^^c#11111b^ ",               "$HOME/.config/dwmblocks/scripts/volume.sh",      10,		0},
	{"^b#94e2d5^^c#11111b^ ",               "$HOME/.config/dwmblocks/scripts/network.sh",     10,		0},
	{"^b#fab387^^c#11111b^ ",               "$HOME/.config/dwmblocks/scripts/battery.sh",     20,		0},
};

// Cada script termina com um espaço na cor do bloco; o delim só volta
// às cores normais da barra antes do próximo bloco.
static char delim[] = "^d^";
static unsigned int delimLen = sizeof(delim);
