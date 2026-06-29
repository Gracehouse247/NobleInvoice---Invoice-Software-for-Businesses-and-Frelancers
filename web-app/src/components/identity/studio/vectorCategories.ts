export const VECTOR_CATEGORIES = [
  {
    name: 'Lines',
    items: [
      {
        id: 'solid-line',
        name: 'Solid',
        path: '<line x1="2" y1="12" x2="22" y2="12" stroke="currentColor" stroke-width="2" stroke-linecap="round" />',
        icon: '—'
      },
      {
        id: 'dashed-line',
        name: 'Dashed',
        path: '<line x1="2" y1="12" x2="22" y2="12" stroke="currentColor" stroke-width="2" stroke-dasharray="4 4" stroke-linecap="round" />',
        icon: '- - -'
      },
      {
        id: 'dotted-line',
        name: 'Dotted',
        path: '<line x1="2" y1="12" x2="22" y2="12" stroke="currentColor" stroke-width="2" stroke-dasharray="1 3" stroke-linecap="round" />',
        icon: '. . .'
      },
      {
        id: 'arrow-line',
        name: 'Arrow Line',
        path: '<line x1="2" y1="12" x2="18" y2="12" stroke="currentColor" stroke-width="2" stroke-linecap="round" /><polygon points="17,9 22,12 17,15" fill="currentColor" />',
        icon: '—>'
      },
      {
        id: 'dot-arrow-line',
        name: 'Dot Arrow',
        path: '<circle cx="4" cy="12" r="3" fill="currentColor" /><line x1="7" y1="12" x2="18" y2="12" stroke="currentColor" stroke-width="2" stroke-linecap="round" /><polygon points="17,9 22,12 17,15" fill="currentColor" />',
        icon: 'o—>'
      },
      {
        id: 'dotted-bar-line',
        name: 'Dotted Bar',
        path: '<rect x="2" y="9" width="4" height="6" fill="currentColor" /><line x1="8" y1="12" x2="20" y2="12" stroke="currentColor" stroke-width="2" stroke-dasharray="2 3" stroke-linecap="round" /><line x1="21" y1="8" x2="21" y2="16" stroke="currentColor" stroke-width="2" stroke-linecap="round" />',
        icon: '▪️···|'
      }
    ]
  },
  {
    name: 'Shapes',
    items: [
      {
        id: 'rect',
        name: 'Rectangle',
        path: '<rect x="2" y="2" width="20" height="20" fill="currentColor" />',
        icon: 'Square'
      },
      {
        id: 'circle',
        name: 'Circle',
        path: '<circle cx="12" cy="12" r="10" fill="currentColor" />',
        icon: 'Circle'
      },
      {
        id: 'star',
        name: 'Star',
        path: '<polygon points="12,2 15,9 22,9 17,14 19,21 12,17 5,21 7,14 2,9 9,9" fill="currentColor" />',
        icon: 'Star'
      },
      {
        id: 'triangle',
        name: 'Triangle',
        path: '<polygon points="12,2 22,22 2,22" fill="currentColor" />',
        icon: '▲'
      },
      {
        id: 'right-triangle',
        name: 'Right Triangle',
        path: '<polygon points="2,2 2,22 22,22" fill="currentColor" />',
        icon: '◥'
      },
      {
        id: 'diamond',
        name: 'Diamond',
        path: '<polygon points="12,2 22,12 12,22 2,12" fill="currentColor" />',
        icon: '◆'
      },
      {
        id: 'pentagon',
        name: 'Pentagon',
        path: '<polygon points="12,2 22,9 18,20 6,20 2,9" fill="currentColor" />',
        icon: '⬠'
      },
      {
        id: 'hexagon',
        name: 'Hexagon',
        path: '<polygon points="12,2 21,7 21,17 12,22 3,17 3,7" fill="currentColor" />',
        icon: '⬢'
      },
      {
        id: 'bubble',
        name: 'Speech Bubble',
        path: '<path d="M20 2H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h14l4 4V4c0-1.1-.9-2-2-2z" fill="currentColor" />',
        icon: '💬'
      },
      {
        id: 'plus',
        name: 'Plus / Cross',
        path: '<path d="M19 10.5h-5.5V5c0-.8-.7-1.5-1.5-1.5s-1.5.7-1.5 1.5v5.5H5c-.8 0-1.5.7-1.5 1.5s.7 1.5 1.5 1.5h5.5V19c0 .8.7 1.5 1.5 1.5s1.5-.7 1.5-1.5v-5.5H19c.8 0 1.5-.7 1.5-1.5s-.7-1.5-1.5-1.5z" fill="currentColor" />',
        icon: '＋'
      },
      {
        id: 'dome',
        name: 'Arch / Dome',
        path: '<path d="M12 2c5.52 0 10 4.48 10 10v10H2V12C2 6.48 6.48 2 12 2z" fill="currentColor" />',
        icon: '∩'
      },
      {
        id: 'cloud',
        name: 'Cloud',
        path: '<path d="M19.35 10.04C18.67 6.59 15.64 4 12 4 9.11 4 6.6 5.64 5.35 8.04 2.34 8.36 0 10.91 0 14c0 3.31 2.69 6 6 6h13c2.76 0 5-2.24 5-5 0-2.64-2.05-4.78-4.65-4.96z" fill="currentColor" />',
        icon: '☁'
      }
    ]
  },
  {
    name: 'Arrows & Decoratives',
    items: [
      {
        id: 'arrow-right',
        name: 'Arrow Right',
        path: '<path d="M12 4l-1.41 1.41L16.17 11H4v2h12.17l-5.58 5.59L12 20l8-8z" fill="currentColor" />',
        icon: '➔'
      },
      {
        id: 'arrow-left',
        name: 'Arrow Left',
        path: '<path d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z" fill="currentColor" />',
        icon: '←'
      },
      {
        id: 'arrow-down',
        name: 'Arrow Down',
        path: '<path d="M20 12l-1.41-1.41L13 16.17V4h-2v12.17l-5.59-5.59L4 12l8 8 8-8z" fill="currentColor" />',
        icon: '↓'
      },
      {
        id: 'arrow-up',
        name: 'Arrow Up',
        path: '<path d="M4 12l1.41 1.41L11 7.83V20h2V7.83l5.59 5.59L20 12l-8-8-8 8z" fill="currentColor" />',
        icon: '↑'
      },
      {
        id: 'flower',
        name: 'Flower',
        path: '<path d="M12 7.5a2.5 2.5 0 0 1 2.5 2.5a2.5 2.5 0 0 1-2.5 2.5a2.5 2.5 0 0 1-2.5-2.5A2.5 2.5 0 0 1 12 7.5zm4.5 4.5a2.5 2.5 0 0 1 2.5 2.5a2.5 2.5 0 0 1-2.5 2.5a2.5 2.5 0 0 1-2.5-2.5A2.5 2.5 0 0 1 16.5 12zM7.5 12A2.5 2.5 0 0 1 10 14.5A2.5 2.5 0 0 1 7.5 17A2.5 2.5 0 0 1 5 14.5A2.5 2.5 0 0 1 7.5 12zm4.5 4.5a2.5 2.5 0 0 1 2.5 2.5A2.5 2.5 0 0 1 12 21.5A2.5 2.5 0 0 1 9.5 19a2.5 2.5 0 0 1 2.5-2.5z" fill="currentColor" />',
        icon: '✿'
      },
      {
        id: 'asterisk',
        name: 'Asterisk',
        path: '<path d="M12 2a1 1 0 0 1 1 1v7.24l5.12-5.12a1 1 0 1 1 1.41 1.41L14.41 12l5.12 5.12a1 1 0 1 1-1.41 1.41L13 13.41V21a1 1 0 1 1-2 0v-7.59l-5.12 5.12a1 1 0 0 1-1.41-1.41L9.59 12 4.47 6.88a1 1 0 0 1 1.41-1.41L11 10.59V3a1 1 0 0 1 1-1z" fill="currentColor" />',
        icon: '✱'
      },
      {
        id: 'banner',
        name: 'Banner',
        path: '<polygon points="4,2 20,2 20,22 12,17 4,22" fill="currentColor" />',
        icon: '⚑'
      },
      {
        id: 'semi-left',
        name: 'Left Semi',
        path: '<path d="M22 2A10 10 0 0 0 12 12A10 10 0 0 0 22 22Z" fill="currentColor" />',
        icon: '◖'
      },
      {
        id: 'semi-right',
        name: 'Right Semi',
        path: '<path d="M2 2A10 10 0 0 1 12 12A10 10 0 0 1 2 22Z" fill="currentColor" />',
        icon: '◗'
      },
      {
        id: 'capsule',
        name: 'Capsule',
        path: '<rect x="2" y="6" width="20" height="12" rx="6" fill="currentColor" />',
        icon: '▰'
      },
      {
        id: 'teardrop',
        name: 'Tear Drop',
        path: '<path d="M12 2.69S2 10.87 2 15a10 10 0 0 0 20 0c0-4.13-10-12.31-10-12.31z" fill="currentColor" />',
        icon: '💧'
      },
      {
        id: 'wave',
        name: 'Wave',
        path: '<path d="M2 4c5-2 7 2 10 0s5-2 10 0v14c-5-2-7 2-10 0s-5-2-10 0z" fill="currentColor" />',
        icon: '〰'
      },
      {
        id: 'starburst',
        name: 'Starburst',
        path: '<path d="M12 2l1.9 2.9l3.3-1.2l-0.2 3.5l3.1 1.6l-2 2.8l2 2.8l-3.1 1.6l0.2 3.5l-3.3-1.2l-1.9 2.9l-1.9-2.9l-3.3 1.2l0.2-3.5l-3.1-1.6l2-2.8l-2-2.8l3.1-1.6l-0.2-3.5l3.3 1.2z" fill="currentColor" />',
        icon: '✴'
      },
      {
        id: 'heart',
        name: 'Heart',
        path: '<path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z" fill="currentColor" />',
        icon: '♥'
      },
      {
        id: 'house',
        name: 'House',
        path: '<path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z" fill="currentColor" />',
        icon: '🏠'
      },
      {
        id: 'lightning',
        name: 'Lightning',
        path: '<polygon points="7,2 17,2 12,10 18,10 9,22 11,13 6,13" fill="currentColor" />',
        icon: '⚡'
      },
      {
        id: 'magnet',
        name: 'Magnet',
        path: '<path d="M4 4v8c0 4.42 3.58 8 8 8s8-3.58 8-8V4h-4v8c0 2.21-1.79 4-4 4s-4-1.79-4-4V4H4z" fill="currentColor" />',
        icon: '🧲'
      },
      {
        id: 'concave',
        name: 'Hourglass',
        path: '<path d="M4 2h16c0 6-4 6-4 10s4 4 4 10H4c0-6 4-6 4-10S4 8 4 2z" fill="currentColor" />',
        icon: '⧓'
      }
    ]
  },
  {
    name: 'Badges & Blobs',
    items: [
      {
        id: 'shield-pointed',
        name: 'Shield Pointy',
        path: '<path d="M12 2S3 5 3 12c0 5.55 9 10 9 10s9-4.45 9-10c0-7-9-10-9-10z" fill="currentColor" />',
        icon: '🛡'
      },
      {
        id: 'shield-badge',
        name: 'Shield Flat',
        path: '<path d="M12 2L4 5v6c0 5.25 3.42 10.18 8 11.5c4.58-1.32 8-6.25 8-11.5V5L12 2z" fill="currentColor" />',
        icon: 'badge'
      },
      {
        id: 'parallelogram',
        name: 'Parallelogram',
        path: '<polygon points="6,4 22,4 18,20 2,20" fill="currentColor" />',
        icon: '▰'
      },
      {
        id: 'quatrefoil',
        name: 'Quatrefoil',
        path: '<path d="M12 12c0-2.2 1.8-4 4-4s4 1.8 4 4s-1.8 4-4 4s-4-1.8-4-4zm-8 0c0-2.2 1.8-4 4-4s4 1.8 4 4s-1.8 4-4 4s-4-1.8-4-4zm4-4c0-2.2 1.8-4 4-4s4 1.8 4 4s-1.8 4-4 4s-4-1.8-4-4zm0 8c0-2.2 1.8-4 4-4s4 1.8 4 4s-1.8 4-4 4s-4-1.8-4-4z" fill="currentColor" />',
        icon: '☘'
      },
      {
        id: 'sparkle',
        name: 'Sparkle',
        path: '<path d="M12 2c0 5.52 4.48 10 10 10c-5.52 0-10 4.48-10 10c0-5.52-4.48-10-10-10c5.52 0 10-4.48 10-10z" fill="currentColor" />',
        icon: '✦'
      },
      {
        id: 'step-blocks',
        name: 'Steps',
        path: '<path d="M2 22h6v-6h6v-6h6V4h-6v6h-6v6H2z" fill="currentColor" />',
        icon: '▞'
      },
      {
        id: 'blob-a',
        name: 'Blob Alpha',
        path: '<path d="M12 2C7.3 2 3.4 5.9 3.4 10.6c0 5.8 4.2 9.1 8.6 11.1c4.4 2 8.6-1.9 8.6-7.7c0-4.7-3.9-8.6-8.6-8.6z" fill="currentColor" />',
        icon: 'blob'
      },
      {
        id: 'blob-b',
        name: 'Blob Beta',
        path: '<path d="M12 2C6.8 2 2 5.8 2 11c0 6.2 5.2 11 10.4 11c4.2 0 9.6-3.8 9.6-9C22 6.8 17.2 2 12 2zm2 14c-2.4 1-5-.5-5.5-3c-.5-2.5 1-5.2 3.5-5.5c2.5-.3 5.2 1.2 5.5 3.7c.3 2.5-1.1 3.8-3.5 4.8z" fill="currentColor" />',
        icon: 'blob'
      }
    ]
  }
];
