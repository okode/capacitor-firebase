import { WebPlugin } from '@capacitor/core';
export class FirebaseWeb extends WebPlugin {
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
    async setDefaults(options) {
        console.log(options);
        throw this.unimplemented('Not implemented on web.');
    }
}
//# sourceMappingURL=web.js.map