"use strict";
// declare plugins here and register this file into index.ts to use
Object.defineProperty(exports, "__esModule", { value: true });
async function Hooks(fastify) {
    fastify.addHook('preHandler', (request, reply, next) => {
        console.log(request.body);
        next();
    });
}
exports.default = Hooks;
//# sourceMappingURL=hooks.js.map