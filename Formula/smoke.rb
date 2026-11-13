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
      url "https://github.com/xminihub/homebrew-tap/releases/download/v0.0.2/smoke-0.0.2-darwin-arm64.tar.gz"
      sha256 "7649111ca225b807c0191b44c7b487a190cc1e5288a526d5830039cdce0ee6fd"
    else
      url "https://github.com/xminihub/homebrew-tap/releases/download/v0.0.2/smoke-0.0.2-darwin-x64.tar.gz"
      sha256 "e8b28721386cb6d5e01091ce26a7f56859f9a7157916bea7b04625317c01c103"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xminihub/homebrew-tap/releases/download/v0.0.2/smoke-0.0.2-linux-aarch64.tar.gz"
      sha256 "70942e1513a92cda567a39cdc2b5fda8a92a03ffeef8847666fee57b61245a9f"
    else
      url "https://github.com/xminihub/homebrew-tap/releases/download/v0.0.2/smoke-0.0.2-linux-x64.tar.gz"
      sha256 "aaafab903a976907279a177e154fb804b7b373b28b23c6496858d5122b588d57"
    end
  end

  def install
    bin.install "smoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smoke --version")
  end
end
