#!/usr/bin/env python3
"""Gera o wallpaper Gruvbox Purple usado pelos dotfiles.

Paleta oficial do Gruvbox Dark com destaque em roxo. Saída: PNG RGB.
"""

from __future__ import annotations

import math
import struct
import zlib
from pathlib import Path

WIDTH = 1920
HEIGHT = 1080

BG_TOP = (29, 32, 33)       # #1D2021
BG_BOTTOM = (40, 40, 40)    # #282828
PURPLE = (211, 134, 155)    # #D3869B
PURPLE_DARK = (177, 98, 134)  # #B16286
LINE = (60, 56, 54)         # #3C3836
LINE_SOFT = (80, 73, 69)    # #504945
AQUA = (142, 192, 124)      # #8EC07C
YELLOW = (250, 189, 47)     # #FABD2F


def clamp(value: float) -> int:
    if value < 0:
        return 0
    if value > 255:
        return 255
    return int(value)


def write_png(path: Path, width: int, height: int, rows: list[bytearray]) -> None:
    raw = b"".join(rows)

    def chunk(tag: bytes, data: bytes) -> bytes:
        return (
            struct.pack(">I", len(data))
            + tag
            + data
            + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)
        )

    header = struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)
    png = (
        b"\x89PNG\r\n\x1a\n"
        + chunk(b"IHDR", header)
        + chunk(b"IDAT", zlib.compress(raw, 9))
        + chunk(b"IEND", b"")
    )
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(png)


def main() -> None:
    cx, cy = WIDTH * 0.72, HEIGHT * 0.38
    radius = WIDTH * 0.62
    cx2, cy2 = WIDTH * 0.16, HEIGHT * 0.84
    radius2 = WIDTH * 0.40

    rows: list[bytearray] = []

    for y in range(HEIGHT):
        t = y / (HEIGHT - 1)
        base_r = BG_TOP[0] + (BG_BOTTOM[0] - BG_TOP[0]) * t
        base_g = BG_TOP[1] + (BG_BOTTOM[1] - BG_TOP[1]) * t
        base_b = BG_TOP[2] + (BG_BOTTOM[2] - BG_TOP[2]) * t

        row = bytearray([0])  # filtro PNG: None
        row.extend(b"\x00" * (WIDTH * 3))

        for x in range(WIDTH):
            r, g, b = base_r, base_g, base_b

            # Grade bem discreta
            if x % 120 == 0 or y % 120 == 0:
                a = 0.22
                r = r + (LINE[0] - r) * a
                g = g + (LINE[1] - g) * a
                b = b + (LINE[2] - b) * a

            # Listras diagonais de textura
            if (x + y) % 72 < 2:
                a = 0.16
                r = r + (LINE_SOFT[0] - r) * a
                g = g + (LINE_SOFT[1] - g) * a
                b = b + (LINE_SOFT[2] - b) * a

            # Brilho principal roxo
            dx = x - cx
            dy = y - cy
            dist = math.hypot(dx, dy)
            if dist < radius:
                intensity = 1.0 - dist / radius
                intensity = intensity * intensity * 0.72
                r = r + (PURPLE[0] - r) * intensity
                g = g + (PURPLE[1] - g) * intensity
                b = b + (PURPLE[2] - b) * intensity

            # Anéis concêntricos
            if dist < radius:
                for factor, color, alpha in (
                    (0.48, PURPLE_DARK, 0.65),
                    (0.68, PURPLE, 0.50),
                    (0.86, PURPLE_DARK, 0.40),
                ):
                    if abs(dist - radius * factor) < 1.6:
                        r = r + (color[0] - r) * alpha
                        g = g + (color[1] - g) * alpha
                        b = b + (color[2] - b) * alpha

            # Segundo brilho, mais discreto
            dx2 = x - cx2
            dy2 = y - cy2
            dist2 = math.hypot(dx2, dy2)
            if dist2 < radius2:
                intensity = 1.0 - dist2 / radius2
                intensity = intensity * intensity * 0.42
                r = r + (PURPLE_DARK[0] - r) * intensity
                g = g + (PURPLE_DARK[1] - g) * intensity
                b = b + (PURPLE_DARK[2] - b) * intensity

            # Linhas de "circuito" na diagonal
            for offset, color, alpha in (
                (-0.30 * HEIGHT, PURPLE_DARK, 0.30),
                (0.02 * HEIGHT, LINE_SOFT, 0.45),
                (0.34 * HEIGHT, PURPLE, 0.22),
                (0.66 * HEIGHT, LINE, 0.40),
            ):
                if abs(y - 0.52 * x - offset) < 1.25:
                    r = r + (color[0] - r) * alpha
                    g = g + (color[1] - g) * alpha
                    b = b + (color[2] - b) * alpha

            # Pequenos nós de circuito
            for node_x, node_y, color in (
                (WIDTH * 0.12, HEIGHT * 0.30, AQUA),
                (WIDTH * 0.86, HEIGHT * 0.20, YELLOW),
                (WIDTH * 0.66, HEIGHT * 0.72, PURPLE),
                (WIDTH * 0.28, HEIGHT * 0.62, PURPLE_DARK),
            ):
                ndx = x - node_x
                ndy = y - node_y
                ndist = math.hypot(ndx, ndy)
                if ndist < 3.0:
                    a = 0.85 * (1.0 - ndist / 3.0)
                    r = r + (color[0] - r) * a
                    g = g + (color[1] - g) * a
                    b = b + (color[2] - b) * a

            # Vinheta suave
            vx = (x - WIDTH * 0.5) / (WIDTH * 0.5)
            vy = (y - HEIGHT * 0.5) / (HEIGHT * 0.5)
            vignette = 1.0 - 0.28 * (vx * vx + vy * vy)
            if vignette < 0.68:
                vignette = 0.68

            index = 1 + x * 3
            row[index] = clamp(r * vignette)
            row[index + 1] = clamp(g * vignette)
            row[index + 2] = clamp(b * vignette)

        rows.append(row)

    output = Path(__file__).resolve().parents[1] / "home" / "Pictures" / "Wallpapers" / "gruvbox-purple.png"
    write_png(output, WIDTH, HEIGHT, rows)
    print(f"Wallpaper gerado em {output}")


if __name__ == "__main__":
    main()
