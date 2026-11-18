# The generator substitutes CLASS, DESC, HOMEPAGE, LICENSE, BIN and BLOCKS
# only, so a tool's own name in prose is literal here: this template belongs
# to one tool, and scripts/render.mjs has no {{NAME}} to fill.
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

  # upland is a server, so this formula also ships the job that runs it. The
  # address and port are passed explicitly rather than left to the binary's
  # defaults: loopback so that starting it never opens a port on the network,
  # and a port of ours so that it cannot collide with the 8080 a contributor's
  # development server is already holding. `brew services` has no way to pass
  # arguments, so this is the one place to change them.
  service do
    run [opt_bin/"{{BIN}}", "--host", "127.0.0.1", "--port", "8310"]
    working_dir var
    log_path var/"log/upland.log"
    error_log_path var/"log/upland.log"
    keep_alive true
  end

  def caveats
    <<~EOS
      Run it as a service:
        brew services start upland
      then open http://127.0.0.1:8310, or run `{{BIN}}` in the foreground.
      Its log is at #{var}/log/upland.log.

      The address and port live in the generated job, not in a config file:
      `brew services stop upland`, edit
      ~/Library/LaunchAgents/homebrew.mxcl.upland.plist (or the
      systemd unit under Linux) and `brew services start upland` again. A
      reinstall or `brew services restart` writes 8310 back.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/{{BIN}} --version")
  end
end
