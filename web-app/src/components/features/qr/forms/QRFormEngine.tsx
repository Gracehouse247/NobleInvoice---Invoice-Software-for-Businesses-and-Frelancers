import React from 'react';
import WebsiteForm from './WebsiteForm';
import TextForm from './TextForm';
import WifiForm from './WifiForm';
import VCardForm from './VCardForm';
import PdfForm from './PdfForm';
import BusinessForm from './BusinessForm';

import EmailForm from './EmailForm';
import SmsForm from './SmsForm';
import WhatsappForm from './WhatsappForm';
import CallForm from './CallForm';
import LocationForm from './LocationForm';
import EventForm from './EventForm';
import AppStoreForm from './AppStoreForm';
import BitcoinForm from './BitcoinForm';
import VideoForm from './VideoForm';
import Mp3Form from './Mp3Form';
import SocialForm from './SocialForm';
import ImageGalleryForm from './ImageGalleryForm';
import MenuForm from './MenuForm';
import CouponForm from './CouponForm';
import ProductForm from './ProductForm';

interface EngineProps {
    type: string;
    onChange: (payload: Record<string, any>) => void;
    onPreviewValueChange: (val: string) => void;
    initialData?: Record<string, any>;
}

export default function QRFormEngine({ type, onChange, onPreviewValueChange, initialData }: EngineProps) {
    // Map URL query 'type' to the correct React Component
    const renderForm = () => {
        switch (type) {
            case 'website':
                return <WebsiteForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'text':
                return <TextForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'wifi':
                return <WifiForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'vcard':
                return <VCardForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'pdf':
                return <PdfForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'business':
                return <BusinessForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'email':
                return <EmailForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'sms':
                return <SmsForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'whatsapp':
                return <WhatsappForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'call':
                return <CallForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'location':
                return <LocationForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'event':
                return <EventForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'appstore':
                return <AppStoreForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'bitcoin':
                return <BitcoinForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'video':
                return <VideoForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'mp3':
                return <Mp3Form onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'social':
                return <SocialForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'image':
                return <ImageGalleryForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'menu':
                return <MenuForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'coupon':
                return <CouponForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            case 'product':
                return <ProductForm onChange={onChange} onPreviewValueChange={onPreviewValueChange} initialData={initialData} />;
            // Fallback for types not yet converted to individual components
            default:
                return (
                    <div className="p-8 bg-amber-50 rounded-xl border border-amber-200 text-center">
                        <p className="text-sm font-bold text-amber-800">
                            The {type} form is currently being migrated to the new Modular Engine. 
                            <br />Please use Website, Text, WiFi, vCard, PDF, or Business for now.
                        </p>
                    </div>
                );
        }
    };

    return (
        <div className="qr-form-engine-container">
            {renderForm()}
        </div>
    );
}
