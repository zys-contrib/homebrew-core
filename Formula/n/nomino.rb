class Nomino < Formula
  desc "Batch rename utility"
  homepage "https://github.com/yaa110/nomino"
  url "https://github.com/yaa110/nomino/archive/refs/tags/1.3.7.tar.gz"
  sha256 "9c19028b9e685976e9196c0c769c3690f0b56ff1f61f4f6a06ab6a32b163a6a0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yaa110/nomino.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c09203e92cd1defafe79abd33e7623d2f8e95173707386eb7b8370166e81d238"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ec3e1fb19c545a9eab609f52fadefb386011e4413819c53415be83c2508a8d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc5178756a62375ab314dec06156d82cb068ae2a504e2504ad8ef7fdbe50e374"
    sha256 cellar: :any_skip_relocation, sonoma:        "393baaefe2933f28c7d923958701a0b4019e7e14c7da3441be030562b938c94e"
    sha256 cellar: :any_skip_relocation, ventura:       "9f0c907213a4c18886b6bf297c4466253a72cc17d3f8845b3fd8597bae9517fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "234f9d8899f41e73c68cd32fb49a42ca0e329bdf055cd5cb6e037f51b043e5ce"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (1..9).each do |n|
      (testpath/"Homebrew-#{n}.txt").write n.to_s
    end

    system bin/"nomino", "-e", ".*-(\\d+).*", "{}"

    (1..9).each do |n|
      assert_equal n.to_s, (testpath/"#{n}.txt").read
      refute_predicate testpath/"Homebrew-#{n}.txt", :exist?
    end
  end
end
