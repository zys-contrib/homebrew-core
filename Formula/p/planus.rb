class Planus < Formula
  desc "Alternative compiler for flatbuffers,"
  homepage "https://github.com/planus-org/planus"
  url "https://github.com/planus-org/planus/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "d79f5d9a1acfcadc86376537c297853dcd6f326016f8049c28df57bb4f39c957"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/planus-org/planus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ab3ff8c8cdf462069e279ae00fffd7ca1a453457db6c9598b3a3092a026837c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "493795e9f371316c332888509c1165cc96e3862029938cec770f3c66f2d78e4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd78db28a274542d1ef00dcd9828746c492a0c13755ba062bc280bec42cfa2eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e1a4aaff76893fdd726bc1301d37248c1b34d7e917c4b8a3756ff2f5bdd1d4b"
    sha256 cellar: :any_skip_relocation, ventura:       "771284605efc4b0bd94918cf2f48d7b4ce644752271cbb62d056b5a64b1f1e52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4294dbd6efc94cebb3798226c79dbaf2ed40b6b3ffd835d4690b71c5ae3cbc37"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/planus-cli")

    generate_completions_from_executable(bin/"planus", "generate-completions")
  end

  test do
    test_fbs = testpath/"test.fbs"
    test_fbs.write <<~EOS
      // example IDL file

      namespace MyGame.Sample;

      enum Color:byte { Red = 0, Green, Blue = 2 }

      union Any { Monster }  // add more elements..

        struct Vec3 {
          x:float;
          y:float;
          z:float;
        }

        table Monster {
          pos:Vec3;
          mana:short = 150;
          hp:short = 100;
          name:string;
          friendly:bool = false (deprecated);
          inventory:[ubyte];
          color:Color = Blue;
        }

      root_type Monster;

    EOS

    system bin/"planus", "format", test_fbs
    system bin/"planus", "check", test_fbs
  end
end
