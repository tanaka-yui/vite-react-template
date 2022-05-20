import fastify from 'fastify'

import Hooks from './plugins/hooks'
import healthRouter from './routes/health'
import userRouter from './routes/user'

// Load env vars
export const createServer = async () => {
  const server = fastify({
    logger: { level: process.env.LOG_LEVEL },
  })

  // custom middleware, routes, hooks
  // check user router for how to use middleware function into api request

  // third party packages
  server.register(require('fastify-helmet'))

  // API routers
  server.register(Hooks)
  server.register(healthRouter)
  server.register(userRouter, { prefix: '/api/user' })

  return server
}

export const startServer = async () => {
  const server = await createServer()

  await server.listen(process.env.API_PORT || 8080, process.env.API_HOST || '0.0.0.0')

  process.on('unhandledRejection', (err) => {
    console.error(err)
    process.exit(1)
  })
}

startServer()
