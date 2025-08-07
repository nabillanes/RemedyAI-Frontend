'use client';

import { useState } from 'react';

const faqData = [
  {
    id: 1,
    question: "Lorem ipsum dolor sit amet?",
    answer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
  },
  {
    id: 2,
    question: "Consectetur adipiscing elit sed do?",
    answer: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  },
  {
    id: 3,
    question: "Sed do eiusmod tempor incididunt?",
    answer: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt."
  },
  {
    id: 4,
    question: "Ut labore et dolore magna aliqua?",
    answer: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident."
  },
  {
    id: 5,
    question: "Quis nostrud exercitation ullamco?",
    answer: "Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus."
  },
  {
    id: 6,
    question: "Duis aute irure dolor in reprehenderit?",
    answer: "Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae."
  },
  {
    id: 7,
    question: "Excepteur sint occaecat cupidatat?",
    answer: "Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat."
  },
  {
    id: 8,
    question: "Sunt in culpa qui officia deserunt?",
    answer: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
  },
  {
    id: 9,
    question: "Mollit anim id est laborum?",
    answer: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit."
  },
  {
    id: 10,
    question: "Sed ut perspiciatis unde omnis?",
    answer: "Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt."
  }
];

function FAQItem({ question, answer, isOpen, onClick }) {
  return (
    <div className="border border-gray-200 rounded-lg mb-4">
      <button
        className="w-full px-6 py-4 text-left focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
        onClick={onClick}
      >
        <div className="flex justify-between items-center">
          <h3 className="text-lg font-semibold text-gray-900">{question}</h3>
          <svg
            className={`w-5 h-5 text-gray-500 transform transition-transform ${
              isOpen ? 'rotate-180' : ''
            }`}
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
          >
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
          </svg>
        </div>
      </button>
      {isOpen && (
        <div className="px-6 pb-4">
          <p className="text-gray-600 leading-relaxed">{answer}</p>
        </div>
      )}
    </div>
  );
}

export default function FAQ() {
  const [openItems, setOpenItems] = useState(new Set());

  const toggleItem = (id) => {
    const newOpenItems = new Set(openItems);
    if (newOpenItems.has(id)) {
      newOpenItems.delete(id);
    } else {
      newOpenItems.add(id);
    }
    setOpenItems(newOpenItems);
  };

  return (
    <div className="min-h-screen bg-gray-50 py-12">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Frequently Asked Questions
          </h1>
          <p className="text-xl text-gray-600 max-w-2xl mx-auto">
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
          </p>
        </div>

        {/* Search Bar */}
        <div className="mb-8">
          <div className="relative">
            <input
              type="text"
              placeholder="Lorem ipsum dolor sit amet..."
              className="w-full px-4 py-3 pl-12 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
            <svg
              className="absolute left-4 top-3.5 h-5 w-5 text-gray-400"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
            </svg>
          </div>
        </div>

        {/* FAQ Items */}
        <div className="bg-white rounded-lg shadow-sm">
          {faqData.map((item) => (
            <FAQItem
              key={item.id}
              question={item.question}
              answer={item.answer}
              isOpen={openItems.has(item.id)}
              onClick={() => toggleItem(item.id)}
            />
          ))}
        </div>

        {/* Contact Section */}
        <div className="mt-12 text-center bg-blue-50 rounded-lg p-8">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">
            Lorem ipsum dolor sit?
          </h2>
          <p className="text-gray-600 mb-6">
            Consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <a
              href="mailto:support@remedyai.com"
              className="bg-blue-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-blue-700 transition-colors"
            >
              Email Support
            </a>
            <a
              href="tel:+15551234567"
              className="border border-blue-600 text-blue-600 px-6 py-3 rounded-lg font-semibold hover:bg-blue-50 transition-colors"
            >
              Call Us
            </a>
          </div>
        </div>
      </div>
    </div>
  );
}
