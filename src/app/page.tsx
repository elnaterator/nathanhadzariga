export default function Home() {
  return (
    <div className="container mx-auto px-4 py-16">
      <div className="flex flex-col items-center justify-center min-h-[60vh] text-center">
        {/* Hero Section */}
        <h1 className="text-5xl md:text-6xl font-bold mb-6 bg-gradient-to-r from-blue-400 to-purple-600 bg-clip-text text-transparent">
          Nathan Hadzariga
        </h1>
        <p className="text-xl md:text-2xl text-gray-300 mb-4">
          Staff Software Engineer at Experian
        </p>
        <p className="text-lg text-gray-400 max-w-2xl mb-12">
          Building scalable systems, leading technical initiatives, and
          delivering impactful solutions
        </p>

        {/* Coming Soon Badge */}
        <div className="inline-flex items-center gap-2 px-4 py-2 bg-gray-800 rounded-full border border-gray-700 mb-8">
          <div className="h-2 w-2 bg-blue-500 rounded-full animate-pulse"></div>
          <span className="text-sm text-gray-300">
            Portfolio coming soon...
          </span>
        </div>

        {/* Quick Links */}
        <div className="flex flex-wrap gap-4 justify-center">
          <a
            href="/portfolio"
            className="px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors font-medium"
          >
            View Portfolio
          </a>
          <a
            href="/blog"
            className="px-6 py-3 bg-gray-800 hover:bg-gray-700 text-white rounded-lg transition-colors font-medium border border-gray-700"
          >
            Read Blog
          </a>
        </div>
      </div>
    </div>
  );
}
