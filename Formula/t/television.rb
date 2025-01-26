class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.10.2.tar.gz"
  sha256 "fb85884a7684323872e895271969695dc4ddc3ef7550aad3cc76504fd9df21cd"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7420470c66908606dd6dfd4590f5df4ddec8d4e0781397f33ea5c694cb2aded9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a9725363a9fdb73e716090f334010f6a97bbf0d0445905f2f0b73f1de0be40a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "842f665f13b4b97128b99b178b251a0c34294f55dac8b60f0d18a8201a8d3796"
    sha256 cellar: :any_skip_relocation, sonoma:        "52b827050c9f8db2feda2f2a3cd82516d379c16da339463ec2e66150be4ba808"
    sha256 cellar: :any_skip_relocation, ventura:       "92b0d8ede6e7e6cbaa4dce3e66d9016f9cafef752bb5e4488d7b8b3835c59979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51ad644bd7cbdd5990445f4855822d61d5a93a6e2d5ecd5aa5c8903d5bb3af56"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv list-channels")
    assert_match "Builtin channels", output
  end
end
