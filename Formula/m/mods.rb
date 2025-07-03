class Mods < Formula
  desc "AI on the command-line"
  homepage "https://github.com/charmbracelet/mods"
  url "https://github.com/charmbracelet/mods/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "d8877258877408e90889385f1d3106278e71d56223e08e35dc60b120c95c903d"
  license "MIT"
  head "https://github.com/charmbracelet/mods.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef4507075257b543ce0352b27723e0b70310221b5af17ee5ad2e45e660d39fb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef4507075257b543ce0352b27723e0b70310221b5af17ee5ad2e45e660d39fb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef4507075257b543ce0352b27723e0b70310221b5af17ee5ad2e45e660d39fb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f172da97622950b4d688514b07d9bd7711b4e935bb77602bf642f96525ca8db"
    sha256 cellar: :any_skip_relocation, ventura:       "6f172da97622950b4d688514b07d9bd7711b4e935bb77602bf642f96525ca8db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f7ce569623766cf59c6ab7df40eb76dd857055683aa1ad75dafc7b3482f0a92"
  end

  depends_on "go" => :build

  # skip db init for `--version` and `--help` commands
  # upstream pr ref, https://github.com/charmbracelet/mods/pull/543
  patch do
    url "https://github.com/charmbracelet/mods/commit/d18b03d0306116108d5bc50f58a4e81b6480cb74.patch?full_index=1"
    sha256 "b1ae4388376787219ebdc5b1be97b2222beb83043f467588ec48ead2154be342"
  end

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.CommitSHA=#{tap.user} -X main.CommitDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mods", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    ENV["OPENAI_API_KEY"] = "faketest"

    output = pipe_output(bin/"mods 2>&1", "Hello, Homebrew!", 1)
    assert_match "ERROR  Could not open database", output

    assert_match version.to_s, shell_output("#{bin}/mods --version")
    assert_match "GPT on the command line", shell_output("#{bin}/mods --help")
  end
end
