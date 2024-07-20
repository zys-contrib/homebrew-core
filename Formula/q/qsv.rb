class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.129.0.tar.gz"
  sha256 "5eacdaa3bb782ae2ef77e6ea91daef42316e13663ccef7c008a0ae4d04939d89"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b4148b38f572bf50a5b4ed1e77fbd615a0b4c133b319c0b7c323d2647fc28b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30522600f940d0177e6cbcced9cdd938b0eaa6156d2475e195b2a14d996442a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcfe768b100ea295e350331fe67d60c38bdc0594695751d797d21c9c2fc06b45"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0b861160a4ed1129b27cd7bbb89b4b58a927917e3ccc026cdc564f52fd09e25"
    sha256 cellar: :any_skip_relocation, ventura:        "fe323764d6267b8305de9577dda8342dfaac50570f8c553e213093d8d3edb86f"
    sha256 cellar: :any_skip_relocation, monterey:       "e8ddb6e3819fe68bad87830c2bb9aa1f3b5d46cd1e1f0ec28a1cd015f879509f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e63400d3d7f959b3c7c1b3479093f0845a9130fd0be8bb1dcded4ca1616a442"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,feature_capable"
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
