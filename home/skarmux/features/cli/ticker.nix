{ config, lib, pkgs, ... }:
{
  home.packages = with pkgs; [ ticker ];
  home.file.".ticker.yaml".text = # yaml
    ''
      show-summary: true
      show-tags: true
      show-fundamentals: true
      show-separator: true
      show-holdings: true
      interval: 5
      currency: EUR
      currency-summary-only: false
      watchlist:
        - CCOEF
        - POAHF
        - VODPF
        - BTC-EUR
      lots:
        - symbol: "CCOEF"
          quantity: 24.0
          unit_cost: 35.64
        - symbol: "POAHF"
          quantity: 1.0
          unit_cost: 49.78
        - symbol: "VODPF"
          quantity: 179.0
          unit_cost: 0.8415
          fixed_cost: 4.0
        - symbol: "BTC-EUR"
          quantity: 0.14906952
    '';
}
