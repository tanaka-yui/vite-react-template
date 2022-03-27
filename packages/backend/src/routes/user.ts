import { FastifyInstance } from 'fastify'

import * as controllers from '../controllers'

const useRouter = async (fastify: FastifyInstance) => {
  fastify.decorateRequest('authUser', '')

  fastify.route({
    method: 'GET',
    url: '/hello',
    preHandler: [],
    handler: controllers.helloWorld,
  })
}
export default useRouter
