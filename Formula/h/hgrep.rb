class Hgrep < Formula
  desc "Grep with human-friendly search results"
  homepage "https://github.com/rhysd/hgrep"
  url "https://github.com/rhysd/hgrep/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "66e30cad042791afea218f7a31f82ffcb7b92b57ba44c7adee1f792029d9cd86"
  license "MIT"
  head "https://github.com/rhysd/hgrep.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hgrep", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hgrep --version")
    (testpath/"test").write("Hello, world!")
    system bin/"hgrep", "Hello"
  end
end
