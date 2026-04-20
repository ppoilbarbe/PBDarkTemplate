export default [
  {
    ignores: ['common/fuzzyset.js'],
  },
  {
    languageOptions: {
      ecmaVersion: 2020,
      sourceType: 'script',
      globals: {
        window: 'readonly',
        document: 'readonly',
        navigator: 'readonly',
        localStorage: 'readonly',
        IntersectionObserver: 'readonly',
        // Cross-file globals (loaded as <script> tags, no module system)
        FuzzySet: 'readonly',
        initTitleSearch: 'readonly',
        setLanguage: 'readonly',
        getAvailableLanguages: 'readonly',
        t: 'readonly',
        applyI18n: 'readonly',
      },
    },
    rules: {
      'no-undef': 'error',
      'no-unused-vars': 'warn',
    },
  },
];
