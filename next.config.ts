import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Configure page extensions to include MDX
  pageExtensions: ["js", "jsx", "ts", "tsx", "md", "mdx"],

  // Optional: Enable static export for GitHub Pages backup
  // Uncomment when ready to deploy
  // output: 'export',
  // images: {
  //   unoptimized: true,
  // },
};

export default nextConfig;
