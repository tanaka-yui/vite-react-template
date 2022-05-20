declare function cwr(operation: string, payload: any): void

export const infoLog = (tag: string, ...data: any[]) => {
  console.log(`[INFO] ${tag}`, data) // eslint-disable-line no-console
}

export const debugLog = (tag: string, ...data: any[]) => {
  if (import.meta.env.VITE_DEBUG === 'true') {
    console.log(`[DEBUG] ${tag}`, data) // eslint-disable-line no-console
  }
}

export const warnLog = (tag: string, ...data: any[]) => {
  if (import.meta.env.VITE_DEBUG === 'true') {
    console.warn(`[WARN] ${tag}`, data) // eslint-disable-line no-console
  }
}

export const errorLog = (err: any, tag?: string): void => {
  let e: Error
  if (err instanceof Error) {
    e = err
  } else if (err instanceof Response) {
    e = new Error(`${err.url} ${err.status} (${err.statusText})`)
  } else {
    e = new Error(err)
  }

  if (tag) {
    e.message = `${tag}: ${e.message}`
  }

  console.error(e) // eslint-disable-line no-console
  if (typeof cwr === 'function') {
    cwr('recordError', e)
  }
}
