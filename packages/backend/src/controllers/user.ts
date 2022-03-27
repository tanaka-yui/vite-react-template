import { FastifyReply, FastifyRequest } from 'fastify'

export const helloWorld = async (_: FastifyRequest, response: FastifyReply) => {
  try {
    response.code(200).send()
  } catch (err) {
    response.code(500).send(new Error(err))
  }
}
