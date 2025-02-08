class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://registry.npmjs.org/@tailwindcss/cli/-/cli-4.0.5.tgz"
  sha256 "c5ec18d9d66df037e343360f0b16c262ef902fff8e7ded6aa8635e9aa8417a17"
  license "MIT"
  head "https://github.com/tailwindlabs/tailwindcss.git", branch: "next"

  # There can be a notable gap between when a version is added to npm and the
  # GitHub release is created, so we check the "latest" release on GitHub
  # instead of the default `Npm` check for the `stable` URL.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    rebuild 3
    sha256                               arm64_sequoia: "4b07d832b9b409eb89bb494ca4771cb4978e20696949fc4271af8ee875c21775"
    sha256                               arm64_sonoma:  "3d595a4fb22c6e44e8a1c896cd4cbdbe3736e5b02b66f908d019a6158f5d704c"
    sha256                               arm64_ventura: "da9e957d0684c94d819d77af1ed63e3456b20a2bec056f23c6c7d429d6c40de0"
    sha256                               sonoma:        "5860731c783817ab1b3d2ce81d303c06ab64f9e9fc363af26fda0dcaccb3d815"
    sha256                               ventura:       "7062ef8ff60c8ab06d3606773e75da094e4e5532e4734b3199d67745df0b19bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46a47aa02521d222502b2681c04a85a123291555a3fa859787a7c55cb8b6d55c"
  end

  depends_on "node"

  # Imitate standalone CLI and include first-party plugins
  # https://github.com/tailwindlabs/tailwindcss/blob/main/packages/%40tailwindcss-standalone/package.json#L28-L31
  resource "@tailwindcss/aspect-ratio" do
    url "https://registry.npmjs.org/@tailwindcss/aspect-ratio/-/aspect-ratio-0.4.2.tgz"
    sha256 "858df3d82234e12e59e6f8bd5d272d1e6c65aefcb4263dac84d0331f5ef00455"
  end

  resource "@tailwindcss/forms" do
    url "https://registry.npmjs.org/@tailwindcss/forms/-/forms-0.5.10.tgz"
    sha256 "f5003f088c8bfeef2d2576932b0521e29f84b7ca68e59afd709fef75bd4fe9bb"
  end

  resource "@tailwindcss/typography" do
    url "https://registry.npmjs.org/@tailwindcss/typography/-/typography-0.5.16.tgz"
    sha256 "41bb083cd966434072dd8a151c8989e1cfa574eb5ba580b719da013d32b6828e"
  end

  def install
    resources.each do |r|
      system "npm", "install", *std_npm_args(prefix: false), r.cached_download
    end
    system "npm", "install", *std_npm_args
    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", NODE_PATH: libexec/"lib/node_modules/@tailwindcss/cli/node_modules"
  end

  test do
    # https://github.com/tailwindlabs/tailwindcss/blob/main/integrations/cli/standalone.test.ts
    (testpath/"index.html").write <<~HTML
      <div className="prose">
        <h1>Headline</h1>
      </div>
      <input type="text" class="form-input" />
      <div class="aspect-w-16"></div>
    HTML

    (testpath/"input.css").write <<~CSS
      @tailwind base;
      @import "tailwindcss";
      @import "tailwindcss/theme" theme(reference);
      @import "tailwindcss/utilities";

      @plugin "@tailwindcss/forms";
      @plugin "@tailwindcss/typography";
      @plugin "@tailwindcss/aspect-ratio";
    CSS

    system bin/"tailwindcss", "--input", "input.css", "--output", "output.css"
    assert_path_exists testpath/"output.css"

    output = (testpath/"output.css").read
    assert_match ".form-input {", output
    assert_match ".prose {", output
    assert_match ".aspect-w-16 {", output
  end
end
