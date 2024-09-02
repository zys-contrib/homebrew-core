class Dra < Formula
  desc "Tool to download release assets from GitHub"
  homepage "https://github.com/devmatteini/dra"
  url "https://github.com/devmatteini/dra/archive/refs/tags/0.6.1.tar.gz"
  sha256 "cf6d96c8c76472a51c5bf651732715682ba8f11ce9d61dca67c1baa6bb421bc0"
  license "MIT"
  head "https://github.com/devmatteini/dra.git", branch: "main"

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dra", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"dra --version")

    system bin/"dra", "download", "--select",
           "helloworld.tar.gz", "devmatteini/dra-tests"

    assert_predicate testpath/"helloworld.tar.gz", :exist?
  end
end
