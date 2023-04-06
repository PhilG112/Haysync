{ mkDerivation, aeson-pretty, async, base, bytestring, config-ini
, http-client, http-client-tls, http-types, lib, text
}:
mkDerivation {
  pname = "Haysync";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson-pretty async base bytestring config-ini http-client
    http-client-tls http-types text
  ];
  license = "unknown";
  hydraPlatforms = lib.platforms.none;
}
