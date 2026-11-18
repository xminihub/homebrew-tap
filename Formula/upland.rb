class Upland < Formula
  desc "HTTP API server with an embedded web UI"
  homepage "https://github.com/xminihub/upland"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/xminihub/upland/releases/download/v0.1.6/upland-0.1.6-darwin-arm64.tar.gz"
      sha256 "5d30d8a0bfd437dc042d9d89fae1f551c8ad94eaf98442f2742def7152ef4b54"
    else
      url "https://github.com/xminihub/upland/releases/download/v0.1.6/upland-0.1.6-darwin-x64.tar.gz"
      sha256 "0851bb7489852cc717dfc9fcd6fc3bf704f6def8da68fb0e302d8f0f33557f79"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xminihub/upland/releases/download/v0.1.6/upland-0.1.6-linux-arm64.tar.gz"
      sha256 "a52246a2fff9390cac414ea2706ba2678f9a34808056b1c140de368c157aee12"
    else
      url "https://github.com/xminihub/upland/releases/download/v0.1.6/upland-0.1.6-linux-x64.tar.gz"
      sha256 "9ec64e1c424c0b8418719a4393ddd9bb78b0c9605569d5ee817566465087dfe5"
    end
  end

  def install
    bin.install "upland"
  end

  service do
    run [opt_bin/"upland", "--host", "127.0.0.1", "--port", "8310"]
    keep_alive true
    working_dir var
    log_path var/"log/upland.log"
    error_log_path var/"log/upland.log"
  end

  def caveats
    <<~EOS
      upland is a server. `brew services start upland` runs it on
      http://127.0.0.1:8310 - the tap's port, kept clear of the 8080 a
      developer's `cargo run` is already holding. Stop it with
      `brew services stop upland`; `upland` alone runs in the foreground.
      The port lives in the generated service unit, not in upland's flags:
      changing it means editing that unit and restarting the service.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/upland --version")
  end
end
