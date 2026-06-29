import React, { useRef, useEffect } from 'react';
import { Text, Rect, Image as KonvaImage, Transformer } from 'react-konva';
import useImage from 'use-image';
import { CanvasElement } from '../../../types/canvas';

interface CanvasElementRendererProps {
  element: CanvasElement;
  isSelected: boolean;
  onSelect: () => void;
  onChange: (newAttrs: Partial<CanvasElement>) => void;
}

export const CanvasElementRenderer: React.FC<CanvasElementRendererProps> = ({ 
  element, 
  isSelected, 
  onSelect, 
  onChange 
}) => {
  const shapeRef = useRef<any>(null);
  const trRef = useRef<any>(null);
  
  // Custom hook to load images via URL for image/svg types
  const [image] = useImage(element.url || '');

  useEffect(() => {
    if (isSelected && trRef.current && shapeRef.current) {
      trRef.current.nodes([shapeRef.current]);
      trRef.current.getLayer().batchDraw();
    }
  }, [isSelected]);

  // Caching mechanism to accelerate rendering performance for heavy vectors
  useEffect(() => {
    if (shapeRef.current && (element.type === 'svg' || element.type === 'shape')) {
      try {
        shapeRef.current.cache();
        shapeRef.current.getLayer()?.batchDraw();
      } catch (e) {
        console.warn('Caching skipped for uninitialized canvas asset');
      }
    }
  }, [element.fill, element.stroke, element.strokeWidth, element.width, element.height]);

  const handleDragEnd = (e: any) => {
    onChange({
      x: e.target.x(),
      y: e.target.y()
    });
  };

  const handleTransformEnd = (e: any) => {
    const node = shapeRef.current;
    if (!node) return;
    
    const scaleX = node.scaleX();
    const scaleY = node.scaleY();

    node.scaleX(1);
    node.scaleY(1);

    onChange({
      x: node.x(),
      y: node.y(),
      rotation: node.rotation(),
      // For text we might just adjust fontSize, but for shapes we adjust width/height
      width: Math.max(5, node.width() * scaleX),
      height: Math.max(5, node.height() * scaleY)
    });
  };

  let NodeComponent = null;

  // Global shadow props to spread into Konva shapes
  const shadowProps = {
    shadowColor: element.shadowColor || 'transparent',
    shadowBlur: element.shadowBlur || 0,
    shadowOffsetX: element.shadowOffsetX || 0,
    shadowOffsetY: element.shadowOffsetY || 0,
    shadowOpacity: element.shadowOpacity !== undefined ? element.shadowOpacity : 0.5,
  };

  switch (element.type) {
    case 'text':
      NodeComponent = (
        <Text
          ref={shapeRef}
          text={element.text}
          x={element.x}
          y={element.y}
          fill={element.fill}
          fontSize={element.fontSize}
          fontFamily={element.fontFamily}
          fontWeight={element.fontWeight}
          letterSpacing={element.letterSpacing || 0}
          rotation={element.rotation || 0}
          {...shadowProps}
          draggable
          onClick={onSelect}
          onTap={onSelect}
          onDragEnd={handleDragEnd}
          onTransformEnd={handleTransformEnd}
        />
      );
      break;
    case 'shape':
      NodeComponent = (
        <Rect
          ref={shapeRef}
          x={element.x}
          y={element.y}
          width={element.width || 100}
          height={element.height || 100}
          fill={element.fill}
          stroke={element.stroke || 'transparent'}
          strokeWidth={element.strokeWidth || 0}
          rotation={element.rotation || 0}
          cornerRadius={element.cornerRadius}
          {...shadowProps}
          draggable
          onClick={onSelect}
          onTap={onSelect}
          onDragEnd={handleDragEnd}
          onTransformEnd={handleTransformEnd}
        />
      );
      break;
    case 'image':
    case 'svg':
      const imageWidth = element.width || 100;
      const imageHeight = element.height || 100;
      
      const BaseKonvaImage = (
        <KonvaImage
          ref={shapeRef}
          image={image}
          x={element.clipType === 'circle' ? 0 : element.x}
          y={element.clipType === 'circle' ? 0 : element.y}
          width={imageWidth}
          height={imageHeight}
          stroke={element.stroke || 'transparent'}
          strokeWidth={element.strokeWidth || 0}
          rotation={element.rotation || 0}
          {...shadowProps}
          draggable={element.clipType !== 'circle'}
          onClick={onSelect}
          onTap={onSelect}
          onDragEnd={handleDragEnd}
          onTransformEnd={handleTransformEnd}
        />
      );

      // Elite circular masking clipping groups for corporate avatars
      if (element.clipType === 'circle') {
        const radius = Math.min(imageWidth, imageHeight) / 2;
        const centerX = element.x + radius;
        const centerY = element.y + radius;
        
        NodeComponent = (
          <React.Fragment>
            <KonvaImage
              ref={shapeRef}
              image={image}
              x={element.x}
              y={element.y}
              width={imageWidth}
              height={imageHeight}
              stroke={element.stroke || 'transparent'}
              strokeWidth={element.strokeWidth || 0}
              rotation={element.rotation || 0}
              clipFunc={(ctx: any) => {
                ctx.arc(imageWidth / 2, imageHeight / 2, radius, 0, Math.PI * 2, false);
              }}
              {...shadowProps}
              draggable
              onClick={onSelect}
              onTap={onSelect}
              onDragEnd={handleDragEnd}
              onTransformEnd={handleTransformEnd}
            />
          </React.Fragment>
        );
      } else {
        NodeComponent = BaseKonvaImage;
      }
      break;
    default:
      return null;
  }

  return (
    <React.Fragment>
      {NodeComponent}
      {isSelected && (
        <Transformer
          ref={trRef}
          boundBoxFunc={(oldBox, newBox) => {
            // Limit minimum size
            if (newBox.width < 5 || newBox.height < 5) {
              return oldBox;
            }
            return newBox;
          }}
        />
      )}
    </React.Fragment>
  );
};
