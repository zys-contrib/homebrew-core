class Kickstart < Formula
  desc "Scaffolding tool to get new projects up and running quickly"
  homepage "https://github.com/Keats/kickstart"
  url "https://github.com/Keats/kickstart/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "2a1a335c70b81757abf4240a52ebce231501f731f3d73decbed4133d18ad1386"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "61c9d45dcdf2c747a6ac14e2af898be86e79db91335fd7207b321faa8abb0e65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35b8c0719e5f82dc9d3baa000f32fca793f6ba914ff8e0c9e94686da9be0aa6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "640c86a9964ef35f4462fee0a1a97f6be545528885b722045cfb8c35a5fd9cef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f70613fe6a2dc6100db688df22ab854d808180832a573bcdf232e9d0585defb3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad4c7fa8afdb4e95808d2aea6ec5d20e65515873dd7e03623a9b9df24834b874"
    sha256 cellar: :any_skip_relocation, sonoma:         "022446a079f1f4a0491fd8bb8566596ff2b71b9546919ec444b058023d1e1e7e"
    sha256 cellar: :any_skip_relocation, ventura:        "4dfc07fc0fab079bf8adca81c5c1effd578b383a8037830b6be304f0d92064c9"
    sha256 cellar: :any_skip_relocation, monterey:       "ebf772cfc77e3df1386cc001df2db0f5c33f6561fc49cfadd9439d85748aaef7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1790f244bedb54c169a788648144ec0568a748f4e7f74baa066888280c46e26d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc36827caf4d0dac0558d7a5b609f43fd6ad064a399f3c79578eeb208f67b4bb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "cli", *std_cargo_args
  end

  test do
    # Create a basic template file and project, and check that kickstart
    # actually interpolates both the filename and its content.
    template_dir = testpath/"template"
    output_dir = testpath/"output"

    (template_dir/"{{file_name}}.txt").write("{{software_project}} is awesome!")

    (template_dir/"template.toml").write <<~TOML
      name = "Super basic"
      description = "A very simple template"
      kickstart_version = 1

      [[variables]]
      name = "file_name"
      default = "myfilename"
      prompt = "File name?"

      [[variables]]
      name = "software_project"
      default = "kickstart"
      prompt = "Which software project is awesome?"
    TOML

    # Run template interpolation
    system bin/"kickstart", "--no-input", "--output-dir", output_dir, template_dir

    assert_predicate output_dir/"myfilename.txt", :exist?
    assert_equal "kickstart is awesome!", (output_dir/"myfilename.txt").read
  end
end
