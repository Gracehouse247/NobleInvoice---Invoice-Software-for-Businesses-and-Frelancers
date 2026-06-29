import { MindMapNode } from '@/types';

const X_GAP = 260;   // Horizontal distance between depth levels
const Y_GAP = 90;    // Minimum vertical gap between sibling subtrees

/**
 * Calculates a hierarchical left-to-right tree layout.
 * Root is at (0,0). Parents are always vertically centered
 * relative to the full height of their visible subtree.
 * Collapsed nodes contribute zero height (their children are hidden).
 */
export function calculateSubtreeLayout(nodes: MindMapNode[], centralNodeId: string): MindMapNode[] {
    const nodeMap = new Map<string, MindMapNode>();
    nodes.forEach(n => nodeMap.set(n.id, { ...n }));

    /**
     * Returns the total vertical space this subtree needs.
     */
    function measure(nodeId: string, x: number): number {
        const node = nodeMap.get(nodeId);
        if (!node) return 0;

        node.positionDx = x;
        const weight = node.weight || 0.5;
        const baseGap = Y_GAP * (0.8 + weight * 0.4); // Scale base gap by weight (0.9x to 1.2x)

        if (node.childIds.length === 0 || !node.isExpanded) {
            return baseGap;
        }

        const childHeights = node.childIds.map(cid => measure(cid, x + X_GAP));
        const totalHeight = childHeights.reduce((a, b) => a + b, 0);

        // Center parent relative to its children's collective height
        let currentY = -(totalHeight / 2) + childHeights[0] / 2;
        node.childIds.forEach((cid, i) => {
            const child = nodeMap.get(cid)!;
            child.positionDy = currentY; 
            if (i < node.childIds.length - 1) {
                currentY += childHeights[i] / 2 + childHeights[i + 1] / 2;
            }
        });

        return Math.max(baseGap, totalHeight);
    }

    /** Convert relative positionDy values to absolute world-coordinates. */
    function applyY(nodeId: string, parentAbsY: number) {
        const node = nodeMap.get(nodeId);
        if (!node) return;

        if (node.type === 'central') {
            node.positionDy = 0;
        } else {
            node.positionDy += parentAbsY;
        }

        if (node.isExpanded) {
            node.childIds.forEach(cid => applyY(cid, node.positionDy));
        }
    }

    measure(centralNodeId, 0);
    applyY(centralNodeId, 0);

    return Array.from(nodeMap.values());
}

