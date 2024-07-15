class Pug < Formula
  desc "Drive terraform at terminal velocity"
  homepage "https://github.com/leg100/pug"
  url "https://github.com/leg100/pug/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "6cb29112b8198798fdf6decad3edf5f85e8674fe1269ba93068467ae8a37d281"
  license "MPL-2.0"
  head "https://github.com/leg100/pug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e8fe5e6ad5754fde25d7880ccd353e263fbb725a5f1b3d537d111587893d08c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fe20c4fcb9ad09d6cab52ae80f1bd732b8581c18a0d9c4548271263c8ee0815"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bcd8ae6d76a1be30e3b0d503c9bbe79b232dba8ab73ed11b3a3c1d251d23b83"
    sha256 cellar: :any_skip_relocation, sonoma:         "7dd72e2adf512a8f1bb9d4fea404b08f25fc08bb8bc78ad2863ff2e5957631e8"
    sha256 cellar: :any_skip_relocation, ventura:        "16ed7dd76460a5a80a7255858f1c6c714c06166d1be4cf8c0a95ea136fe21500"
    sha256 cellar: :any_skip_relocation, monterey:       "4626e0e4dd126da88a01567c196527c2f2ab73a5ddf34068e642e773135ad712"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d7b7ccd583fae648c38f60eab710098336084fa0d6fadb378b8e38ae0c76fe0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/leg100/pug/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    r, _w, pid = PTY.spawn("#{bin}/pug --debug")
    # check on TUI elements
    assert_match "Modules", r.readline
    # check on debug logs
    assert_match "loaded 0 modules", (testpath/"messages.log").read

    assert_match version.to_s, shell_output("#{bin}/pug --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
