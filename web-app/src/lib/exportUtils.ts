import html2canvas from 'html2canvas';
import jsPDF from 'jspdf';

/**
 * Captures an HTML element and downloads it as an Image (PNG).
 * @param elementId The ID of the HTML element to capture.
 * @param filename The desired filename (without extension).
 */
export const downloadAsImage = async (elementId: string, filename: string) => {
  const element = document.getElementById(elementId);
  if (!element) return;

  try {
    const canvas = await html2canvas(element, {
      scale: 2, // High resolution
      useCORS: true, // Allow loading cross-origin images (like external logos)
      logging: false,
    });

    const dataUrl = canvas.toDataURL('image/png');
    
    const link = document.createElement('a');
    link.download = `${filename}.png`;
    link.href = dataUrl;
    link.click();
  } catch (error) {
    console.error('Failed to export image:', error);
    throw error;
  }
};

/**
 * Captures an HTML element and downloads it as a PDF.
 * @param elementId The ID of the HTML element to capture.
 * @param filename The desired filename (without extension).
 */
export const downloadAsPDF = async (elementId: string, filename: string) => {
  const element = document.getElementById(elementId);
  if (!element) return;

  try {
    const canvas = await html2canvas(element, {
      scale: 2, // High resolution for sharp text
      useCORS: true,
      logging: false,
    });

    const imgData = canvas.toDataURL('image/jpeg', 1.0);
    
    // Calculate A4 dimensions
    const pdf = new jsPDF({
      orientation: 'portrait',
      unit: 'mm',
      format: 'a4',
    });

    const pdfWidth = pdf.internal.pageSize.getWidth();
    const pdfHeight = (canvas.height * pdfWidth) / canvas.width;

    // If the invoice is very long, it might overflow the A4 page height.
    // For standard invoices, we just place it. 
    pdf.addImage(imgData, 'JPEG', 0, 0, pdfWidth, pdfHeight);
    
    pdf.save(`${filename}.pdf`);
  } catch (error) {
    console.error('Failed to export PDF:', error);
    throw error;
  }
};

/**
 * Captures an HTML element and triggers the native share dialog (if supported).
 * @param elementId The ID of the HTML element to capture.
 * @param filename The desired filename (without extension).
 * @param title The title for the share dialog.
 */
export const shareInvoice = async (elementId: string, filename: string, title: string) => {
  const element = document.getElementById(elementId);
  if (!element) return;

  try {
    const canvas = await html2canvas(element, {
      scale: 2,
      useCORS: true,
      logging: false,
    });

    canvas.toBlob(async (blob) => {
      if (!blob) return;

      const file = new File([blob], `${filename}.png`, { type: 'image/png' });
      
      if (navigator.canShare && navigator.canShare({ files: [file] })) {
        try {
          await navigator.share({
            title: title,
            text: 'Here is your invoice',
            files: [file],
          });
        } catch (shareError) {
          console.error('Error sharing:', shareError);
        }
      } else {
        // Fallback to download if sharing is not supported
        const dataUrl = canvas.toDataURL('image/png');
        const link = document.createElement('a');
        link.download = `${filename}.png`;
        link.href = dataUrl;
        link.click();
      }
    }, 'image/png');
  } catch (error) {
    console.error('Failed to share:', error);
    throw error;
  }
};
/**
 * Specialized utility for exporting business cards in high fidelity (300 DPI).
 * Supports dual-sided PNG or PDF.
 */
export const downloadBusinessCard = async (
  frontId: string, 
  backId: string, 
  filename: string, 
  format: 'png' | 'pdf' = 'png'
) => {
  const front = document.getElementById(frontId);
  const back = document.getElementById(backId);
  
  if (!front) {
    console.error('Front side element not found');
    return;
  }

  try {
    const options = {
      scale: 1, // Already at 1050x600 (300DPI)
      useCORS: true,
      logging: false,
      backgroundColor: null, // Preserve transparency if needed
    };

    const frontCanvas = await html2canvas(front, options);
    
    if (format === 'png') {
      // Download Front
      const frontLink = document.createElement('a');
      frontLink.download = `${filename}_front.png`;
      frontLink.href = frontCanvas.toDataURL('image/png', 1.0);
      frontLink.click();

      // Download Back if exists
      if (back) {
        const backCanvas = await html2canvas(back, options);
        const backLink = document.createElement('a');
        backLink.download = `${filename}_back.png`;
        backLink.href = backCanvas.toDataURL('image/png', 1.0);
        backLink.click();
      }
    } else {
      // PDF Export (3.5in x 2in)
      const pdf = new jsPDF({
        orientation: 'landscape',
        unit: 'in',
        format: [3.5, 2]
      });

      pdf.addImage(frontCanvas.toDataURL('image/jpeg', 1.0), 'JPEG', 0, 0, 3.5, 2);
      
      if (back) {
        const backCanvas = await html2canvas(back, options);
        pdf.addPage([3.5, 2], 'landscape');
        pdf.addImage(backCanvas.toDataURL('image/jpeg', 1.0), 'JPEG', 0, 0, 3.5, 2);
      }

      pdf.save(`${filename}.pdf`);
    }
  } catch (error) {
    console.error('Failed to export business card:', error);
    throw error;
  }
};
