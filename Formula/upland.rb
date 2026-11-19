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
      url "https://github.com/xminihub/upland/releases/download/v0.1.8/upland-0.1.8-darwin-arm64.tar.gz"
      sha256 "e276954b6e826057f0d2c392905aa39f91821eac88f5948a2a9c8a380f445c1d"
    else
      url "https://github.com/xminihub/upland/releases/download/v0.1.8/upland-0.1.8-darwin-x64.tar.gz"
      sha256 "82d0d186baed001c1badaf0cb2ee2ff1bc75e60993849624d46e05edc3f3ef4f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xminihub/upland/releases/download/v0.1.8/upland-0.1.8-linux-arm64.tar.gz"
      sha256 "e6626f2293403ebb9ac35cb6174ceb711110be7e29abdfe037dc647a6b73a124"
    else
      url "https://github.com/xminihub/upland/releases/download/v0.1.8/upland-0.1.8-linux-x64.tar.gz"
      sha256 "0f96c1d4a4ec96787ca6a3f181aa98850d849b2c443cf844facb62648dafa935"
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
