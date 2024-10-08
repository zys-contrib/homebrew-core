class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.10.7.tar.gz"
  sha256 "6d9b410e3a9d7856d2ee2b8d3abf155b913016843a1d70dd870784dd0f23cee0"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "882576237fb21617d811c602ff5b120a4979c735e288e907715537b6f7917b2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "882576237fb21617d811c602ff5b120a4979c735e288e907715537b6f7917b2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "882576237fb21617d811c602ff5b120a4979c735e288e907715537b6f7917b2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e40563e9227f94c067291e00f736c10dd9b3e8304f1cbadd711d731aef41cc5"
    sha256 cellar: :any_skip_relocation, ventura:       "0e40563e9227f94c067291e00f736c10dd9b3e8304f1cbadd711d731aef41cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbec6a5de2cfefbe3575e19390134a035961eadba396f2b072cd716425a2693b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
