#!/usr/bin/env node
// Render one formula from its tool config, the release checksums and a template.
//
// usage: node scripts/render.mjs <name> <version> <assets.json> <out>
//
// assets.json maps a brew target to the sha256 of the published asset. Target
// names are derived here and only here: they are the contract between a
// product's release assets and the URL blocks this formula pins.

import { readFileSync, writeFileSync } from "node:fs";

const [name, version, assetsPath, outPath] = process.argv.slice(2);
if (!name || !version || !assetsPath || !outPath) {
  console.error(
    "usage: node scripts/render.mjs <name> <version> <assets.json> <out>",
  );
  process.exit(1);
}

const tool = JSON.parse(readFileSync(`tools/${name}.json`, "utf8"));
const checksums = JSON.parse(readFileSync(assetsPath, "utf8"));

const assetName = (target) => `${tool.bin}-${version}-${target}.tar.gz`;
const urlFor = (target) =>
  `https://github.com/${tool.repo}/releases/download/v${version}/${assetName(target)}`;
const shaFor = (target) => {
  const sha = checksums[target];
  if (!/^[0-9a-f]{64}$/.test(sha ?? "")) {
    throw new Error(`no sha256 for target ${target}`);
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
  const arm = tool.targets.includes(group.arm) ? group.arm : null;
  const x86 = tool.targets.includes(group.x86) ? group.x86 : null;
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
  .replaceAll("{{REPO}}", tool.repo)
  .replaceAll("{{LICENSE}}", tool.license)
  .replaceAll("{{BIN}}", tool.bin)
  .replaceAll("{{VERSION}}", version)
  .replaceAll("{{LIVECHECK_REGEX}}", tool.livecheckRegex)
  .replaceAll("{{BLOCKS}}", blocks);

writeFileSync(outPath, formula);
console.log(`rendered ${outPath} for ${name} ${version}`);
