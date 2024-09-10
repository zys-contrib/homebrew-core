class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.46.1/cli-v1.46.1.tar.gz"
  sha256 "935f732ddacc6e54fc83d06351fc25454ac8a58c465c3efa43e066ea226257c2"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b6f0aa4616386efb58b15b04c0f8ca68bf58742d06aa744efece2890926a376f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3167d7a150d158d676faaa96c4430b4edf4383aec1ff5b3b9feb5718675246f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3167d7a150d158d676faaa96c4430b4edf4383aec1ff5b3b9feb5718675246f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3167d7a150d158d676faaa96c4430b4edf4383aec1ff5b3b9feb5718675246f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2dd26dca401a271ebdac43ddac5f93a90a72095e95bbb81d2bd189e882c2d08"
    sha256 cellar: :any_skip_relocation, ventura:        "e2dd26dca401a271ebdac43ddac5f93a90a72095e95bbb81d2bd189e882c2d08"
    sha256 cellar: :any_skip_relocation, monterey:       "e2dd26dca401a271ebdac43ddac5f93a90a72095e95bbb81d2bd189e882c2d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3810f262076c920c9671e9d706a987882a1375103fe8c893c7d628e45a8b549"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=v#{version}"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
