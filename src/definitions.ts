
import { PluginListenerHandle } from "@capacitor/core";

export interface FirebasePlugin {
  logEvent(options: { name: string, parameters: object }): Promise<void>;
  setUserProperty(options: { name: string, value: string }): Promise<void>;
  setUserId(options: { userId: string }): Promise<void>;
  setScreenName(options: { screenName: string, screenClassOverride?: string }): Promise<void>;
  activateFetched(): Promise<{activated: boolean}>;
  // Cache time in seconds
  fetch(options?: { cache?: number }): Promise<void>;
  getRemoteConfigValue(options: { key: string }): Promise<{value: string}>;
  getToken(): Promise<{token: string}>;
  addListener(eventName: 'dynamicDeeplinkOpen', listenerFunc: (action: DynamicDeeplinkOpen) => void): PluginListenerHandle;
}

export interface DynamicDeeplinkOpen {
  url: string;
}