"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.health = void 0;
const health = async (_, response) => {
    response.code(200).send('pong');
};
exports.health = health;
//# sourceMappingURL=health.js.map