{ pkgs, ... }:

{
  stylix = {
    enable = true;
    polarity = "dark";
    image = ../wallpapers/JapanNasa.png;
  
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

  };
}
