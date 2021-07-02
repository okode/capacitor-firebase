import { registerPlugin } from '@capacitor/core';
const Firebase = registerPlugin('Firebase', {
    web: () => import('./web').then(m => new m.FirebaseWeb()),
});
export * from './definitions';
export { Firebase };
//# sourceMappingURL=index.js.map