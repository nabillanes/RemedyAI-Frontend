/* filepath: c:\Users\belat\OneDrive\Documents\GitHub\RemedyAI-Frontend\src\app\layout.js */
'use client';

import { usePathname } from 'next/navigation';
import "./globals.css";
import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";

export default function RootLayout({ children }) {
  const pathname = usePathname();
  
  // Hide navbar on homepage
  const showNavbar = pathname !== '/';

  return (
    <html lang="en">
      <head>
        <link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed&display=swap" rel="stylesheet" />
        <link rel="icon" type="image/svg+xml" href="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzIiIGhlaWdodD0iMzIiIHZpZXdCb3g9IjAgMCAzMiAzMiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTE2IDJMMjggMTZMMTYgMzBMMCAxNkwxNiAyWiIgZmlsbD0iIzRhOWVmZiIvPgo8cGF0aCBkPSJNMTYgNkwxMiAxMEwxNiAxNEwyMCAxMEwxNiA2WiIgZmlsbD0id2hpdGUiLz4KPC9zdmc+" />
      </head>
      <body>
        {showNavbar && <Navbar />}
        {children}
        {showNavbar && <Footer />}
      </body>
    </html>
  );
}