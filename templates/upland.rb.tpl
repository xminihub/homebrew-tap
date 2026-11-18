class {{CLASS}} < Formula
  desc "{{DESC}}"
  homepage "{{HOMEPAGE}}"
  license "{{LICENSE}}"

  livecheck do
    url :stable
    strategy :github_latest
  end

{{BLOCKS}}

  def install
    bin.install "{{BIN}}"
  end

  service do
    run [opt_bin/"{{BIN}}", "--host", "127.0.0.1", "--port", "8310"]
    keep_alive true
    working_dir var
    log_path var/"log/upland.log"
    error_log_path var/"log/upland.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/{{BIN}} --version")
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
end
