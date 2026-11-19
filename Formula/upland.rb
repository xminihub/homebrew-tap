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
      url "https://github.com/xminihub/upland/releases/download/v0.1.7/upland-0.1.7-darwin-arm64.tar.gz"
      sha256 "8c9685d8c96c1b438a3b8a2476449bd878fbdcd9b14d5ebb3cc24ecac2666cf2"
    else
      url "https://github.com/xminihub/upland/releases/download/v0.1.7/upland-0.1.7-darwin-x64.tar.gz"
      sha256 "34ff43904489bb14b471c4054e7268c34a836b96b6566604491a9840d1fbcef4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/xminihub/upland/releases/download/v0.1.7/upland-0.1.7-linux-arm64.tar.gz"
      sha256 "aefe07969e1b282069512879044c71aba8918868fd0d329d60b9d6ff796bffdc"
    else
      url "https://github.com/xminihub/upland/releases/download/v0.1.7/upland-0.1.7-linux-x64.tar.gz"
      sha256 "53f76c9bd7db503ff57b2364d15a36e52fe732913fdf03ba752f4237a83390dc"
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
