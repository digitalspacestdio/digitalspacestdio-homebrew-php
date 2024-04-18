require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php80Gmp < AbstractPhp80Extension
  init
  desc "GMP core php extension"
  homepage "https://php.net/manual/en/book.gmp.php"
  revision PHP_REVISION


  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2028a1af94f1d001cfe2256d9c1f8dd25885096a2bc7ac8fa1e542ab1f5627b4"
    sha256 cellar: :any_skip_relocation, monterey:      "b95fb9c986c73f8a8d5e9777b6180bd32674a03f1ab140da49b60233bff22636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a85af335a9ec64fc9b73ac3e4eaedb350835af00fe35d39efc3040bf962c4e24"
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
