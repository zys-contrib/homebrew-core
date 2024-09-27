class Fblog < Formula
  desc "Small command-line JSON log viewer"
  homepage "https://github.com/brocode/fblog"
  url "https://github.com/brocode/fblog/archive/refs/tags/v4.11.0.tar.gz"
  sha256 "1eac5921d0e428fb350956dccb90861e20071f1851e093dd972f4d54da34771f"
  license "WTFPL"
  head "https://github.com/brocode/fblog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05b5c69fb8060f6725d33704d6ecfed58962c3b8365ba5329db71224268cd6ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb4133b4756733e9631474c90e13c41636fe6154a2be354c6edeef88491d0e7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8211c26090d28fe20a4bb6a4ee0ed7fadc25819e17e7196e2be4496b71b27b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6587237972a12df1b4ef0b3180a718709b9b604f37ed36f8c3d84bff2c02ea16"
    sha256 cellar: :any_skip_relocation, ventura:       "0acd4344da754b9423a7f8ada4f8e15093500cb4ca3e8270633001e13898774a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6ceeb98d295a3842bfe6727c724b0e51ab1f0c5530f923c7ac1b0e2e117a1c8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install a sample log for testing purposes
    pkgshare.install "sample.json.log"
  end

  test do
    output = shell_output("#{bin}/fblog #{pkgshare/"sample.json.log"}")

    assert_match "Trust key rsa-43fe6c3d-6242-11e7-8b0c-02420a000007 found in cache", output
    assert_match "Content-Type set both in header", output
    assert_match "Request: Success", output
  end
end
