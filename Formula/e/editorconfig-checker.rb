class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "971cac44f20323c2b49d39d14cf210637dfcde94d486a314374c78bd77f1d3ce"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36c8d35c9cbd3ab2dbda82814c5d6b95cdbb6d484cbeaed62ad9e728cd7f19bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36c8d35c9cbd3ab2dbda82814c5d6b95cdbb6d484cbeaed62ad9e728cd7f19bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36c8d35c9cbd3ab2dbda82814c5d6b95cdbb6d484cbeaed62ad9e728cd7f19bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "783883ceed3eab04098d45242a2f334a666aa412b2e3525cf62656ac49432056"
    sha256 cellar: :any_skip_relocation, ventura:       "783883ceed3eab04098d45242a2f334a666aa412b2e3525cf62656ac49432056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fc9b26f153c7844af2479d87619c89f0451d160431b4f0785becf42ed0d96ce"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/editorconfig-checker/main.go"
  end

  test do
    (testpath/"version.txt").write <<~EOS
      version=#{version}
    EOS

    system bin/"editorconfig-checker", testpath/"version.txt"

    assert_match version.to_s, shell_output("#{bin}/editorconfig-checker --version")
  end
end
