class Sidekick < Formula
  desc "Deploy applications to your VPS"
  homepage "https://github.com/MightyMoud/sidekick"
  url "https://github.com/MightyMoud/sidekick/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "174224422622158ee78d423ac3c25bb9265914983a1f9b5b2e14543dcb0fe939"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac05b03397f05af43c8d548f65d2f962d1e800b58474e047ce125439b2f9a97b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac05b03397f05af43c8d548f65d2f962d1e800b58474e047ce125439b2f9a97b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac05b03397f05af43c8d548f65d2f962d1e800b58474e047ce125439b2f9a97b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1d3c17dee520482d7be81aa43e17cc8646b268cd8223eb36768d5feebc09ebe"
    sha256 cellar: :any_skip_relocation, ventura:       "d1d3c17dee520482d7be81aa43e17cc8646b268cd8223eb36768d5feebc09ebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43211272d0b6653cc5bef090b57701ca446338abd55e421f71c461f17a96848d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'github.com/mightymoud/sidekick/cmd.version=v#{version}'"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"sidekick", "completion")
  end

  test do
    assert_match "With sidekick you can deploy any number of applications to a single VPS",
                  shell_output(bin/"sidekick")
    assert_match("Sidekick config not found - Run sidekick init", shell_output("#{bin}/sidekick deploy", 1))
  end
end
