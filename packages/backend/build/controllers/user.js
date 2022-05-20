"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.helloWorld = void 0;
const helloWorld = async (_, response) => {
    try {
        response.code(200).send();
    }
    catch (err) {
        response.code(500).send(new Error(err));
    }
};
exports.helloWorld = helloWorld;
//# sourceMappingURL=user.js.map