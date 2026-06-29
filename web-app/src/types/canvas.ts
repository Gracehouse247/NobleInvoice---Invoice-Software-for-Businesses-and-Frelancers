export type ElementType = 'text' | 'image' | 'shape' | 'svg';

export interface CanvasElement {
  id: string;
  type: ElementType;
  x: number;
  y: number;
  width?: number;
  height?: number;
  rotation?: number;
  
  // Text specific
  text?: string;
  fontFamily?: string;
  fontSize?: number;
  fill?: string;
  fontWeight?: string | number;
  letterSpacing?: number;
  textAlign?: 'left' | 'center' | 'right';
  
  // Shape/SVG specific
  url?: string;
  stroke?: string;
  strokeWidth?: number;
  cornerRadius?: number | number[];
  customSvgPath?: string;
  viewBox?: string;
  
  // Bounding styling: Shadows and clip masking
  shadowColor?: string;
  shadowBlur?: number;
  shadowOffsetX?: number;
  shadowOffsetY?: number;
  shadowOpacity?: number;
  clipType?: 'none' | 'circle' | 'square';
}

export interface CanvasTemplate {
  id: string;
  name: string;
  width: number;
  height: number;
  background: string;
  elements: CanvasElement[];
}
