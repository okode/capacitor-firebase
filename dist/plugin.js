var capacitorExitApp = (function (exports, core) {
    'use strict';

    const Firebase = core.registerPlugin('Firebase', {
        web: () => Promise.resolve().then(function () { return web; }).then(m => new m.FirebaseWeb()),
    });

    class FirebaseWeb extends core.WebPlugin {
        logEvent(options) {
            console.log(options);
            return Promise.reject('Method not implemented.');
        }
        setUserProperty(options) {
            console.log(options);
            return Promise.reject('Method not implemented.');
        }
        setUserId(options) {
            console.log(options);
            return Promise.reject('Method not implemented.');
        }
        setScreenName(options) {
            console.log(options);
            return Promise.reject('Method not implemented.');
        }
        activateFetched() {
            return Promise.reject('Method not implemented.');
        }
        fetch(options) {
            console.log(options);
            return Promise.reject('Method not implemented.');
        }
        getRemoteConfigValue(options) {
            console.log(options);
            return Promise.reject('Method not implemented.');
        }
        getToken() {
            return Promise.reject('Method not implemented.');
        }
    }

    var web = /*#__PURE__*/Object.freeze({
        __proto__: null,
        FirebaseWeb: FirebaseWeb
    });

    exports.Firebase = Firebase;

    Object.defineProperty(exports, '__esModule', { value: true });

    return exports;

}({}, capacitorExports));
//# sourceMappingURL=plugin.js.map
