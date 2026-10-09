// Sürüm numarasını package.json'dan tüm görünen yerlere yazar.
// `npm version x.y.z` bunu kendiliğinden çalıştırır (package.json > scripts.version).
// Elle: node tools/set-version.mjs
import { readFile, writeFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const { version } = JSON.parse(await readFile(path.join(root, 'package.json'), 'utf8'));
const SEMVER = String.raw`\d+\.\d+\.\d+`;
const rules = [
  ['kit/js/mhud.js', new RegExp(String.raw`(var MH = \{ version: ')${SEMVER}(')`), `$1${version}$2`],
  ['README.md', new RegExp(String.raw`(@streamemberplatform/mhud@)${SEMVER}`, 'g'), `$1${version}`],
  ['AI.md', new RegExp(String.raw`(# MHud |@streamemberplatform/mhud@)${SEMVER}`, 'g'), `$1${version}`],
  ['CHANGELOG.md', new RegExp(String.raw`(tam sürüm kullanın \(\`@)${SEMVER}`), `$1${version}`],
  ['.github/workflows/release.yml', new RegExp(String.raw`(git tag v)${SEMVER}( && git push origin v)${SEMVER}`), `$1${version}$2${version}`]
];
for (const [file, re, to] of rules) {
  const p = path.join(root, file);
  const src = await readFile(p, 'utf8');
  const out = src.replace(re, to);
  if (!re.test(src)) console.warn(`  ! ${file}: sürüm kalıbı bulunamadı`);
  if (out !== src) { await writeFile(p, out); console.log(`  ${file} -> ${version}`); }
}
