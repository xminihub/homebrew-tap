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
      url "https://github.com/xminihub/upland/releases/download/v0.1.9/upland-0.1.9-darwin-arm64.tar.gz"
      sha256 "31b96777a3fed6dfce824c0da2ba2a4358d522d653a19fafab999c36b6feddbb"
    else
      url "https://github.com/xminihub/upland/releases/download/v0.1.9/upland-0.1.9-darwin-x64.tar.gz"
      sha256 "48d76a54ae1193f8ee1d55333893d3341a918720f8e7926dd99a674465832cbf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xminihub/upland/releases/download/v0.1.9/upland-0.1.9-linux-arm64.tar.gz"
      sha256 "1de38f599193002f6e7a34ece95e4ac6c85c5e690f6737ba41eb446e574540d9"
    else
      url "https://github.com/xminihub/upland/releases/download/v0.1.9/upland-0.1.9-linux-x64.tar.gz"
      sha256 "223575100e7a5a664803cd2e207b27d3d163b78aa9c58b3b7da3bbe377835b42"
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
