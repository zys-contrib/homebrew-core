class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://github.com/lightvector/KataGo"
  # Occasionally check upstream docs in case recommended model/network is changed.
  # Ref: https://github.com/lightvector/KataGo?tab=readme-ov-file#other-questions
  url "https://github.com/lightvector/KataGo/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "1786772c8490fb513522319554dfb41d93ecae4fb35e1b70249f3fe3c75c6cc1"
  license all_of: [
    "MIT",
    "CC0-1.0", # g170 resources
  ]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "422d44198c78c32942ed61ff8b5aebf6ee7e70ca139d4d5d2948cdfd9da98317"
    sha256 cellar: :any,                 arm64_sonoma:   "b8429e8dfd8e8ed55b43bcbe3303429a15d2198f766161223412a5aac9a26900"
    sha256 cellar: :any,                 arm64_ventura:  "756948a27239a72cd8b6fa312fd4c3cb4fa9f20940c4158011a82e681938f5cd"
    sha256 cellar: :any,                 arm64_monterey: "3c9d3dc8e2768770bd803e6ca8b557295275482df2b57f14b349980ddb7ec678"
    sha256 cellar: :any,                 sonoma:         "ba24de18bcadf148cfc200afc681ab9297e640e2395de69ac43efbe5b4cbf313"
    sha256 cellar: :any,                 ventura:        "ab482d1af11de5e268ad2465ee8feb5aa7436dbc7885cfefa677ab35c39462ef"
    sha256 cellar: :any,                 monterey:       "27da9731aecb9f6f8bf0ce99d8d0719e2f833c9ba7342f784f3b6f952e45eb9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f5a46a44d6e32e7f21986ce70aa5ed124706a892681539c9d8c699fd07fc13bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3033bade67d18470af58d50cf498ec6a40cb9f36cccf3a1295d60faa71f7df59"
  end

  depends_on "cmake" => :build
  depends_on "libzip"
  depends_on macos: :mojave

  uses_from_macos "zlib"

  on_macos do
    depends_on "ninja" => :build
  end

  on_linux do
    depends_on "eigen" => :build
  end

  # Using most recent b18c384nbt rather than strongest as it is easier to track
  resource "b18c384nbt" do
    url "https://media.katagotraining.org/uploaded/networks/models/kata1/kata1-b18c384nbt-s9996604416-d4316597426.bin.gz", using: :nounzip
    version "s9996604416-d4316597426"
    sha256 "9d7a6afed8ff5b74894727e156f04f0cd36060a24824892008fbb6e0cba51f1d"

    livecheck do
      url "https://katagotraining.org/networks/"
      regex(/href=.*?kata1[._-]b18c384nbt[._-](s\d+[._-]d\d+)\.bin\.gz/i)
    end
  end

  # Following resources are final g170 so shouldn't need to be updated
  resource "20b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.5/g170e-b20c256x2-s5303129600-d1228401921.bin.gz", using: :nounzip
    sha256 "7c8a84ed9ee737e9c7e741a08bf242d63db37b648e7f64942f3a8b1b5101e7c2"

    livecheck do
      skip "Final g170 20-block network"
    end
  end

  resource "40b-network" do
    url "https://github.com/lightvector/KataGo/releases/download/v1.4.5/g170-b40c256x2-s5095420928-d1229425124.bin.gz", using: :nounzip
    sha256 "2b3a78981d2b6b5fae1cf8972e01bf3e48d2b291bc5e52ef41c9b65c53d59a71"

    livecheck do
      skip "Final g170 40-block network"
    end
  end

  def install
    args = ["-DNO_GIT_REVISION=1"]
    args += if OS.mac?
      ["-DUSE_BACKEND=METAL", "-GNinja"]
    else
      ["-DUSE_BACKEND=EIGEN"]
    end

    system "cmake", "-S", "cpp", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/katago"

    pkgshare.install "cpp/configs"
    resources.each { |r| pkgshare.install r }
  end

  test do
    system bin/"katago", "version"
    assert_match(/All tests passed$/, shell_output("#{bin}/katago runtests").strip)
  end
end
