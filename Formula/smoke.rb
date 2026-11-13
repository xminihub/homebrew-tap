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
      url "https://github.com/xminihub/homebrew-tap/releases/download/v0.0.3/smoke-0.0.3-darwin-arm64.tar.gz"
      sha256 "65c4c55806d54654f233b16a7fb35e89131a496b724b9d56f755014ec390183b"
    else
      url "https://github.com/xminihub/homebrew-tap/releases/download/v0.0.3/smoke-0.0.3-darwin-x64.tar.gz"
      sha256 "487df55392956cd53e83db2f413f8dfbc887e9526e6ac007fe93029e166dd2b6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xminihub/homebrew-tap/releases/download/v0.0.3/smoke-0.0.3-linux-aarch64.tar.gz"
      sha256 "0bf510914e0baad0b09d4f0383c3b1677ad784d567af7fa46a48894c56f2409d"
    else
      url "https://github.com/xminihub/homebrew-tap/releases/download/v0.0.3/smoke-0.0.3-linux-x64.tar.gz"
      sha256 "c6045b6ea07e7e2056d096af9fc75e8784548841dedc2988659596c6279c242c"
    end
  end

  def install
    bin.install "smoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smoke --version")
  end
end
