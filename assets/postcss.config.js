const purgecss = require("@fullhuman/postcss-purgecss")({
  content: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "./js/**/*.js",
    "../**/live/*.ex",
    "../**/templates/*.ex"
  ],
  css: ["./css/app.css"],
  extractors: [
    {
      extractor: content => {
        return content.match(/[A-Za-z0-9-_:/]+/g) || [];
      },
      extensions: ["leex", "eex", "js", "ex"]
    }
  ]
});

module.exports = {
  plugins: [
    require("postcss-import"),
    require("tailwindcss"),
    require("autoprefixer")({ grid: false}),
    ...(process.env.NODE_ENV === "production" ? [purgecss] : [])
  ]
};
