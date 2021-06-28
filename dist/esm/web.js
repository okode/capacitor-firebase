import { WebPlugin } from '@capacitor/core';
export class FirebaseWeb extends WebPlugin {
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
//# sourceMappingURL=web.js.map