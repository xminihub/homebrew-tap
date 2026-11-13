class Lim < Formula
  desc "TUI for dsh and others"
  homepage "https://github.com/xminihub/limulin"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xminihub/limulin/releases/download/v0.3.3/lim-0.3.3-darwin-arm64.tar.gz"
      sha256 "6174cd71427d4e8f4a69ff7b4eed588e7af6ca91765178e91912353a4bc978ec"
    else
      url "https://github.com/xminihub/limulin/releases/download/v0.3.3/lim-0.3.3-darwin-x64.tar.gz"
      sha256 "ff812db6cac68d28ba65f3bbb7e1734615ac8c2e48da5cf71432f31752b35bac"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xminihub/limulin/releases/download/v0.3.3/lim-0.3.3-linux-aarch64.tar.gz"
      sha256 "2dcef25b1e4101cebbd2a2c536b5a2367ee2c75803138b5c0eb00dc8aa6374dc"
    else
      url "https://github.com/xminihub/limulin/releases/download/v0.3.3/lim-0.3.3-linux-x64.tar.gz"
      sha256 "b0825e98e29e80c93bf55ef007c0985a0a46f2c94ddfdd4d38fe24c1a3355632"
    end
  end

  def install
    bin.install "lim"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lim --version")
  end
end
