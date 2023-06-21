import { WebPlugin } from '@capacitor/core';

import type { FirebasePlugin } from './definitions';

export class FirebaseWeb extends WebPlugin implements FirebasePlugin {

  async logEvent(options: { name: string; parameters: any; }): Promise<void> {
    console.log(options);
    throw this.unimplemented('Not implemented on web.');
  }

  async setUserProperty(options: { name: string; value: string; }): Promise<void> {
    console.log(options);
    throw this.unimplemented('Not implemented on web.');
  }

  async setUserId(options: { userId: string; }): Promise<void> {
    console.log(options);
    throw this.unimplemented('Not implemented on web.');
  }

  async setScreenName(options: { screenName: string; screenClassOverride?: string; }): Promise<void> {
    console.log(options);
    throw this.unimplemented('Not implemented on web.');
  }

  async getAppInstanceID(): Promise<{ value: string; }> {
    throw this.unimplemented('Not implemented on web.');
  }

  async activateFetched(): Promise<{ activated: boolean; }> {
    throw this.unimplemented('Not implemented on web.');
  }

  async fetch(options?: { cache?: number }): Promise<void> {
    console.log(options);
    throw this.unimplemented('Not implemented on web.');
  }

  async getRemoteConfigValue(options: { key: string; }): Promise<{ value: string; }> {
    console.log(options);
    throw this.unimplemented('Not implemented on web.');
  }

  async getToken(): Promise<{ token: string; }> {
    throw this.unimplemented('Not implemented on web.');
  }

  async setDefaults(options: { defaults: Record<string, any>; }): Promise<void> {
    console.log(options);
    throw this.unimplemented('Not implemented on web.');
  }

}