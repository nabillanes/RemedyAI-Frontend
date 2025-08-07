export default function About() {
  return (
    <div className="min-h-screen bg-gray-50 py-12">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            About RemedyAI
          </h1>
          <p className="text-xl text-gray-600 max-w-2xl mx-auto">
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
          </p>
        </div>

        {/* Content */}
        <div className="bg-white rounded-lg shadow-sm p-8">
          <div className="prose max-w-none">
            <h2 className="text-2xl font-bold text-gray-900 mb-4">Lorem Ipsum</h2>
            <p className="text-gray-600 mb-6">
              Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
            </p>

            <h2 className="text-2xl font-bold text-gray-900 mb-4">Dolor Sit Amet</h2>
            <p className="text-gray-600 mb-6">
              Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
            </p>

            <h2 className="text-2xl font-bold text-gray-900 mb-4">Consectetur Adipiscing</h2>
            <p className="text-gray-600 mb-6">
              Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.
            </p>

            <h2 className="text-2xl font-bold text-gray-900 mb-4">Ut Enim Ad Minim</h2>
            <p className="text-gray-600">
              At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
