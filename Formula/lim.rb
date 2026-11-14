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
      url "https://github.com/xminihub/limulin/releases/download/v0.4.3/lim-0.4.3-darwin-arm64.tar.gz"
      sha256 "c6582e85bb2c59f9cf88868d00de2c9483d954e937a21c9a8404d23039afecd0"
    else
      url "https://github.com/xminihub/limulin/releases/download/v0.4.3/lim-0.4.3-darwin-x64.tar.gz"
      sha256 "8ee2079c9d62fc62588c8dec365bdbdaa26304003fbfef0c0f9e1112909f885d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xminihub/limulin/releases/download/v0.4.3/lim-0.4.3-linux-arm64.tar.gz"
      sha256 "c0f2b44bae3033b6e78be0562891e4d10bc6872615c756aef43981c99a164251"
    else
      url "https://github.com/xminihub/limulin/releases/download/v0.4.3/lim-0.4.3-linux-x64.tar.gz"
      sha256 "9195613690dc7d7db290556d3549478f91f120b5f9674a2932743da9888bab6e"
    end
  end

  def install
    bin.install "lim"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lim --version")
  end
end
