export interface QrFormProps {
    onChange: (payload: Record<string, any>) => void;
    initialData?: Record<string, any>;
    onPreviewValueChange: (val: string) => void;
}
