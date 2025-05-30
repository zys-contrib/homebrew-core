class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.34.8.tar.gz"
  sha256 "668e0ccbbf713e4875ed11366fc155af850531ae18517270c579ae9200174c1d"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf023290d39aaeca2a5a308d5ae5d5d54fc7cebf72bd07f8c9c031f1e626f76d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd6f8abf358d3ef9984dbf0f9668f591edf0c83a52f6d43a4291319bb393a64d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70fa9e5ff497fc6b62ca73ac4ee5b3cde7e0c2bf5ef0e66e14c3a38bd351378a"
    sha256 cellar: :any_skip_relocation, sonoma:        "115c1a15e529afde7dd1d1428277047d65467673d2fa3eba645635f5f7592b26"
    sha256 cellar: :any_skip_relocation, ventura:       "061821746e20be4c5035579223ae8566007b796f7e56e8b4c87fefbedcddad0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d71ae7c3a406f091c0da0e282ab4b973b209dd5401be82f3ebae126a234ef8ca"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
