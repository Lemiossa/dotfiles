/* Navegação/movimentação/redimensionamento direcional para o dwm.
 *
 * Mantém os atalhos h/j/k/l usados anteriormente no sxhkd:
 *   h = oeste, j = sul, k = norte, l = leste.
 *
 * Janelas flutuantes são movidas/redimensionadas em passos de 20 px.
 * Janelas em layout são trocadas de posição no arranjo (mover) ou ajustam
 * mfact/nmaster (redimensionar).
 *
 * Incluído por config.h; usa as variáveis estáticas do dwm.c.
 */

enum { DirWest, DirSouth, DirNorth, DirEast };

static Client *
dirnext(Client *c, int dir)
{
	Client *i, *best = NULL;
	int bestscore = 0x7fffffff;
	int dx, dy, primary, secondary, score;

	if (!c)
		return NULL;

	for (i = selmon->clients; i; i = i->next) {
		if (i == c || !ISVISIBLE(i))
			continue;

		dx = (i->x + i->w / 2) - (c->x + c->w / 2);
		dy = (i->y + i->h / 2) - (c->y + c->h / 2);

		switch (dir) {
		case DirWest:
			if (dx >= 0)
				continue;
			primary = -dx;
			secondary = dy < 0 ? -dy : dy;
			break;
		case DirEast:
			if (dx <= 0)
				continue;
			primary = dx;
			secondary = dy < 0 ? -dy : dy;
			break;
		case DirNorth:
			if (dy >= 0)
				continue;
			primary = -dy;
			secondary = dx < 0 ? -dx : dx;
			break;
		case DirSouth:
		default:
			if (dy <= 0)
				continue;
			primary = dy;
			secondary = dx < 0 ? -dx : dx;
			break;
		}

		score = primary + 2 * secondary;
		if (score < bestscore) {
			bestscore = score;
			best = i;
		}
	}

	return best;
}

static void
focusdir(const Arg *arg)
{
	Client *c = selmon->sel, *n;

	if (!c || (c->isfullscreen && lockfullscreen))
		return;
	if ((n = dirnext(c, arg->i))) {
		focus(n);
		restack(selmon);
	}
}

static void
swapclients(Client *a, Client *b)
{
	Client **pa = &selmon->clients, **pb = &selmon->clients, *tmp;

	if (!a || !b || a == b)
		return;
	while (*pa && *pa != a)
		pa = &(*pa)->next;
	while (*pb && *pb != b)
		pb = &(*pb)->next;
	if (!*pa || !*pb)
		return;

	tmp = *pa;
	*pa = *pb;
	*pb = tmp;
}

static void
movewin(const Arg *arg)
{
	Client *c = selmon->sel, *n;
	int dx = 0, dy = 0;

	if (!c || (c->isfullscreen && lockfullscreen))
		return;

	if (c->isfloating) {
		switch (arg->i) {
		case DirWest:  dx = -20; break;
		case DirEast:  dx =  20; break;
		case DirNorth: dy = -20; break;
		case DirSouth: dy =  20; break;
		}
		resizeclient(c, c->x + dx, c->y + dy, c->w, c->h);
		return;
	}

	if ((n = dirnext(c, arg->i))) {
		swapclients(c, n);
		arrange(selmon);
		focus(c);
		restack(selmon);
	}
}

static void
resizewin(const Arg *arg)
{
	Client *c = selmon->sel;
	Arg a = {0};
	int dw = 0, dh = 0;

	if (!c || (c->isfullscreen && lockfullscreen))
		return;

	if (c->isfloating) {
		switch (arg->i) {
		case DirWest:  dw = -20; break;
		case DirEast:  dw =  20; break;
		case DirNorth: dh = -20; break;
		case DirSouth: dh =  20; break;
		}
		resizeclient(c, c->x, c->y,
			MAX(1, c->w + dw), MAX(1, c->h + dh));
		return;
	}

	switch (arg->i) {
	case DirWest:  a.f = -0.05; setmfact(&a); break;
	case DirEast:  a.f =  0.05; setmfact(&a); break;
	case DirNorth: a.i = -1; incnmaster(&a); break;
	case DirSouth: a.i =  1; incnmaster(&a); break;
	}
}
