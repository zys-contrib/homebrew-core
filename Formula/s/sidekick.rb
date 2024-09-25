class Sidekick < Formula
  desc "Deploy applications to your VPS"
  homepage "https://github.com/MightyMoud/sidekick"
  url "https://github.com/MightyMoud/sidekick/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "daaa4bd9492c0fff8803ec48b5664b436a1eacd3b925528636668bdeb0a5e42d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0966d3dcaf938faa0dc73f2e9d67f9d85a746f81e916c3546865201782284193"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0966d3dcaf938faa0dc73f2e9d67f9d85a746f81e916c3546865201782284193"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0966d3dcaf938faa0dc73f2e9d67f9d85a746f81e916c3546865201782284193"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4a0d4d6b5d011b8683ca90a030a3bf96ee83eb5e6fd4418bfe650b9a9edc7c5"
    sha256 cellar: :any_skip_relocation, ventura:       "b4a0d4d6b5d011b8683ca90a030a3bf96ee83eb5e6fd4418bfe650b9a9edc7c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "917920794d53e70a725d20a0bd6ceb772a3e8d8b59da27e354c806b5394dde23"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"sidekick", "completion")
  end

  test do
    assert_match "With sidekick you can deploy any number of applications to a single VPS",
                  shell_output(bin/"sidekick")
    assert_match("Sidekick config not found - Run sidekick init", shell_output("#{bin}/sidekick deploy", 1))
  end
end
