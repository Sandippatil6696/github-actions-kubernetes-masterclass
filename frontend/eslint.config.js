import js from "@eslint/js";
import globals from "globals";

/** @type {import("eslint").Linter.Config[]} */
export default [
  js.configs.recommended,
  {
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: "script",          // vanilla JS loaded via <script> tags
      globals: {
        ...globals.browser,          // window, document, fetch, etc.
      },
    },
    rules: {
      // ── Possible errors ────────────────────────────────────────────
      "no-console": "warn",
      "no-debugger": "error",
      "no-undef": "error",
      "no-unused-vars": ["warn", { argsIgnorePattern: "^_" }],

      // ── Best practices ─────────────────────────────────────────────
      "eqeqeq": ["error", "always"],
      "curly": ["error", "all"],
      "no-eval": "error",
      "no-implied-eval": "error",
      "no-var": "error",
      "prefer-const": "warn",
      "no-multiple-empty-lines": ["warn", { max: 2 }],
      "no-trailing-spaces": "warn",
      "semi": ["error", "always"],
      "quotes": ["warn", "double", { avoidEscape: true }],
    },
  },
  {
    // Ignore build artefacts or vendor scripts if present
    ignores: ["dist/**", "vendor/**", "*.min.js"],
  },
];
