void
fibonacci(Monitor *mon, int s) {
	unsigned int i, n, nx, ny, nw, nh;
	unsigned int oe = enablegaps, ie = enablegaps;
	Client *c;

	for(n = 0, c = nexttiled(mon->clients); c; c = nexttiled(c->next), n++);
	if(n == 0)
		return;

	/* Lógica de Smart Gaps idêntica ao seu tile */
	if (smartgaps == n) {
		oe = 0; 
	}

	nx = mon->wx + mon->gappov * oe;
	ny = mon->wy + mon->gappoh * oe;
	nw = mon->ww - 2 * mon->gappov * oe;
	nh = mon->wh - 2 * mon->gappoh * oe;

	for(i = 0, c = nexttiled(mon->clients); c; c = nexttiled(c->next)) {
		if((i % 2 && nh / 2 > 2 * c->bw)
		   || (!(i % 2) && nw / 2 > 2 * c->bw)) {
			if(i < n - 1) {
				if(i % 2) {
					nh = (nh - mon->gappih * ie) / 2;
				} else {
					nw = (nw - mon->gappiv * ie) / 2;
				}

				if((i % 4) == 2 && !s)
					nx += nw + mon->gappiv * ie;
				else if((i % 4) == 3 && !s)
					ny += nh + mon->gappih * ie;
			}
			if((i % 4) == 0) {
				if(s) ny += nh + mon->gappih * ie;
				else  ny -= nh + mon->gappih * ie;
			}
			else if((i % 4) == 1) nx += nw + mon->gappiv * ie;
			else if((i % 4) == 2) ny += nh + mon->gappih * ie;
			else if((i % 4) == 3) {
				if(s) nx += nw + mon->gappiv * ie;
				else  nx -= nw + mon->gappiv * ie;
			}

			if(i == 0) {
				if(n != 1)
					nw = (mon->ww - 2 * mon->gappov * oe - mon->gappiv * ie) * mon->mfact;
				ny = mon->wy + mon->gappoh * oe;
			}
			else if(i == 1)
				nw = mon->ww - nw - mon->gappiv * ie - 2 * mon->gappov * oe;
			i++;
		}
		resize(c, nx, ny, nw - 2 * c->bw, nh - 2 * c->bw, False);
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
