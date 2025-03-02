class Punktf < Formula
  desc "Cross-platform multi-target dotfiles manager"
  homepage "https://shemnei.github.io/punktf/"
  url "https://github.com/Shemnei/punktf/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "99d5c42a621a609c59cfa5088391e4e0384739850df0eab3917b4a7d10fbebcc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/Shemnei/punktf.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/punktf-cli")

    generate_completions_from_executable(bin/"punktf", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/punktf --version")

    mkdir_p testpath/"profiles"
    touch testpath/"profiles/test.yaml"

    output = shell_output("#{bin}/punktf deploy --profile test --source #{testpath} --target #{testpath}")
    assert_match "SUCCESS", output
  end
end
