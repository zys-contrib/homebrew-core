class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://enter-tainer.github.io/typstyle/"
  url "https://github.com/Enter-tainer/typstyle/archive/refs/tags/v0.11.33.tar.gz"
  sha256 "6c58ebdf627e4b1a374347ad517043aef278b5a4f648d440885e7ad0a3862870"
  license "Apache-2.0"
  head "https://github.com/Enter-tainer/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5414c5f9a054041836533b3b7e5f4f497c74b0cc3e2d661bbc8c59607e2b97dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a96656310a4f87d962e893b9ab52236336eb14e5a564bb010924d9a5eb5c532"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db016fe6445701619f5b118916182c7d88e1bbcfd31d2cd144f6ec938568fdc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "87c6c48fc73115ab69890d096c363732d98001f956bd49c93d4e591bdd5f093e"
    sha256 cellar: :any_skip_relocation, ventura:       "f01a595847d9896b9f9f84da8d25871498539235a70c7971f713b3743fc85fc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5635aca0bf371208558647a372119ce24f5e10af4b93db3aa634a96c3f6160db"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}/typstyle --version")
  end
end
