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
      url "https://github.com/xminihub/limulin/releases/download/v0.4.5/lim-0.4.5-darwin-arm64.tar.gz"
      sha256 "f4cc5cb4b880806ed30cebfcdbb7d373b72bc883c11123f2eee1f9cdaf3b790e"
    else
      url "https://github.com/xminihub/limulin/releases/download/v0.4.5/lim-0.4.5-darwin-x64.tar.gz"
      sha256 "b126b19b8199589b705a2bdecad5980b64c977ae4e2deea05fff3dd85d00128b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xminihub/limulin/releases/download/v0.4.5/lim-0.4.5-linux-arm64.tar.gz"
      sha256 "7c25ac16fae5f154efd20ce729947099fd13bf2b26cdee9fee93012e2d097d3a"
    else
      url "https://github.com/xminihub/limulin/releases/download/v0.4.5/lim-0.4.5-linux-x64.tar.gz"
      sha256 "640110b4a40f02af602d675ca9bc6f0a3a59da905a31cbcea6f5669f66bbf73d"
    end
  end

  def install
    bin.install "lim"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lim --version")
  end
end
