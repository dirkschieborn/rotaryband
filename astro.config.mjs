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
      // Notations-Blöcke (```abc) werden im Browser als Notensystem gerendert,
      // Shiki soll sie nur als Text durchreichen.
      langAlias: { abc: 'text' },
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