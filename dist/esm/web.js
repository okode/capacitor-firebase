import { WebPlugin } from '@capacitor/core';
export class FirebaseWeb extends WebPlugin {
    constructor() {
        super({
            name: 'FirebasePlugin',
            platforms: ['web']
        });
    }
    logEvent(options) {
        console.log(options);
        throw new Error('Method not implemented.');
    }
    setUserProperty(options) {
        console.log(options);
        throw new Error('Method not implemented.');
    }
    setUserId(options) {
        console.log(options);
        throw new Error('Method not implemented.');
    }
    setScreenName(options) {
        console.log(options);
        throw new Error('Method not implemented.');
    }
    activateFetched() {
        throw new Error('Method not implemented.');
    }
    fetch(options) {
        console.log(options);
        throw new Error('Method not implemented.');
    }
    getRemoteConfigValue(options) {
        console.log(options);
        throw new Error('Method not implemented.');
    }
}
const Firebase = new FirebaseWeb();
export { Firebase };
import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(Firebase);
//# sourceMappingURL=web.js.map