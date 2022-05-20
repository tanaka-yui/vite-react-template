import React from 'react'
import { Route, Routes } from 'react-router-dom'

import './App.css'

import Index from '~/components/pages'

const App: React.FC = () => {
  return (
    <div className="App">
      <Routes>
        <Route path="/" element={<Index />} />
      </Routes>
    </div>
  )
}

export default App
