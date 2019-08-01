import { WebPlugin } from '@capacitor/core';
import { FirebasePlugin } from './definitions';
export declare class FirebaseWeb extends WebPlugin implements FirebasePlugin {
    constructor();
    logEvent(options: {
        name: string;
        parameters: object;
    }): Promise<void>;
    setUserProperty(options: {
        name: string;
        value: string;
    }): Promise<void>;
    setUserId(options: {
        userId: string;
    }): Promise<void>;
    setScreenName(options: {
        screenName: string;
        screenClassOverride?: string;
    }): Promise<void>;
    activateFetched(): Promise<{
        activated: boolean;
    }>;
    fetch(options?: {
        cache?: number;
    }): Promise<void>;
    getRemoteConfigValue(options: {
        key: string;
    }): Promise<{
        value: string;
    }>;
    getToken(): Promise<{
        token: string;
    }>;
}
declare const Firebase: FirebaseWeb;
export { Firebase };
