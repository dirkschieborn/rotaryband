// @ts-check
import { defineConfig } from 'astro/config';

import tailwindcss from '@tailwindcss/vite';

import sitemap from '@astrojs/sitemap';

// https://astro.build/config
export default defineConfig({
  site: 'https://www.rotary-band.de',
  output: 'static',

  build: {
    format: 'directory',
  },

  compressHTML: true,

  markdown: {
    shikiConfig: {
      // Notations-Blöcke (```abc) und Akkord-Raster (```chords) werden im Browser
      // gerendert, Shiki soll sie nur als Text durchreichen.
      langAlias: { abc: 'text', chords: 'text' },
    },
  },

  vite: {
    plugins: [tailwindcss()],
  },

  integrations: [
    sitemap({
      filter: (page) =>
        !['/intern/', '/setlisten/', '/repertoire/'].some((prefix) =>
          new URL(page).pathname.startsWith(prefix)
        ),
    }),
  ],
});