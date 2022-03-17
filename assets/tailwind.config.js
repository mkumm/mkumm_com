// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration
module.exports = {
  content: [
    './js/**/*.js',
    '../lib/*_web.ex',
    '../lib/*_web/**/*.*ex'
  ],
  theme: {
    extend: {
      colors: {
        mktext: {
          800: '#292f33',
          },
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms')
  ]
}
