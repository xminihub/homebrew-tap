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
      url "https://github.com/xminihub/homebrew-tap/releases/download/v0.0.5/smoke-0.0.5-darwin-arm64.tar.gz"
      sha256 "b22e6e765c1ff014f51f7c98afb1338277b607fb7ebf5f0a89f24d6b5350a385"
    else
      url "https://github.com/xminihub/homebrew-tap/releases/download/v0.0.5/smoke-0.0.5-darwin-x64.tar.gz"
      sha256 "e7df1fc7d70e003bc802c386128e48473f03c388c09a7f85f610e7af72f05146"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xminihub/homebrew-tap/releases/download/v0.0.5/smoke-0.0.5-linux-aarch64.tar.gz"
      sha256 "4c9d72ba42c8e0f4ddb834980469c2dd0d750d9456a86cac5a5772d95dab48cf"
    else
      url "https://github.com/xminihub/homebrew-tap/releases/download/v0.0.5/smoke-0.0.5-linux-x64.tar.gz"
      sha256 "bf8591162f3a576e8ac0877bb8d0e5ce93af538ccbc4319d7eee46d6b6403e7c"
    end
  end

  def install
    bin.install "smoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smoke --version")
  end
end
