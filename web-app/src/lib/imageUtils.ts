/**
 * Converts an uploaded image file to WebP format for faster loading and less storage.
 * @param file The original image file
 * @param quality Compression quality (0.0 to 1.0)
 * @returns A Promise that resolves to the new WebP File, or the original file if it's not an image.
 */
export async function convertToWebP(file: File, quality = 0.8): Promise<File> {
    if (!file.type.startsWith('image/') || file.type === 'image/webp' || file.type === 'image/svg+xml' || file.type === 'image/gif') {
        // Skip conversion if not an image, or if it's already webp, svg, or gif (animated)
        return file;
    }

    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = (event) => {
            const img = new Image();
            img.src = event.target?.result as string;
            img.onload = () => {
                // Create a canvas element
                const canvas = document.createElement('canvas');
                const ctx = canvas.getContext('2d');
                if (!ctx) {
                    resolve(file); // fallback
                    return;
                }

                // Set canvas dimensions
                canvas.width = img.width;
                canvas.height = img.height;

                // Draw image on canvas
                ctx.drawImage(img, 0, 0);

                // Convert canvas to WebP Blob
                canvas.toBlob(
                    (blob) => {
                        if (blob) {
                            // Create a new File object
                            const newFileName = file.name.replace(/\.[^/.]+$/, "") + ".webp";
                            const webpFile = new File([blob], newFileName, {
                                type: 'image/webp',
                                lastModified: Date.now(),
                            });
                            resolve(webpFile);
                        } else {
                            resolve(file); // fallback
                        }
                    },
                    'image/webp',
                    quality
                );
            };
            img.onerror = () => resolve(file); // fallback on error
        };
        reader.onerror = () => resolve(file);
    });
}
