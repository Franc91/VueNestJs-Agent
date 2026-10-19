#!/usr/bin/env node
/**
 * Copy this bundle into a host workspace without deleting `.cursor/`.
 * Only files that belong to this bundle are overwritten. Anything else
 * (another agent's skill, rule, mcp.json) stays in place.
 * AGENTS.md blocks marked <!-- name:begin --> ... <!-- name:end -->
 * are put back when this bundle's AGENTS.md does not already contain them.
 */
import {
  cpSync,
  existsSync,
  lstatSync,
  mkdirSync,
  readdirSync,
  readFileSync,
  rmSync,
  writeFileSync,
} from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const KIT_ROOT = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const BLOCK_RE = /<!--\s*([\w-]+):begin\s*-->[\s\S]*?<!--\s*\1:end\s*-->/g;

function parseTarget(argv) {
  for (let i = 2; i < argv.length; i++) {
    if (argv[i] === "--target" && argv[i + 1]) return resolve(argv[i + 1]);
  }
  const configPath = join(KIT_ROOT, "install.config.json");
  if (!existsSync(configPath)) {
    throw new Error("Pass --target or set codeWorkspace in install.config.json");
  }
  const config = JSON.parse(readFileSync(configPath, "utf8"));
  if (!config.codeWorkspace) throw new Error("install.config.json must contain codeWorkspace");
  return resolve(config.codeWorkspace);
}

function childNames(dir) {
  return new Set(readdirSync(dir));
}

function hasForeignChild(hostPath, bundlePath) {
  const info = lstatSync(hostPath);
  if (!info.isDirectory() || info.isSymbolicLink()) return false;
  const bundleChildren = childNames(bundlePath);
  return [...childNames(hostPath)].some((name) => !bundleChildren.has(name));
}

function replacePath(bundlePath, hostPath) {
  if (existsSync(hostPath)) rmSync(hostPath, { recursive: true, force: true });
  mkdirSync(dirname(hostPath), { recursive: true });
  cpSync(bundlePath, hostPath, { recursive: true, force: true });
}

/** depth 0 is `.cursor/`. Deeper owned folders are replaced whole. */
function syncOwned(bundlePath, hostPath, depth) {
  const bundleInfo = lstatSync(bundlePath);
  if (!bundleInfo.isDirectory()) {
    mkdirSync(dirname(hostPath), { recursive: true });
    cpSync(bundlePath, hostPath, { force: true });
    return;
  }

  if (!existsSync(hostPath) || depth >= 2 || !hasForeignChild(hostPath, bundlePath)) {
    replacePath(bundlePath, hostPath);
    return;
  }

  for (const name of childNames(bundlePath)) {
    syncOwned(join(bundlePath, name), join(hostPath, name), depth + 1);
  }
}

function markerBlocks(text) {
  return text ? [...text.matchAll(BLOCK_RE)].map((match) => match[0]) : [];
}

function mergeAgentBlocks(previous, next) {
  let merged = next;
  for (const block of markerBlocks(previous)) {
    const name = block.match(/<!--\s*([\w-]+):begin/)[1];
    if (new RegExp(`<!--\\s*${name}:begin\\s*-->`).test(merged)) continue;
    merged = `${merged.trimEnd()}\n\n${block.trim()}\n`;
    console.log(`Preserved AGENTS.md block: ${name}`);
  }
  return merged;
}

const target = parseTarget(process.argv);
if (!existsSync(target)) throw new Error(`Target path not found: ${target}`);

const bundleCursor = join(KIT_ROOT, ".cursor");
const hostCursor = join(target, ".cursor");
const agentsPath = join(target, "AGENTS.md");
const previousAgents = existsSync(agentsPath) ? readFileSync(agentsPath, "utf8") : "";

mkdirSync(hostCursor, { recursive: true });
syncOwned(bundleCursor, hostCursor, 0);

writeFileSync(agentsPath, readFileSync(join(KIT_ROOT, "AGENTS.md"), "utf8"));
cpSync(join(KIT_ROOT, "skills-lock.json"), join(target, "skills-lock.json"), { force: true });

const mergedAgents = mergeAgentBlocks(previousAgents, readFileSync(agentsPath, "utf8"));
if (mergedAgents !== readFileSync(agentsPath, "utf8")) {
  writeFileSync(agentsPath, mergedAgents);
}

const mcpTarget = join(hostCursor, "mcp.json");
const mcpExample = join(KIT_ROOT, "mcp.example.json");
if (!existsSync(mcpTarget) && existsSync(mcpExample)) {
  cpSync(mcpExample, mcpTarget);
  console.log("Created .cursor/mcp.json from mcp.example.json (configure if needed).");
}

console.log(`Installed agent setup to: ${target}`);
