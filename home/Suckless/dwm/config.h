/* See LICENSE file for copyright and license details. */

/* Catppuccin Mocha */
static const unsigned int borderpx  = 2;        /* borda das janelas */
static const unsigned int snap      = 32;
static const unsigned int gappih    = 12;       /* gap horizontal interno */
static const unsigned int gappiv    = 12;       /* gap vertical interno */
static const unsigned int gappoh    = 12;       /* gap horizontal externo */
static const unsigned int gappov    = 12;       /* gap vertical externo */
static       int smartgaps          = 0;        /* 1 = sem gap externo com uma janela só */
static const int showbar            = 1;
static const int topbar             = 1;
static const char *fonts[]          = {
	"JetBrainsMono Nerd Font:size=10:antialias=true",
	"Symbols Nerd Font:size=11:antialias=true",
};
static const char dmenufont[]       = "JetBrainsMono Nerd Font:size=10";

static const char col_base[]        = "#1e1e2e";
static const char col_mantle[]      = "#181825";
static const char col_surface0[]    = "#313244";
static const char col_surface1[]    = "#45475a";
static const char col_overlay0[]    = "#6c7086";
static const char col_text[]        = "#cdd6f4";
static const char col_mauve[]       = "#cba6f7";
static const char col_pink[]        = "#f5c2e7";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_text,  col_base,  col_surface1 },
	[SchemeSel]  = { col_base,  col_mauve, col_mauve },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5" };

static const Rule rules[] = {
	/* class                instance    title       tags mask  isfloating  monitor */
	{ "Gimp",               NULL,       NULL,       0,         1,          -1 },
	{ "Pavucontrol",        NULL,       NULL,       0,         1,          -1 },
	{ "Nm-connection-editor", NULL,     NULL,       0,         1,          -1 },
	{ "feh",                NULL,       NULL,       0,         1,          -1 },
	{ "Qemu-system-i386",   NULL,       NULL,       0,         1,          -1 },
};

/* layout(s) */
static const float mfact     = 0.52; /* mesmo split_ratio usado no bspwm */
static const int nmaster     = 1;
static const int resizehints = 0;    /* gaps uniformes */
static const int lockfullscreen = 1;

#define FORCE_VSPLIT 1
#include "vanitygaps.c"
#include "dwm-dir.c"

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "(@)",      spiral },     /* layout padrão: fibonacci */
	{ "[\\]",     dwindle },
	{ "[]=",      tile },
	{ "[M]",      monocle },
	{ "><>",      NULL },       /* floating */
	{ NULL,       NULL },
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} },

/* commands */
static char dmenumon[2] = "0"; /* componente de dmenucmd, manipulado por spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_base, "-nf", col_text, "-sb", col_mauve, "-sf", col_base, NULL };
static const char *termcmd[]  = { "st", NULL };

static const Key keys[] = {
	/* modifier                     key        function        argument */

	/* terminal / launcher */
	{ MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },

	/* sessão */
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
	{ MODKEY,                       XK_q,      killclient,     {0} },

	/* tags */
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },

	/* foco direcional: h=oeste, j=sul, k=norte, l=leste */
	{ MODKEY,                       XK_h,      focusdir,       {.i = DirWest } },
	{ MODKEY,                       XK_j,      focusdir,       {.i = DirSouth } },
	{ MODKEY,                       XK_k,      focusdir,       {.i = DirNorth } },
	{ MODKEY,                       XK_l,      focusdir,       {.i = DirEast } },

	/* mover janela na direção */
	{ MODKEY|ShiftMask,             XK_h,      movewin,        {.i = DirWest } },
	{ MODKEY|ShiftMask,             XK_j,      movewin,        {.i = DirSouth } },
	{ MODKEY|ShiftMask,             XK_k,      movewin,        {.i = DirNorth } },
	{ MODKEY|ShiftMask,             XK_l,      movewin,        {.i = DirEast } },

	/* redimensionar janela na direção */
	{ MODKEY|ControlMask,           XK_h,      resizewin,      {.i = DirWest } },
	{ MODKEY|ControlMask,           XK_j,      resizewin,      {.i = DirSouth } },
	{ MODKEY|ControlMask,           XK_k,      resizewin,      {.i = DirNorth } },
	{ MODKEY|ControlMask,           XK_l,      resizewin,      {.i = DirEast } },

	/* layouts e janelas flutuantes */
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY|ShiftMask,             XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[3]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[4]} },

	/* gaps */
	{ MODKEY|ShiftMask,             XK_g,      togglegaps,     {0} },
	{ MODKEY|ShiftMask|ControlMask, XK_g,      defaultgaps,    {0} },
};

/* button definitions */
/* click pode ser ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin ou ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[4]} },
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
