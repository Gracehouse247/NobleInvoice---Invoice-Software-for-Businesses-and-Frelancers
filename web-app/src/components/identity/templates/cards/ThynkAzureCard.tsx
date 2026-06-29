import React from 'react';
import { CardRendererProps } from '../types';
import { WilsonDynamicCard } from './WilsonDynamicCard';

export const ThynkAzureCard: React.FC<CardRendererProps> = (props) => {
    return <WilsonDynamicCard {...props} defaultColor="#0055A4" />;
};
