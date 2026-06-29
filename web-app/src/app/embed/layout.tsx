export default function EmbedLayout({
    children,
  }: {
    children: React.ReactNode
  }) {
    return (
      <div 
        className="w-full h-full min-h-screen bg-transparent m-0 p-0 overflow-hidden"
        style={{
          userSelect: 'none',
          WebkitUserSelect: 'none',
          WebkitTouchCallout: 'none',
          touchAction: 'pan-y' // allow scrolling vertically
        }}
      >
        <style dangerouslySetInnerHTML={{__html: `
          body {
            margin: 0;
            padding: 0;
            background-color: transparent !important;
            overflow-x: hidden;
            -webkit-tap-highlight-color: transparent;
          }
          /* Hide scrollbar for Chrome, Safari and Opera */
          ::-webkit-scrollbar {
            display: none;
          }
          /* Hide scrollbar for IE, Edge and Firefox */
          * {
            -ms-overflow-style: none;  /* IE and Edge */
            scrollbar-width: none;  /* Firefox */
          }
        `}} />
        {children}
      </div>
    );
  }
