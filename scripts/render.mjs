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

if (command === "assets") {
  const map = {};
  for (const target of tool.brewTargets) {
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

const GROUPS = [
  { dir: "on_macos", arm: "darwin-arm64", x86: "darwin-x64" },
  { dir: "on_linux", arm: "linux-aarch64", x86: "linux-x64" },
];

const blocks = GROUPS.map((group) => {
  const arm = tool.brewTargets.includes(group.arm) ? group.arm : null;
  const x86 = tool.brewTargets.includes(group.x86) ? group.x86 : null;
  if (!arm && !x86) return null;

  const inner = [];
  if (arm && x86) {
    inner.push("    if Hardware::CPU.arm?");
    inner.push(...lines(arm, 6), "    else", ...lines(x86, 6), "    end");
  } else {
    inner.push(...lines(arm ?? x86, 4));
  }
  return `  ${group.dir} do\n${inner.join("\n")}\n  end`;
})
  .filter(Boolean)
  .join("\n\n");

if (!blocks) {
  throw new Error(
    `tools/${name}.json declares no brew target in ${GROUPS.flatMap((g) => [g.arm, g.x86]).join(", ")}`,
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
