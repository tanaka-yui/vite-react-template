import * as path from 'path'
import { fileURLToPath } from 'url'

import react from '@vitejs/plugin-react'
import { visualizer } from 'rollup-plugin-visualizer'
import { defineConfig, UserConfig, loadEnv } from 'vite'

const genCfg = (mode: string): UserConfig => {
  const env = loadEnv(mode, process.cwd())

  const cfg: UserConfig = {
    envDir: path.join(__dirname, './'),
    root: './',
    plugins: [react()],
    resolve: {
      alias: {
        '~': fileURLToPath(new URL('./src', import.meta.url)),
      },
    },
    build: {
      sourcemap: env.VITE_SOURCE_MAP === 'true',
      chunkSizeWarningLimit: 1000,
      rollupOptions: {
        plugins: [
          /* @ts-ignore */
          mode === 'analyze' &&
            visualizer({
              open: true,
              filename: 'dist-dev/stats.html',
              gzipSize: true,
              brotliSize: true,
            }),
        ],
      },
    },
  }

  return cfg
}

export default defineConfig(({ mode }) => {
  return genCfg(mode)
})
