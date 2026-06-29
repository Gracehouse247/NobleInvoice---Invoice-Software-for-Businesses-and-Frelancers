/**
 * Image processing utility for background removal and image trimming.
 * Mirroring the logic from the mobile app's ImageProcessingService.
 */

export async function removeImageBackground(file: File): Promise<string | null> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = (e) => {
      const img = new Image();
      img.onload = () => {
        const canvas = document.createElement('canvas');
        const ctx = canvas.getContext('2d');
        if (!ctx) return resolve(null);

        canvas.width = img.width;
        canvas.height = img.height;
        ctx.drawImage(img, 0, 0);

        const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
        const data = imageData.data;

        // 1. Identify Background Color (Sample corners)
        const corners = [
          getPixel(data, 0, 0, canvas.width),
          getPixel(data, canvas.width - 1, 0, canvas.width),
          getPixel(data, 0, canvas.height - 1, canvas.width),
          getPixel(data, canvas.width - 1, canvas.height - 1, canvas.width),
        ];

        // Find the most frequent color among corners
        const colorCounts: Record<string, number> = {};
        corners.forEach(c => {
          const key = `${c.r},${c.g},${c.b}`;
          colorCounts[key] = (colorCounts[key] || 0) + 1;
        });

        const bgColorStr = Object.entries(colorCounts).reduce((a, b) => a[1] > b[1] ? a : b)[0];
        const [bgR, bgG, bgB] = bgColorStr.split(',').map(Number);

        // 2. Apply Transparency with Soft Edges
        const tolerance = 45; // Primary threshold
        const feather = 15; // Smooth transition zone

        for (let i = 0; i < data.length; i += 4) {
          const r = data[i];
          const g = data[i + 1];
          const b = data[i + 2];
          const a = data[i + 3];

          if (a === 0) continue;

          const dr = Math.abs(r - bgR);
          const dg = Math.abs(g - bgG);
          const db = Math.abs(b - bgB);
          const diff = (dr + dg + db) / 3;

          if (diff < tolerance) {
            if (diff < (tolerance - feather)) {
              // Fully transparent
              data[i + 3] = 0;
            } else {
              // Gradual transparency (Feathering)
              const ratio = (diff - (tolerance - feather)) / feather;
              data[i + 3] = Math.floor(ratio * 255);
            }
          }
        }

        ctx.putImageData(imageData, 0, 0);

        // 3. Trim and return
        const trimmedCanvas = trimCanvas(canvas);
        resolve(trimmedCanvas.toDataURL('image/png'));
      };
      img.onerror = () => resolve(null);
      img.src = e.target?.result as string;
    };
    reader.onerror = () => resolve(null);
    reader.readAsDataURL(file);
  });
}

function getPixel(data: Uint8ClampedArray, x: number, y: number, width: number) {
  const i = (y * width + x) * 4;
  return { r: data[i], g: data[i + 1], b: data[i + 2], a: data[i + 3] };
}

function trimCanvas(canvas: HTMLCanvasElement): HTMLCanvasElement {
  const ctx = canvas.getContext('2d');
  if (!ctx) return canvas;

  const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
  const data = imageData.data;
  const width = canvas.width;
  const height = canvas.height;

  let top = 0, bottom = height - 1, left = 0, right = width - 1;

  // Top
  for (let y = 0; y < height; y++) {
    let hasPixel = false;
    for (let x = 0; x < width; x++) {
      if (data[(y * width + x) * 4 + 3] > 0) {
        hasPixel = true;
        break;
      }
    }
    if (hasPixel) {
      top = y;
      break;
    }
  }

  // Bottom
  for (let y = height - 1; y >= 0; y--) {
    let hasPixel = false;
    for (let x = 0; x < width; x++) {
      if (data[(y * width + x) * 4 + 3] > 0) {
        hasPixel = true;
        break;
      }
    }
    if (hasPixel) {
      bottom = y;
      break;
    }
  }

  // Left
  for (let x = 0; x < width; x++) {
    let hasPixel = false;
    for (let y = 0; y < height; y++) {
      if (data[(y * width + x) * 4 + 3] > 0) {
        hasPixel = true;
        break;
      }
    }
    if (hasPixel) {
      left = x;
      break;
    }
  }

  // Right
  for (let x = width - 1; x >= 0; x--) {
    let hasPixel = false;
    for (let y = 0; y < height; y++) {
      if (data[(y * width + x) * 4 + 3] > 0) {
        hasPixel = true;
        break;
      }
    }
    if (hasPixel) {
      right = x;
      break;
    }
  }

  const trimWidth = right - left + 1;
  const trimHeight = bottom - top + 1;

  if (trimWidth <= 0 || trimHeight <= 0) return canvas;

  const trimmedCanvas = document.createElement('canvas');
  trimmedCanvas.width = trimWidth;
  trimmedCanvas.height = trimHeight;
  const trimmedCtx = trimmedCanvas.getContext('2d');
  if (!trimmedCtx) return canvas;

  trimmedCtx.drawImage(canvas, left, top, trimWidth, trimHeight, 0, 0, trimWidth, trimHeight);
  return trimmedCanvas;
}
