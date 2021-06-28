import { WebPlugin } from '@capacitor/core';

import type { FirebasePlugin } from './definitions';

export class FirebaseWeb extends WebPlugin implements FirebasePlugin {

  logEvent(options: { name: string; parameters: object; }): Promise<void> {
    console.log(options);
    return Promise.reject('Method not implemented.');
  }

  setUserProperty(options: { name: string; value: string; }): Promise<void> {
    console.log(options);
    return Promise.reject('Method not implemented.');
  }

  setUserId(options: { userId: string; }): Promise<void> {
    console.log(options);
    return Promise.reject('Method not implemented.');
  }

  setScreenName(options: { screenName: string; screenClassOverride?: string; }): Promise<void> {
    console.log(options);
    return Promise.reject('Method not implemented.');
  }

  activateFetched(): Promise<{ activated: boolean; }> {
    return Promise.reject('Method not implemented.');
  }

  fetch(options?: { cache?: number }): Promise<void> {
    console.log(options);
    return Promise.reject('Method not implemented.');
  }

  getRemoteConfigValue(options: { key: string; }): Promise<{ value: string; }> {
    console.log(options);
    return Promise.reject('Method not implemented.');
  }

  getToken(): Promise<{ token: string; }> {
    return Promise.reject('Method not implemented.');
  }

}