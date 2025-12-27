void
fibonacci(Monitor *mon, int s) {
	unsigned int i, n, nx, ny, nw, nh;
	unsigned int oe, ie;
	Client *c;
	
	for(n = 0, c = nexttiled(mon->clients); c; c = nexttiled(c->next), n++);
	if(n == 0)
		return;
	
	oe = ie = enablegaps;
	if(smartgaps && n == 1)
		oe = ie = 0;
	
	nx = mon->wx + mon->gappov*oe;
	ny = mon->wy + mon->gappoh*oe;
	nw = mon->ww - 2*mon->gappov*oe;
	nh = mon->wh - 2*mon->gappoh*oe;
	
	for(i = 0, c = nexttiled(mon->clients); c; c = nexttiled(c->next)) {
		if((i % 2 && nh / 2 > 2 * c->bw)
		   || (!(i % 2) && nw / 2 > 2 * c->bw)) {
			if(i < n - 1) {
				if(i % 2)
					nh /= 2;
				else
					nw /= 2;
				if((i % 4) == 2 && !s)
					nx += nw;
				else if((i % 4) == 3 && !s)
					ny += nh;
			}
			if((i % 4) == 0) {
				if(s)
					ny += nh;
				else
					ny -= nh;
			} else if((i % 4) == 1)
				nx += nw;
			else if((i % 4) == 2)
				ny += nh;
			else if((i % 4) == 3) {
				if(s)
					nx += nw;
				else
					nx -= nw;
			}
			if(i == 0) {
				if(n != 1)
					nw = (mon->ww - 2*mon->gappov*oe) * mon->mfact;
				ny = mon->wy + mon->gappoh*oe;
			} else if(i == 1)
				nw = mon->ww - nw - 2*mon->gappov*oe;  
			i++;
		}
		resize(c, nx, ny, nw - 2 * c->bw - mon->gappiv*ie,
		           nh - 2 * c->bw - mon->gappih*ie, False);
	}
}

void
dwindle(Monitor *mon) {
	fibonacci(mon, 1);
}

void
spiral(Monitor *mon) {
	fibonacci(mon, 0);
}
