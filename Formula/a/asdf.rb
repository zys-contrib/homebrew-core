class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "fb712d19f2c0bad65b0cc5c7c1cf8a477b5fa05d6836feee63068d1c2dbdb30b"
  license "MIT"
  head "https://github.com/asdf-vm/asdf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "444c8ec5fa55d551794c4bf6d4374ddbc58298706a6843d29320dbd5c04284f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "444c8ec5fa55d551794c4bf6d4374ddbc58298706a6843d29320dbd5c04284f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "444c8ec5fa55d551794c4bf6d4374ddbc58298706a6843d29320dbd5c04284f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "139bc86a8cd6e7642dbb71c02850a88ad3b9badb3e4f0cec34f983b490c2854e"
    sha256 cellar: :any_skip_relocation, ventura:       "139bc86a8cd6e7642dbb71c02850a88ad3b9badb3e4f0cec34f983b490c2854e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b28d53ff98bebde756ea57785d41a2f26cdee9ff62bdf41485fd9c5842c0ec1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/asdf"
    generate_completions_from_executable(bin/"asdf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asdf version")
    assert_match "No plugins installed", shell_output("#{bin}/asdf plugin list 2>&1")
  end
end
