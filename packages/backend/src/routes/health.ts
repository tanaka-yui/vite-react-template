import { FastifyInstance } from 'fastify'

import * as controllers from '../controllers'

const useRouter = async (fastify: FastifyInstance) => {
  fastify.decorateRequest('authUser', '')

  fastify.route({
    method: 'GET',
    url: '/health',
    preHandler: [],
    handler: controllers.health,
  })
}
export default useRouter
