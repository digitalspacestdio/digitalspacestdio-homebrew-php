require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php74Gmp < AbstractPhp74Extension
  init
  desc "GMP core php extension"
  homepage "https://php.net/manual/en/book.gmp.php"
  revision 1


  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9cd8ec2a564a0f9b1afe54206d44cc8b201da0ed4d9035dd3845f8c606844d28"
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
