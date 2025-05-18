class Clive < Formula
  desc "Automates terminal operations"
  homepage "https://github.com/koki-develop/clive"
  url "https://github.com/koki-develop/clive/archive/refs/tags/v0.12.11.tar.gz"
  sha256 "c406ff8c8a959f5de0730ecfd393c432587f824b86cc91979ee54e4e96b44ac0"
  license "MIT"
  head "https://github.com/koki-develop/clive.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c60af2d39a20569870d29574d64cb0288fc8969230413bcd96deaec731000f5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c60af2d39a20569870d29574d64cb0288fc8969230413bcd96deaec731000f5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c60af2d39a20569870d29574d64cb0288fc8969230413bcd96deaec731000f5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ea5a88d1046099603f7f06babc3664f2a5c9f203064285c5c080740b2d109b8"
    sha256 cellar: :any_skip_relocation, ventura:       "3ea5a88d1046099603f7f06babc3664f2a5c9f203064285c5c080740b2d109b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "370d2026bc46831ac440ce42ea6f080601e2dc2fba8619fc8ec71ccb44d00061"
  end

  depends_on "go" => :build
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/clive/cmd.version=v#{version}")
  end

  test do
    system bin/"clive", "init"
    assert_path_exists testpath/"clive.yml"

    system bin/"clive", "validate"
    assert_match version.to_s, shell_output("#{bin}/clive --version")
  end
end
