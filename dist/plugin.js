var capacitorExitApp = (function (exports, core) {
    'use strict';

    const Firebase = core.registerPlugin('Firebase', {
        web: () => Promise.resolve().then(function () { return web; }).then(m => new m.FirebaseWeb()),
    });

    class FirebaseWeb extends core.WebPlugin {
        async logEvent(options) {
            console.log(options);
            throw this.unimplemented('Not implemented on web.');
        }
        async setUserProperty(options) {
            console.log(options);
            throw this.unimplemented('Not implemented on web.');
        }
        async setUserId(options) {
            console.log(options);
            throw this.unimplemented('Not implemented on web.');
        }
        async setScreenName(options) {
            console.log(options);
            throw this.unimplemented('Not implemented on web.');
        }
        async getAppInstanceID() {
            throw this.unimplemented('Not implemented on web.');
        }
        async activateFetched() {
            throw this.unimplemented('Not implemented on web.');
        }
        async fetch(options) {
            console.log(options);
            throw this.unimplemented('Not implemented on web.');
        }
        async getRemoteConfigValue(options) {
            console.log(options);
            throw this.unimplemented('Not implemented on web.');
        }
        async getToken() {
            throw this.unimplemented('Not implemented on web.');
        }
    }

    var web = /*#__PURE__*/Object.freeze({
        __proto__: null,
        FirebaseWeb: FirebaseWeb
    });

    exports.Firebase = Firebase;

    Object.defineProperty(exports, '__esModule', { value: true });

    return exports;

})({}, capacitorExports);
//# sourceMappingURL=plugin.js.map
