import { create } from 'zustand';
import { CanvasElement, CanvasTemplate } from '../types/canvas';

interface CanvasState {
  template: CanvasTemplate | null;
  selectedElementId: string | null;
  stageRef: any | null;
  
  // Actions
  loadTemplate: (template: CanvasTemplate) => void;
  selectElement: (id: string | null) => void;
  updateElement: (id: string, updates: Partial<CanvasElement>) => void;
  updateBackground: (color: string) => void;
  addElement: (element: CanvasElement) => void;
  removeElement: (id: string) => void;
  setStageRef: (ref: any) => void;
}

export const useCanvasStore = create<CanvasState>((set) => ({
  template: null,
  selectedElementId: null,
  stageRef: null,

  loadTemplate: (template) => set({ template, selectedElementId: null }),
  
  selectElement: (id) => set({ selectedElementId: id }),
  
  updateElement: (id, updates) => set((state) => {
    if (!state.template) return state;
    return {
      template: {
        ...state.template,
        elements: state.template.elements.map(el => {
          if (el.id === id) {
            const next = { ...el, ...updates };
            if (next.type === 'svg' && next.customSvgPath) {
              const fill = next.fill || '#166FBB';
              const viewBox = next.viewBox || '0 0 24 24';
              // Generate clean, inline SVG URI
              const svg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="${viewBox}" fill="${encodeURIComponent(fill)}">${next.customSvgPath}</svg>`;
              next.url = `data:image/svg+xml;utf8,${svg}`;
            }
            return next;
          }
          return el;
        })
      }
    };
  }),
  
  updateBackground: (color) => set((state) => {
    if (!state.template) return state;
    
    // --- ALGORTIHMIC CONTRAST CHECKER ---
    // Helper to calculate relative luminance
    const hex = color.replace('#', '');
    const r = parseInt(hex.substring(0, 2), 16) || 0;
    const g = parseInt(hex.substring(2, 4), 16) || 0;
    const b = parseInt(hex.substring(4, 6), 16) || 0;
    const luminance = (0.2126 * r + 0.7152 * g + 0.0722 * b) / 255;

    const updatedElements = state.template.elements.map(el => {
      if (el.type === 'text') {
        const fillLower = (el.fill || '').toLowerCase();
        // If background becomes dark, invert dark text to white
        if (luminance < 0.45) {
          if (fillLower === '#000000' || fillLower === '#0f172a' || fillLower === '#111827' || fillLower === '#1e293b' || fillLower === '#475569') {
            return { ...el, fill: '#ffffff' };
          }
        } else {
          // If background becomes light, invert light text to slate matte
          if (fillLower === '#ffffff' || fillLower === '#f8fafc' || fillLower === '#f1f5f9' || fillLower === '#e2e8f0') {
            return { ...el, fill: '#0f172a' };
          }
        }
      }
      return el;
    });

    return {
      template: {
        ...state.template,
        background: color,
        elements: updatedElements
      }
    };
  }),

  addElement: (element) => set((state) => {
    if (!state.template) return state;
    return {
      template: {
        ...state.template,
        elements: [...state.template.elements, element]
      },
      selectedElementId: element.id
    };
  }),

  removeElement: (id) => set((state) => {
    if (!state.template) return state;
    return {
      template: {
        ...state.template,
        elements: state.template.elements.filter(el => el.id !== id)
      },
      selectedElementId: state.selectedElementId === id ? null : state.selectedElementId
    };
  }),

  setStageRef: (ref) => set({ stageRef: ref })
}));
