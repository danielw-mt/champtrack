///
// throw positions
///
const String inSixThrowPos = "<6";
const String interSixAndNineThrowPos = "6to9";
const String extNineThrowPos = ">9";
const List<String> throwPositions = [inSixThrowPos, interSixAndNineThrowPos, extNineThrowPos];

///
// player positions
///
const String leftOutsidePos = "LA"; // links aussen
const String rightOutsidePos = "RA"; // rechts aussen
const String backcourtLeftPos = "RL"; // rueckraum links
const String backcourtMiddlePos = "RM"; // rueckraum mitte
const String backcourtRightPos = "RR"; // rueckraum rechts
const String circlePos = "K"; // kreiss
const String goalkeeperPos = "TW"; // torwart
const List<String> sectors = [leftOutsidePos, rightOutsidePos, backcourtLeftPos, backcourtMiddlePos, backcourtRightPos, circlePos];

///
// mapping of calculated sector numbers based on fieldIsLeft
///
const List<String> sectorsFieldIsLeft = [leftOutsidePos, backcourtLeftPos, backcourtMiddlePos, backcourtRightPos, rightOutsidePos];
const List<String> sectorsFieldIsRight = [rightOutsidePos, backcourtRightPos, backcourtMiddlePos, backcourtLeftPos, leftOutsidePos];

///
// special player position
///
const String defenseSpecialist = "Abwehr Spezialist"; // links aussen
