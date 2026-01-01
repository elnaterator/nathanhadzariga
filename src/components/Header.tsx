"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

export default function Header() {
  const pathname = usePathname();

  const navItems = [
    { name: "Home", path: "/" },
    { name: "Portfolio", path: "/portfolio" },
    { name: "Blog", path: "/blog" },
    { name: "POCs", path: "/poc" },
    { name: "About", path: "/about" },
  ];

  return (
    <header className="sticky top-0 z-50 w-full border-b border-gray-800 bg-black/95 backdrop-blur supports-[backdrop-filter]:bg-black/60">
      <nav className="container mx-auto flex h-16 items-center justify-between px-4">
        {/* Logo/Name */}
        <Link
          href="/"
          className="text-xl font-bold text-white hover:text-gray-300 transition-colors"
        >
          Nathan Hadzariga
        </Link>

        {/* Desktop Navigation */}
        <ul className="hidden md:flex items-center space-x-6">
          {navItems.map((item) => (
            <li key={item.path}>
              <Link
                href={item.path}
                className={`
                  text-sm font-medium transition-colors hover:text-white
                  ${
                    pathname === item.path
                      ? "text-white border-b-2 border-blue-500"
                      : "text-gray-400"
                  }
                `}
              >
                {item.name}
              </Link>
            </li>
          ))}
        </ul>

        {/* Mobile Menu Button - placeholder for future implementation */}
        <button
          className="md:hidden text-gray-400 hover:text-white"
          aria-label="Toggle menu"
        >
          <svg
            className="h-6 w-6"
            fill="none"
            strokeLinecap="round"
            strokeLinejoin="round"
            strokeWidth="2"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path d="M4 6h16M4 12h16M4 18h16"></path>
          </svg>
        </button>
      </nav>
    </header>
  );
}
