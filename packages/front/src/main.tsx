import CssBaseline from '@mui/material/CssBaseline'
import React from 'react'
import { createRoot } from 'react-dom/client'
const container = document.getElementById('root')
import { BrowserRouter } from 'react-router-dom'

import App from './App'

if (container) {
  const root = createRoot(container)
  root.render(
    <BrowserRouter>
      <CssBaseline />
      <App />
    </BrowserRouter>
  )
}
