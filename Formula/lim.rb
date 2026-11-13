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
      url "https://github.com/xminihub/limulin/releases/download/v0.3.4/lim-0.3.4-darwin-arm64.tar.gz"
      sha256 "fdce80b9d993f9f5e01ce96e7998745e0177886e35b38ec8bcbf5e8829ffd45c"
    else
      url "https://github.com/xminihub/limulin/releases/download/v0.3.4/lim-0.3.4-darwin-x64.tar.gz"
      sha256 "692d53f7bbc4f5f7542a40429983c008b7684b8996038628cf6167339a9c36b6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xminihub/limulin/releases/download/v0.3.4/lim-0.3.4-linux-aarch64.tar.gz"
      sha256 "b9fca4dc9ebcdcd4fe275566fb8f669a6e4d390b09191230c663ce9be2a6145d"
    else
      url "https://github.com/xminihub/limulin/releases/download/v0.3.4/lim-0.3.4-linux-x64.tar.gz"
      sha256 "3f945ef92ad0c490d9163a5a4a5c156928f164cf2295d09ddc8bc05da51964f4"
    end
  end

  def install
    bin.install "lim"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lim --version")
  end
end
