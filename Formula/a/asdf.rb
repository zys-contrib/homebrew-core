class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://asdf-vm.com/"
  url "https://github.com/asdf-vm/asdf/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "f63af481af158dfc7eadf1f08239b3e2edde879962b35ebfe63a54d5023fd81b"
  license "MIT"
  head "https://github.com/asdf-vm/asdf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edaf5ff7736013e12cc35e9f3b626bb78591a6599a6a676ef223600350164d38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edaf5ff7736013e12cc35e9f3b626bb78591a6599a6a676ef223600350164d38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edaf5ff7736013e12cc35e9f3b626bb78591a6599a6a676ef223600350164d38"
    sha256 cellar: :any_skip_relocation, sonoma:        "833ab73b422617a41af24a02485b66de413cc0ac9f7ff2adeaf212e446e3d554"
    sha256 cellar: :any_skip_relocation, ventura:       "833ab73b422617a41af24a02485b66de413cc0ac9f7ff2adeaf212e446e3d554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1876886fa60409502dd975eb60ee5defa541e15ef4dfb8636f0053c152f50756"
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
