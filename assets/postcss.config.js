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
        let result = content.match(/[A-Za-z0-9-_:/]+/g) || [];
        console.log(result);
        return result;
      },
      extensions: ["leex", "eex", "js", "ex"]
    }
  ]
});

module.exports = {
  plugins: [
    require("postcss-import")(),
    require("tailwindcss"),
    require("autoprefixer"),
    ...(process.env.NODE_ENV === "production" ? [purgecss] : [])
  ]
};
