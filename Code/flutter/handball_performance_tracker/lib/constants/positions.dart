
///
// throw positions
///
const String inSix = "<6"; 
const String betweenSixAndNine = "6to9";
const String outsideNine = ">9"; 
const List<String> throwPositions = [inSix, betweenSixAndNine, outsideNine];
///
// player positions
///
const String leftOutside = "LA"; // links aussen
const String rightOutside = "RA"; // rechts aussen
const String backcourtLeft = "RL"; // rueckraum links
const String backcourtMiddle = "RM"; // rueckraum mitte
const String backcourtRight = "RR"; // rueckraum rechts
const String circle = "KR"; // kreiss
const String goalKeeper = "TW"; // torwart
const List<String> requiredPositions = [leftOutside, rightOutside, backcourtLeft, backcourtMiddle, backcourtRight, circle, goalKeeper];
const List<String> sectors = [leftOutside, rightOutside, backcourtLeft, backcourtMiddle, backcourtRight, circle]; 
///
// mapping of calculated sector numbers based on fieldIsLeft
///
const List<String> sectorsFieldIsLeft = [leftOutside, backcourtLeft, backcourtMiddle, backcourtRight, rightOutside];
const List<String> sectorsFieldIsRight = [rightOutside, backcourtRight, backcourtMiddle, backcourtLeft, leftOutside];
///
// special player position
///
const String defenseSpecialist = "Abwehr Spezialist"; // links aussen
