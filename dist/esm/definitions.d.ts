declare module '@capacitor/core' {
    interface PluginRegistry {
        Firebase: FirebasePlugin;
    }
}
export interface FirebasePlugin {
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
    fetch(): Promise<void>;
    getRemoteConfigValue(options: {
        key: string;
    }): Promise<{
        value: string;
    }>;
}
