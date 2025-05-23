class Infat < Formula
  desc "Tool to set default openers for file formats and url schemes on MacOS"
  homepage "https://github.com/philocalyst/infat"
  url "https://github.com/philocalyst/infat/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "b0c0cad9dd995aff389fce829d62a61629fe8e07e7dd4a412ae010124c4cdb0d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e263c627344fa10c4373c6f7f76b96bbf090703a2e1761ed247f04f385deaf56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db3419a6e095edcea41b5a029dcbc2aa1a94b70c684e42c67e38019de59dbf69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c57aaf12f258985b59315f828aaee79cb6fda188dca639a29407205cef827ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "76e0af0201e4226d74e7b95c0217b0b3a1bdd21f98de04cf2c7f07a7d4bb6d3a"
    sha256 cellar: :any_skip_relocation, ventura:       "be3d4afc2a8963e9e6bdafdf6b6dd7522b5bb0594fabd7bec6a669eeeaac78e9"
  end

  depends_on :macos
  uses_from_macos "swift" => :build

  # fix swift syntax error, upstream pr ref, https://github.com/philocalyst/infat/pull/25
  patch do
    url "https://github.com/philocalyst/infat/commit/dd050ef6f3891fe683a4f2f430c415cf0460fa2c.patch?full_index=1"
    sha256 "4efa99053e2455a39e9aa89221172a5c687f34511a4ebadeab2e136d974d3afa"
  end

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--static-swift-stdlib"
    bin.install ".build/release/infat"

    generate_completions_from_executable(bin/"infat", "--generate-completion-script")
  end

  test do
    output = shell_output("#{bin}/infat set TextEdit --ext txt")
    assert_match "Successfully bound TextEdit to txt", output
  end
end
