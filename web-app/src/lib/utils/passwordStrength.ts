export function getPasswordStrength(password: string): number {
    let strength = 0;
    if (password.length >= 8) strength++;
    if (/[A-Z]/.test(password)) strength++;
    if (/[0-9]/.test(password)) strength++;
    if (/[!@#$%^&*(),.?":{}|<>]/.test(password)) strength++;
    return strength; 
}

export const STRENGTH_CONFIG = [
    { label: 'Weak',      color: '#EF4444' },
    { label: 'Fair',      color: '#F59E0B' },
    { label: 'Good',      color: '#3B82F6' },
    { label: 'Strong',    color: '#166FBB' },
    { label: 'Excellent', color: '#10B981' },
];
