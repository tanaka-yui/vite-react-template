import { FastifyReply, FastifyRequest } from 'fastify'

export const health = async (_: FastifyRequest, response: FastifyReply) => {
  response.code(200).send('pong')
}
