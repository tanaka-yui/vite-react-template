import React from 'react'
import { Routes, Route } from 'react-router-dom'

import Index from '~/components/pages/Index'
import Home from '~/components/pages/Home'

import './App.css'

const App: React.FC = () => {
  return (
    <div className="App">
      <Routes>
        <Route path="/" element={<Index />} />
        <Route path="/home" element={<Home />} />
      </Routes>
    </div>
  )
}

export default App
