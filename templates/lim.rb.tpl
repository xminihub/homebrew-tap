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

  test do
    assert_match version.to_s, shell_output("#{bin}/{{BIN}} --version")
  end
end
