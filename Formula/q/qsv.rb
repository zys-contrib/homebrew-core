class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/1.0.0.tar.gz"
  sha256 "92ca4fef2c0f58aa5d322a01a70a7e9dd689f8055cdf64aaf1422cb28fe5357b"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d56c8970528f50a4398845eb53cab377f6fd0439d98b14df83fdf288fa94a13c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd153b282502bbd20966b7847e5bba50db797e98c156e9e6a65fc01313fb5e7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e81c99fcb0b10ac5080db96e0b10095931ecb363c52d92d6fd756879d2b27225"
    sha256 cellar: :any_skip_relocation, sonoma:        "331e8f2eee4d80be9bea99ce0ab8ae63324d0d329d995b86355147600b5162c0"
    sha256 cellar: :any_skip_relocation, ventura:       "0d14e68b4d1c8c176ea9c8bc9e2c23a58c0861e37a251d3c76797b7fd073eec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f124c350f63133eb4b7f75adb577beafe131662eb162d99d75ba2dd17a79ef0"
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
      field,type,is_ascii,sum,min,max,range,sort_order,min_length,max_length,sum_length,avg_length,mean,sem,stddev,variance,cv,nullcount,max_precision,sparsity,qsv__value
      first header,NULL,,,,,,,,,,,,,,,,0,,,
      second header,NULL,,,,,,,,,,,,,,,,0,,,
      qsv__rowcount,,,,,,,,,,,,,,,,,,,,0
      qsv__columncount,,,,,,,,,,,,,,,,,,,,2
      qsv__filesize_bytes,,,,,,,,,,,,,,,,,,,,26
      qsv__fingerprint_hash,,,,,,,,,,,,,,,,,,,,1d0c55659105190da4e4e4d2ff69ae40956634c83dee786393680d9d02006bff
    EOS
  end
end
