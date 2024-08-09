class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.131.1.tar.gz"
  sha256 "9038f09a0e1523bcf3a993bd95a36f8dd1c640e7ffbbe9404e018d41a7d82b66"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2a170326b8adf7f2bf547c3bc28fe91e3332134a43e89f98c88c9cf6b0ce75f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e85dd23e3d147b1a6f87976bdec99efb81a52e4f23e15ee4c62bb0803f6448f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50dcf1afba1c1f9005b3a9e550b7c120ac7a2c94630f902bdc827514ae2d4b15"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd7437f791be58e12d3ea678ec7bea21655c739022ffb499376206dd5cf294c1"
    sha256 cellar: :any_skip_relocation, ventura:        "984eac6a5fc1ba24cc01b7b36352bcaa24a433767801404f84061ed6d918bece"
    sha256 cellar: :any_skip_relocation, monterey:       "252098316775634f17f52b1a32857117687b9b0f56440615a258b4f9643ea064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3556a30bdae7d729445c0307547e2828bd7a7befe1ad268af58330eb229f7e15"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,feature_capable"
    bash_completion.install "contrib/completions/examples/qsv.bash" => "qsv"
    fish_completion.install "contrib/completions/examples/qsv.fish"
    zsh_completion.install "contrib/completions/examples/qsv.zsh" => "_qsv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,is_ascii,sum,min,max,range,min_length,max_length,mean,sem,stddev,variance,cv,nullcount,max_precision,sparsity
      first header,NULL,,,,,,,,,,,,,0,,
      second header,NULL,,,,,,,,,,,,,0,,
    EOS
  end
end
