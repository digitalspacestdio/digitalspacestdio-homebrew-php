require File.expand_path("../../Abstract/abstract-php-extension", __FILE__)

class Php73Zip < AbstractPhp73Extension
  init
  desc "Zip"
  homepage "https://www.php.net/manual/ru/book.zip.php"
  revision 1

  url PHP_SRC_TARBALL
  sha256 PHP_CHECKSUM[:sha256]

  bottle do
    root_url "https://f003.backblazeb2.com/file/homebrew-bottles/php73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbc895d7feae4f84c823d8de69077f190632715a742520f0307224951a8f41e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "135b734dfd1ec64458673a882aecabcbb13371275c63ed83c0f4c571e1f6fea4"
    sha256 cellar: :any_skip_relocation, ventura:       "96b085898b33a9207065316cc524124e6bf570c0d77ee956a5f92410abd0c176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dde631a6c747287fd7c69b23c53f33e44b936da3d348af072704fb5dfa883401"
  end

  depends_on "libzip"
  depends_on "zlib"
  depends_on "pkg-config" => :build

  def install
        # Required due to icu4c dependency
    ENV.cxx11

    # icu4c 61.1 compatability
    #ENV.append "CPPFLAGS", "-DU_USING_ICU_NAMESPACE=1"
    
    Dir.chdir "ext/zip"

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-dependency-tracking",
                          "--enable-zip",
                          "--with-libzip=#{Formula["libzip"].opt_prefix}",
                          "--with-zlib-dir=#{Formula["zlib"].opt_prefix}"
    system "make"
    prefix.install "modules/zip.so"
    write_config_file if build.with? "config-file"
  end
end
