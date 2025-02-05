class Dud < Formula
  desc "CLI tool for versioning data"
  homepage "https://kevin-hanselman.github.io/dud/"
  url "https://github.com/kevin-hanselman/dud/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "57f63d260c8a0a0f925bb67e3634f1211c69b07a7405215b53c38d8563119425"
  license "BSD-3-Clause"
  head "https://github.com/kevin-hanselman/dud.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
    generate_completions_from_executable(bin/"dud", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dud version")
    system bin/"dud", "init"
    assert_predicate testpath/".dud/config.yaml", :exist?
  end
end
