class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://zk-org.github.io/zk/"
  url "https://github.com/zk-org/zk/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "a99c3a3ef376b9afb3d35cc955b588ce35b35e2ebe3492e65b21d9fe4e9ba4e9"
  license "GPL-3.0-only"
  head "https://github.com/zk-org/zk.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "79a8bf894b660fc6434833710a2545e1a01477bd52365c7f56696bc2d66d7ea2"
    sha256 cellar: :any,                 arm64_sonoma:  "12ba68014a20014e794c864399165ef2b1cecf2c5a12ca131b32671b09b4632f"
    sha256 cellar: :any,                 arm64_ventura: "7218edc02ca8d75ff11da7899546b8514dfe686b969f53e8ea5e46bd85f28f50"
    sha256 cellar: :any,                 sonoma:        "a4d1dc245f7a61d8ab8add359eed41230868ab9e8e8296eb22d7de4a3670e1e9"
    sha256 cellar: :any,                 ventura:       "e7dff217adae10898bc1345bbf4ecae9c5f517a97ae2c250e2b97099f4cd7438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b71f2405deeda4fd3894cdd7dd101e0995fcf77eb3e2139ae075d8b0b9fb0c3a"
  end

  depends_on "go" => :build

  depends_on "icu4c@77"
  uses_from_macos "sqlite"

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Build=#{tap.user}"
    tags = %w[fts5 icu]
    system "go", "build", *std_go_args(ldflags:, tags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zk --version")

    system bin/"zk", "init", "--no-input"
    system bin/"zk", "index", "--no-input"
    (testpath/"testnote.md").write "note content"
    (testpath/"anothernote.md").write "todolist"

    output = pipe_output("#{bin}/zk list --quiet").chomp
    assert_match "note content", output
    assert_match "todolist", output
  end
end
