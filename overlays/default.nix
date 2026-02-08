_: {
  additions = _final: _prev: {
  };

  modifications = final: prev: {
    # Downgrade inetutils to 2.6 to avoid compilation issues with 2.7 on macOS
    inetutils = prev.inetutils.overrideAttrs (_: {
      version = "2.6";
      src = final.fetchurl {
        url = "mirror://gnu/inetutils/inetutils-2.6.tar.xz";
        sha256 = "sha256-aL7b/q9z99hr4qfZm8+9QJPYKfUncIk5Ga4XTAsjV8o=";
      };
      # Remove patches that are specific to 2.7
      patches = [];
    });
  };
}
