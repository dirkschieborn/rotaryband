import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const songs = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/songs' }),
  schema: z.object({
    title: z.string(),
    artist: z.string().optional(),
    tempo: z.string().optional(), // z.B. "ca. 168 BPM"
    key: z.string().optional(), // Tonart, z.B. "Bb-Dur"
    feel: z.string().optional(), // z.B. "Shuffle", "Straight 8th"
    status: z.enum(['aktiv', 'in-arbeit', 'archiv']).default('aktiv'),
    // Mehrstimmiger Gesang: wer singt welche Linie auf welcher Stufe
    vocals: z
      .array(
        z.object({
          wer: z.string(),
          part: z.string(), // z.B. "Lead", "2. Stimme, Terz über Lead"
        })
      )
      .optional(),
  }),
});

const setlisten = defineCollection({
  loader: glob({ pattern: '**/*.yaml', base: './src/content/setlisten' }),
  schema: z.object({
    title: z.string(),
    date: z.coerce.date().optional(),
    location: z.string().optional(),
    notes: z.string().optional(),
    sets: z.array(
      z.object({
        name: z.string().optional(), // z.B. "Set 1"
        songs: z.array(
          z.object({
            slug: z.string().optional(), // Datei-Name des Songs in src/content/songs (ohne .md)
            title: z.string().optional(), // Fallback, falls es (noch) keine Song-Seite gibt
            note: z.string().optional(), // z.B. "direkt anhängen", "Ansage Spendenzweck"
          })
        ),
      })
    ),
  }),
});

export const collections = { songs, setlisten };
