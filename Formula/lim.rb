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
      url "https://github.com/xminihub/limulin/releases/download/v0.4.4/lim-0.4.4-darwin-arm64.tar.gz"
      sha256 "09e19178feb3fe4ba4b3703b1516686872a60ecdb733650abf54ac51ad429189"
    else
      url "https://github.com/xminihub/limulin/releases/download/v0.4.4/lim-0.4.4-darwin-x64.tar.gz"
      sha256 "cfa667728e15d4674f707e3567b3a2809b77b88b5f0c108e095051304f7ffe4f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xminihub/limulin/releases/download/v0.4.4/lim-0.4.4-linux-arm64.tar.gz"
      sha256 "b2fb645fffc5acad932bcab2301217ecff672f93adfbaaf6f7ed64856ae6107e"
    else
      url "https://github.com/xminihub/limulin/releases/download/v0.4.4/lim-0.4.4-linux-x64.tar.gz"
      sha256 "bedf41aba7947377b1b4852f39fa906ac06ab3e98f1257cc105f2af8d925dd46"
    end
  end

  def install
    bin.install "lim"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lim --version")
  end
end
