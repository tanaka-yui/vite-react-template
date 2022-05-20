"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.startServer = exports.createServer = void 0;
const fastify_1 = __importDefault(require("fastify"));
const hooks_1 = __importDefault(require("./plugins/hooks"));
const health_1 = __importDefault(require("./routes/health"));
const user_1 = __importDefault(require("./routes/user"));
// Load env vars
const createServer = async () => {
    const server = (0, fastify_1.default)({
        logger: { level: process.env.LOG_LEVEL },
    });
    // custom middleware, routes, hooks
    // check user router for how to use middleware function into api request
    // third party packages
    server.register(require('fastify-helmet'));
    // API routers
    server.register(hooks_1.default);
    server.register(health_1.default);
    server.register(user_1.default, { prefix: '/api/user' });
    return server;
};
exports.createServer = createServer;
const startServer = async () => {
    const server = await (0, exports.createServer)();
    await server.listen(process.env.API_PORT || 8080, process.env.API_HOST || '0.0.0.0');
    process.on('unhandledRejection', (err) => {
        console.error(err);
        process.exit(1);
    });
};
exports.startServer = startServer;
(0, exports.startServer)();
//# sourceMappingURL=index.js.map