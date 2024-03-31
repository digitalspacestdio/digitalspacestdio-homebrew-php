require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php70Gmp < AbstractPhp70Extension
  init
  desc "GMP core php extension"
  homepage "https://php.net/manual/en/book.gmp.php"
  revision PHP_REVISION


  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "117a2bdb3ae6dc524e591434d8ff76d814c56f439f372966f84cc513b308f08c"
    sha256 cellar: :any_skip_relocation, sonoma:       "d3e7def3748863b91085b4a74a09d48250d5b92a47708c0299e09fd0dcd42372"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c02c9f03be1a118f7bf243ff73277cf66884871aede364486ee29d231e241e15"
  end

  depends_on "gmp"

  def install
    Dir.chdir "ext/gmp"

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-dependency-tracking",
                           "--with-gmp=#{Formula["gmp"].opt_prefix}"
    system "make"
    prefix.install "modules/gmp.so"
    write_config_file if build.with? "config-file"
  end
end
