class Comtrya < Formula
  desc "Configuration and dotfile management tool"
  homepage "https://comtrya.dev"
  url "https://github.com/comtrya/comtrya/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "a5401004a92621057dab164db06ddf3ddb6a65f6cb2c7c4208a689decc404ad4"
  license "MIT"
  head "https://github.com/comtrya/comtrya.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "./app")
  end

  test do
    assert_match "comtrya #{version}", shell_output("#{bin}/comtrya --version")

    resource "testmanifest" do
      url "https://raw.githubusercontent.com/comtrya/comtrya/refs/heads/main/examples/onlyvariants/main.yaml"
      sha256 "0715e12cbbb95c8d6c36bb02ae4b49f9fa479e2f28356b8c1f3b5adfb000b93f"
    end

    resource("testmanifest").stage do
      system bin/"comtrya", "-d", "main.yaml", "apply"
    end
  end
end
