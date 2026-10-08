// kit/ ve games/ klasörlerini FiveM/RedM resource'unun html/ klasörüne kopyalar.
// kit/ ve games/ tek doğru kaynaktır; integration/mhud/html/{kit,games} git'e girmez.
// Kullanım: npm run sync
import { cp, rm } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const html = path.join(root, 'integration', 'mhud', 'html');
for (const dir of ['kit', 'games']) {
  const dst = path.join(html, dir);
  await rm(dst, { recursive: true, force: true });
  await cp(path.join(root, dir), dst, { recursive: true, filter: src => !src.endsWith('README.md') || dir !== 'games' });
  console.log(`${dir}/ -> integration/mhud/html/${dir}/`);
}
