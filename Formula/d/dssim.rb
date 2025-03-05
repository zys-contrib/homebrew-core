class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/refs/tags/3.4.0.tar.gz"
  sha256 "5267e79f4604558d9f24ce02aa20597396a9b052d0ad1b2f8000d4d6bd162126"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a46f2b567b23c5da9c65895547ac70f95f9d2b7c406b7612ee27aad45e76fbd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b7783cd8aa1bcb8798ef766048b9c755bbf84c08a3aca822506efa306e6f04e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f5d200bb8db0c159934005fa05f62ae6bfc442bb801ed2d554ddb8b41937c45"
    sha256 cellar: :any_skip_relocation, sonoma:        "64448958181fe26a8b5a604ec1eda5cd13b0ba2fcec727b0be07018f51abc915"
    sha256 cellar: :any_skip_relocation, ventura:       "d8d9f90e34142e97ae274f9924ba33d3861c734496136db3eb36a576c1ce8118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8546192c766b226b6ef5fd4a8ddcdaba0e07d3094d3b3146256ec37aaccf2220"
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
