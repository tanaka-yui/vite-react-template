import Button from '@mui/material/Button'
import TextField from '@mui/material/TextField'
import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'

const Index: React.FC = () => {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')

  const navigate = useNavigate()

  const loginUser = async () => {
    try {
      navigate('/home')
    } catch (e) {
      console.error(e)
      setError('ログインに失敗しました')
    }
  }

  return (
    <div>
      <div>
        Email:
        <TextField value={email} onChange={(e) => setEmail(e.target.value)} />
      </div>
      <div>
        Password:
        <TextField type="password" value={password} onChange={(e) => setPassword(e.target.value)} />
      </div>
      <Button onClick={loginUser}>ログイン</Button>
      {error && <p>{error}</p>}
    </div>
  )
}

export default Index
