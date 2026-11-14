#!/usr/bin/env node
// The single source of a tool's asset names and generated formula.
//
// usage:
//   node scripts/render.mjs assets <name> <version>
//       -> {"darwin-arm64": "<bin>-<version>-darwin-arm64.tar.gz", ...}
//   node scripts/render.mjs formula <name> <version> <checksums.json> <out>
//
// The release workflow of a product asks for `assets` and uploads exactly
// those names; the bump workflow downloads them, checksums them and hands the
// map back for `formula`. Target names therefore exist in one file only.

import { readFileSync, writeFileSync } from "node:fs";

const [command, name, version, third, fourth] = process.argv.slice(2);
if (!command || !name || !version) {
  console.error(
    "usage: node scripts/render.mjs assets <name> <version>\n" +
      "       node scripts/render.mjs formula <name> <version> <checksums.json> <out>",
  );
  process.exit(1);
}

const tool = JSON.parse(readFileSync(`tools/${name}.json`, "utf8"));
const assetName = (target) => `${tool.bin}-${version}-${target}.tar.gz`;

// A brew target is an npm-convention `<os>-<cpu>` name (ADR-0001): the os half
// picks the formula block, the cpu half the Hardware::CPU branch inside it.
// Both are read out of tools/<name>.json rather than mirrored here, because a
// second copy of the vocabulary is how linux/arm64 went missing from a formula
// while this file still spelled it `aarch64`. A target that maps to no branch
// fails the bump instead of being dropped: omitting its url block would hand
// those users the other architecture's binary.
const BLOCKS = [
  { dir: "on_macos", os: "darwin" },
  { dir: "on_linux", os: "linux" },
];
const BRANCHES = { arm64: "arm", x64: "x86" };
const RENDERABLE = BLOCKS.flatMap(({ os }) =>
  Object.keys(BRANCHES).map((cpu) => `${os}-${cpu}`),
);

const plan = tool.brewTargets.map((target) => {
  const [os, cpu] = target.split("-");
  const dir = BLOCKS.find((block) => block.os === os)?.dir;
  const branch = BRANCHES[cpu];
  if (!dir || !branch) {
    throw new Error(
      `tools/${name}.json declares brew target ${target}, which this tap cannot ` +
        `render; expected one of ${RENDERABLE.join(", ")}`,
    );
  }
  return { dir, branch, target };
});

const claimed = new Set();
for (const { dir, branch, target } of plan) {
  const slot = `${dir} ${branch}`;
  if (claimed.has(slot)) {
    throw new Error(
      `tools/${name}.json declares more than one brew target for ${slot}`,
    );
  }
  claimed.add(slot);
}

if (command === "assets") {
  const map = {};
  for (const { target } of plan) {
    map[target] = assetName(target);
  }
  console.log(JSON.stringify(map));
} else {
  if (command !== "formula") {
    console.error(`unknown command: ${command}`);
    process.exit(1);
  }
  formulaCommand();
}

function formulaCommand() {
if (!third || !fourth) {
  console.error(
    "usage: node scripts/render.mjs formula <name> <version> <checksums.json> <out>",
  );
  process.exit(1);
}

const checksums = JSON.parse(readFileSync(third, "utf8"));
const urlFor = (target) =>
  `https://github.com/${tool.repo}/releases/download/v${version}/${assetName(target)}`;
const shaFor = (target) => {
  const sha = checksums[target];
  if (!/^[0-9a-f]{64}$/.test(sha ?? "")) {
    throw new Error(`no sha256 for brew target ${target}`);
  }
  return sha;
};
const lines = (target, indent) => {
  const pad = " ".repeat(indent);
  return [`${pad}url "${urlFor(target)}"`, `${pad}sha256 "${shaFor(target)}"`];
};

const blocks = BLOCKS.map(({ dir }) => {
  const entries = plan.filter((entry) => entry.dir === dir);
  if (entries.length === 0) return null;
  const arm = entries.find((entry) => entry.branch === "arm")?.target;
  const x86 = entries.find((entry) => entry.branch === "x86")?.target;

  const inner = [];
  if (arm && x86) {
    inner.push("    if Hardware::CPU.arm?");
    inner.push(...lines(arm, 6), "    else", ...lines(x86, 6), "    end");
  } else {
    inner.push(...lines(arm ?? x86, 4));
  }
  return `  ${dir} do\n${inner.join("\n")}\n  end`;
})
  .filter(Boolean)
  .join("\n\n");

if (!blocks) {
  throw new Error(
    `tools/${name}.json declares no brew target in ${RENDERABLE.join(", ")}`,
  );
}

const formula = readFileSync(`templates/${name}.rb.tpl`, "utf8")
  .replaceAll("{{CLASS}}", tool.class)
  .replaceAll("{{DESC}}", tool.desc)
  .replaceAll("{{HOMEPAGE}}", tool.homepage)
  .replaceAll("{{LICENSE}}", tool.license)
  .replaceAll("{{BIN}}", tool.bin)
  .replaceAll("{{BLOCKS}}", blocks);

writeFileSync(fourth, formula);
console.log(`rendered ${fourth} for ${name} ${version}`);
}
