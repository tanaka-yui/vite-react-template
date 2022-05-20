import { fileURLToPath } from 'url'

import react from '@vitejs/plugin-react'
import AutoImport from 'unplugin-auto-import/vite'
import { defineConfig } from 'vitest/config'

// https://vitejs.dev/config/
// eslint-disable-next-line import/no-default-export
export default defineConfig({
  plugins: [
    react(),
    AutoImport({
      imports: ['vitest'],
      dts: 'auto-imports.d.ts',
      eslintrc: {
        enabled: true,
      },
    }),
  ],
  resolve: {
    alias: {
      // @ts-ignore
      '~': fileURLToPath(new URL('./src', import.meta.url)),
    },
  },
  test: {
    globals: true,
    environment: 'happy-dom',
  },
})
