class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https://gomi.dev"
  url "https://github.com/babarot/gomi/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "3943e508633a388f263bdf96203a48fe5d30c88b2378853456a0e3eae9d10dfe"
  license "MIT"
  head "https://github.com/babarot/gomi.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.revision=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gomi --version")

    (testpath/"trash").write <<~TEXT
      Homebrew
    TEXT

    # Restoring is done in an interactive prompt, so we only test deletion.
    assert_path_exists testpath/"trash"
    system bin/"gomi", "trash"
    refute_path_exists testpath/"trash"
  end
end
