#!/usr/bin/env node
/**
 * Agent docs validator — links, naming, skill structure, skills-lock ↔ cards.
 * Usage: node .cursor/scripts/validate-agent-links.mjs
 */
import { readFileSync, existsSync, readdirSync, statSync } from 'node:fs';
import { dirname, join, resolve, normalize, isAbsolute } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = resolve(__dirname, '../..');
const SKILLS_DIR = join(ROOT, '.cursor', 'skills');
const CARDS_DIR = join(ROOT, '.cursor', 'specialists', 'skills');

const DOC_ROOTS = [join(ROOT, 'AGENTS.md'), join(ROOT, '.cursor')];

const LINK_RE = /\[([^\]]*)\]\(([^)]+)\)/g;
const SKIP_SCHEMES = /^(https?:|mailto:|tel:|data:)/i;
const ROOT_PREFIXES = ['.cursor/', '.agents/', 'AGENTS.md', 'skills-lock.json'];

const STALE_NAMES = [
  { pattern: /\bvue-agents\b/g, hint: 'use platform-agents' },
  { pattern: /\bvue-review-agent\b/g, hint: 'use platform-review-agent' },
  { pattern: /\bvue-performance-agent\b/g, hint: 'use platform-performance-agent' },
];

const REQUIRED_SKILL_DIRS = [
  'platform-agents',
  'vue-component-creator',
  'vue-router-agent',
  'pinia-architect',
  'pinia-colada-expert',
  'data-grid-agent',
  'nestjs-api-agent',
  'platform-review-agent',
  'platform-performance-agent',
];

const FORBIDDEN_DIRS = ['vue-agents', 'vue-review-agent', 'vue-performance-agent', 'specialist-router'];

function rel(p) {
  return p.replace(ROOT + '\\', '').replace(ROOT + '/', '');
}

function walk(dir, acc = []) {
  for (const name of readdirSync(dir)) {
    const full = join(dir, name);
    const st = statSync(full);
    if (st.isDirectory()) {
      if (name === 'node_modules' || name === '.git') continue;
      walk(full, acc);
    } else if (/\.(md|mdc)$/.test(name)) {
      acc.push(full);
    }
  }
  return acc;
}

function collectDocs() {
  const files = new Set();
  for (const root of DOC_ROOTS) {
    if (!existsSync(root)) continue;
    if (statSync(root).isDirectory()) {
      walk(root).forEach((f) => files.add(f));
    } else {
      files.add(root);
    }
  }
  return [...files];
}

function isRootRelative(raw) {
  const normalized = raw.replace(/\\/g, '/');
  return ROOT_PREFIXES.some((p) => normalized === p || normalized.startsWith(p));
}

function resolveLink(fromFile, target) {
  const raw = target.trim();
  if (!raw || raw.startsWith('#') || SKIP_SCHEMES.test(raw)) return null;

  const withoutHash = raw.split('#')[0].split('?')[0];
  if (!withoutHash || withoutHash === '.') return null;

  if (isRootRelative(withoutHash) || withoutHash.startsWith('/')) {
    return normalize(join(ROOT, withoutHash.replace(/^\//, '')));
  }
  if (isAbsolute(withoutHash)) {
    return normalize(withoutHash);
  }
  return normalize(resolve(dirname(fromFile), withoutHash));
}

function isValidTarget(resolved) {
  if (!existsSync(resolved)) return false;
  return statSync(resolved).isDirectory() || statSync(resolved).isFile();
}

function checkStaleNames(docs) {
  const issues = [];
  for (const file of docs) {
    const content = readFileSync(file, 'utf8');
    for (const { pattern, hint } of STALE_NAMES) {
      pattern.lastIndex = 0;
      if (pattern.test(content)) {
        issues.push({ type: 'stale', file: rel(file), hint });
      }
    }
  }
  return issues;
}

function checkSkillDirs() {
  const issues = [];
  if (!existsSync(SKILLS_DIR)) {
    issues.push({ type: 'structure', path: '.cursor/skills/', hint: 'missing skills directory' });
    return issues;
  }

  for (const dir of FORBIDDEN_DIRS) {
    if (existsSync(join(SKILLS_DIR, dir))) {
      issues.push({ type: 'structure', path: `.cursor/skills/${dir}/`, hint: 'deprecated folder — remove or rename' });
    }
  }

  for (const dir of REQUIRED_SKILL_DIRS) {
    const skillFile = join(SKILLS_DIR, dir, 'SKILL.md');
    if (!existsSync(skillFile)) {
      issues.push({ type: 'structure', path: `.cursor/skills/${dir}/SKILL.md`, hint: 'required domain agent skill missing' });
    }
  }

  return issues;
}

function checkSkillsLock() {
  const lockPath = join(ROOT, 'skills-lock.json');
  if (!existsSync(lockPath)) {
    return [{ type: 'lock', path: 'skills-lock.json', hint: 'missing' }];
  }

  const lock = JSON.parse(readFileSync(lockPath, 'utf8'));
  const issues = [];
  const agentsDir = join(ROOT, '.agents', 'skills');

  for (const name of Object.keys(lock.skills ?? {})) {
    const card = join(CARDS_DIR, `${name}.md`);
    if (!existsSync(card)) {
      issues.push({ type: 'card', path: `.cursor/specialists/skills/${name}.md`, hint: 'skills-lock entry without card' });
    }
  }

  if (!existsSync(agentsDir)) {
    return issues;
  }

  const hasInstalledSkills = readdirSync(agentsDir).some((name) =>
    existsSync(join(agentsDir, name, 'SKILL.md')),
  );
  if (!hasInstalledSkills) {
    return issues;
  }

  for (const name of Object.keys(lock.skills ?? {})) {
    const skillFile = join(agentsDir, name, 'SKILL.md');
    if (!existsSync(skillFile)) {
      issues.push({ type: 'skill', path: `.agents/skills/${name}/SKILL.md`, hint: 'skills-lock entry not installed' });
    }
  }

  return issues;
}

const docs = collectDocs();
const broken = [];
const linksChecked = new Set();

for (const file of docs) {
  const content = readFileSync(file, 'utf8');
  let match;
  LINK_RE.lastIndex = 0;
  while ((match = LINK_RE.exec(content)) !== null) {
    const target = match[2];
    const resolved = resolveLink(file, target);
    if (!resolved) continue;

    const key = `${file} -> ${target}`;
    if (linksChecked.has(key)) continue;
    linksChecked.add(key);

    if (!isValidTarget(resolved)) {
      broken.push({
        type: 'link',
        file: rel(file),
        target,
        resolved: rel(resolved),
      });
    }
  }
}

broken.push(...checkStaleNames(docs));
broken.push(...checkSkillDirs());
broken.push(...checkSkillsLock());

if (broken.length === 0) {
  const agentsDir = join(ROOT, '.agents', 'skills');
  let agentsNote = 'supplementary not installed (run install-supplementary)';
  if (existsSync(agentsDir)) {
    const hasSkills = readdirSync(agentsDir).some((name) =>
      existsSync(join(agentsDir, name, 'SKILL.md')),
    );
    agentsNote = hasSkills ? 'supplementary installed' : 'placeholder only (run install-supplementary)';
  }
  console.log(`OK — ${docs.length} docs, ${linksChecked.size} links, structure + lock aligned (${agentsNote})`);
  process.exit(0);
}

console.error(`Found ${broken.length} issue(s):\n`);
for (const item of broken) {
  switch (item.type) {
    case 'link':
      console.error(`  LINK   ${item.file}`);
      console.error(`         → ${item.target}`);
      console.error(`         missing: ${item.resolved}\n`);
      break;
    case 'stale':
      console.error(`  STALE  ${item.file}`);
      console.error(`         ${item.hint}\n`);
      break;
    case 'structure':
    case 'card':
    case 'skill':
    case 'lock':
      console.error(`  ${item.type.toUpperCase()}  ${item.path}`);
      console.error(`         ${item.hint}\n`);
      break;
    default:
      console.error(`  ${JSON.stringify(item)}\n`);
  }
}
process.exit(1);
