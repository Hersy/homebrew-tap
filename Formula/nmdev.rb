class Nmdev < Formula
  desc "Native mobile developer: the delivery CLI for twin iOS + Android apps"
  homepage "https://github.com/Hersy/nmdev-releases"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/Hersy/nmdev-releases/releases/download/v0.12.0/nmdev-aarch64-apple-darwin.tar.xz"
      sha256 "70040323e72e3281cc6871152e9a4df1730854b5d94a52bcc2c4d5610dfc2ec0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/Hersy/nmdev-releases/releases/download/v0.12.0/nmdev-x86_64-apple-darwin.tar.xz"
      sha256 "b0c7e9cb337ae524074c94955aebbbc06fd10548824a2ab00e7dd82a1646da99"
    end
  end
  depends_on "ruby"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "nmdev"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "nmdev"
    end

    install_binary_aliases!

    bash_completion.install "completions/nmdev.bash" => "nmdev"
    zsh_completion.install "completions/_nmdev"
    fish_completion.install "completions/nmdev.fish"
    man1.install Dir["man/man1/*.1"]
    (man/"es/man1").install Dir["man/es/man1/*.1"]

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_equal "nmdev #{version}\n", shell_output("#{bin}/nmdev --version")
  end
end
