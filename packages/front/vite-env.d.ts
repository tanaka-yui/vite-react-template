/// <reference types="vite/src" />
interface ImportMetaEnv {
  readonly VITE_DEBUG: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
