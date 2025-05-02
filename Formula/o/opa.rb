class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "ef85e8a0f9f4804dc4578fa26fc0cedcac6a1efedb2b8f0291f6fefe5139861b"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1780093c752ed270c282e895844edb01aefd7bec82fb7dd59af785ac6351e4bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66335c7af485bf8364b26be277f924318ccf372ee0ca06b5ac33576f50b6e620"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f67b41a68718f91d44d50590f4eb93553006e69c962c07f0f1fbadf6c18910e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b4428e4dc46a7467e2685b9e884c942e3387b16bcb2a0e2cc3772412202d419"
    sha256 cellar: :any_skip_relocation, ventura:       "c5da8bc813dcc2a24315cc4772f79ef16cbca31ce9c43591fa437c898405b4cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cb8e4e63a8966f535ea81a71808a846e8d6536430f7e3f04eba3940f2df8179"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
