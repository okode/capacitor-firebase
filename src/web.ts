import { WebPlugin } from '@capacitor/core';
import { FirebasePlugin } from './definitions';

export class FirebaseWeb extends WebPlugin implements FirebasePlugin {

  constructor() {
    super({
      name: 'FirebasePlugin',
      platforms: ['web']
    });
  }

  logEvent(options: { name: string; parameters: object; }): Promise<void> {
    console.log(options);
    throw new Error('Method not implemented.');
  }

  setUserProperty(options: { name: string; value: string; }): Promise<void> {
    console.log(options);
    throw new Error('Method not implemented.');
  }

  setUserId(options: { userId: string; }): Promise<void> {
    console.log(options);
    throw new Error('Method not implemented.');
  }

  setScreenName(options: { screenName: string; screenClassOverride?: string; }): Promise<void> {
    console.log(options);
    throw new Error('Method not implemented.');
  }

  activateFetched(): Promise<{ activated: boolean; }> {
    throw new Error('Method not implemented.');
  }

  fetch(options?: { cache?: number }): Promise<void> {
    console.log(options);
    throw new Error('Method not implemented.');
  }

  getRemoteConfigValue(options: { key: string; }): Promise<{ value: string; }> {
    console.log(options);
    throw new Error('Method not implemented.');
  }

}

const Firebase = new FirebaseWeb();

export { Firebase };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(Firebase);
