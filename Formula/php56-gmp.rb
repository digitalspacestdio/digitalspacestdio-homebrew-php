require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php56Gmp < AbstractPhp56Extension
  init
  desc "GMP core php extension"
  homepage "http://php.net/manual/en/book.gmp.php"
  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]
  revision PHP_REVISION

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "c197383fa6727490415c1afb4a719d84a1179322ef95e13eee5ffcf71e1cfc8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e839cf6c480fc97dfac633a021ce55444415fe6c5a524fe585a122db7263df1d"
  end


  depends_on "gmp"

  def install
    Dir.chdir "ext/gmp"

    # ENV.universal_binary if build.universal?

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
