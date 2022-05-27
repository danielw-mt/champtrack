const String attack = "attack"; 
const String defense = "defense"; 

const Map<String, Map<String, String>> actionMapping = {
  attack: {
    "Tor": "goal",
    "1v1 & 7m": "1v1",
    "2min ziehen": "2min",
    "Fehlwurf": "err-throw",
    "TRF": "trf",
  },
  defense: {
    "Rote Karte": "red",
    "Foul => 7m": "foul",
    "Zeitstrafe": "penalty",
    "Block ohne Ballgewinn": "block",
    "Block & Steal": "block-steal"
  }
};
