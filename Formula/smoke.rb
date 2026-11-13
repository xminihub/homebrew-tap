class Smoke < Formula
  desc "Scratch tool that exercises the bump path"
  homepage "https://github.com/xminihub/homebrew-tap"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xminihub/homebrew-tap/releases/download/v0.0.4/smoke-0.0.4-darwin-arm64.tar.gz"
      sha256 "1387a9eb3c00205611e743d4ad4b3bcace1b49151299ce3bfd953811d3f10a3c"
    else
      url "https://github.com/xminihub/homebrew-tap/releases/download/v0.0.4/smoke-0.0.4-darwin-x64.tar.gz"
      sha256 "e6021079b5b59ce2a6f10b19a678163e30cfc2333ef47f7974e72a946c17f3fb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xminihub/homebrew-tap/releases/download/v0.0.4/smoke-0.0.4-linux-aarch64.tar.gz"
      sha256 "047cd9d82153b9649af49278b3232b6b210feeb46827040e7f9c21fb49bef634"
    else
      url "https://github.com/xminihub/homebrew-tap/releases/download/v0.0.4/smoke-0.0.4-linux-x64.tar.gz"
      sha256 "c03ed4f4f9d58c9dd534b11517291eef61241f77c385b36ff0f740922022dc54"
    end
  end

  def install
    bin.install "smoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smoke --version")
  end
end
