import { registerPlugin } from '@capacitor/core';

import type { FirebasePlugin } from './definitions';

const Firebase = registerPlugin<FirebasePlugin>('Firebase', {
    web: () => import('./web').then(m => new m.FirebaseWeb()),
});

export * from './definitions';
export { Firebase };