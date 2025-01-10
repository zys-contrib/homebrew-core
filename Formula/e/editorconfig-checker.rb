class EditorconfigChecker < Formula
  desc "Tool to verify that your files are in harmony with your .editorconfig"
  homepage "https://github.com/editorconfig-checker/editorconfig-checker"
  url "https://github.com/editorconfig-checker/editorconfig-checker/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "b01e8d2a07c889e20d3aa9ac2d783484b7a1366bee8f3332cd222c23f6610d4d"
  license "MIT"
  head "https://github.com/editorconfig-checker/editorconfig-checker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d66db41743d07ee4b1b98cb900556c9ec9042513a698459b790a7456dac29ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d66db41743d07ee4b1b98cb900556c9ec9042513a698459b790a7456dac29ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d66db41743d07ee4b1b98cb900556c9ec9042513a698459b790a7456dac29ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "38e5668e045aaa59e92861edefc54ffd69743d412101ffd278a1b3ff96dc0ed8"
    sha256 cellar: :any_skip_relocation, ventura:       "38e5668e045aaa59e92861edefc54ffd69743d412101ffd278a1b3ff96dc0ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2051f75f96c38dabc75a4c528a70b762103332c7a01c2448aaf79894756a5a5"
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
