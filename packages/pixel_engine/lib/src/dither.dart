/// Geordnetes Dithering (Bayer 4×4). Werte 0..15.
const List<int> bayer4 = [
  0, 8, 2, 10, //
  12, 4, 14, 6,
  3, 11, 1, 9,
  15, 7, 13, 5,
];

/// Schwelle in [-0.5, 0.5) für Pixel (x, y).
double bayerOffset(int x, int y) => (bayer4[((y & 3) << 2) | (x & 3)] + 0.5) / 16.0 - 0.5;
