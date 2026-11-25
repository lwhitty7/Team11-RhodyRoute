import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import '/flutter_flow/ff_builtin_enums.dart';
import '/auth/firebase_auth/auth_util.dart';

List<LatLng> getCampusRoute(
  LatLng? startLocation,
  String? searchQuery,
  List<LatLng>? activeHazards,
  LatLng? lockedDestination,
) {
  if (searchQuery == null || searchQuery.trim().isEmpty) {
    return [];
  }

  // ───────────────────────── Tunables ─────────────────────────
  // CAMPUS-SAFE MODE: route polylines follow only links in the mapped graph.
  // Explicit grass surfaces, restricted-access ways and informal paths are excluded.
  // Latest Overpass GeoJSON: 2,353 features, including 1,131 line features and
  // 1,031 polygons. It contains no entrance=* or door=* tags. Building arrivals
  // therefore use manually curated approaches plus footway endpoints that meet
  // named building outlines. These are mapped approaches, not verified door tags.
  // Traffic preferences are based on OSM tags, not measured real-time traffic.
  const hazardRadiusM = 15.0;
  const hazardCostFactor =
      10.0; // used only if hazard fallback is explicitly enabled
  const allowRouteThroughHazards = false;
  // Relative walking cost by graph class (1.0 = normal distance).
  //   0 = mapped pedestrian ways
  //   1 = parking aisles / driveways
  //   2 = emergency-access / regular roads
  //   3 = eligible campus service roads / local streets
  // Quiet-road classification comes from static OSM tags, not live traffic counts.
  const classCost = <double>[1.0, 1.22, 1.85, 1.04];
  // Production behavior: do not silently substitute a demo location when GPS is
  // missing, invalid, or outside the campus boundary.
  final noLocationBehavior = 'empty';
  const demoStart = LatLng(41.485578, -71.533818);
  const campusCenterLat = 41.4865;
  const campusCenterLng = -71.5300;
  const maxDistFromCampusM = 3000.0;

  // ───────────────────── 1. Local metric projection ─────────────────────
  const refLat = 41.487;
  const refLng = -71.530;
  const mPerDegLat = 111320.0;
  final mPerDegLng = 111320.0 * math.cos(refLat * math.pi / 180.0);
  double toX(double lng) => (lng - refLng) * mPerDegLng;
  double toY(double lat) => (lat - refLat) * mPerDegLat;

  // ───────────────────── 2. Is the start location usable? ─────────────────────
  var start = startLocation ?? demoStart;
  final haveLocation = startLocation != null &&
      startLocation.latitude.isFinite &&
      startLocation.longitude.isFinite &&
      !(startLocation.latitude.abs() < 0.001 &&
          startLocation.longitude.abs() < 0.001) &&
      math.sqrt(
              math.pow(toX(startLocation.longitude) - toX(campusCenterLng), 2) +
                  math.pow(
                      toY(startLocation.latitude) - toY(campusCenterLat), 2)) <=
          maxDistFromCampusM;
  if (!haveLocation) {
    if (noLocationBehavior == 'empty') {
      return [];
    }
    start = demoStart;
  }

  // ───────────────────── 3. Destination lookup ─────────────────────
  // Buildings from OpenStreetMap, one per line:  name|lat,lng|alias;alias
  // The coordinate is the point on the building's outline closest to a real walkway.
  // Aliases are extra search words (I added a few obvious ones; edit freely).
  const buildingData = r'''
Swan Hall|41.484639,-71.526340|
Brookside|41.489322,-71.533624|brookside bistro;brookside hall
Fine Arts Center|41.487804,-71.524324|farts;fine arts building;music building;fac;art center
Christ the King Catholic Church|41.485444,-71.521942|
Taft Hall|41.487331,-71.528519|
Kirk Applied Engineering Laboratory|41.487982,-71.525389|
Memorial Union|41.484679,-71.529757|mu;union;student union;uri union;memorial;student center
Green Hall|41.484659,-71.527642|
Edwards Auditorium|41.485441,-71.526288|
East Hall|41.486746,-71.526009|
Bliss Hall|41.487206,-71.526114|
Ballentine Hall|41.487299,-71.528001|
Washburn Hall|41.486074,-71.526344|
Quinn Hall|41.485132,-71.528392|
Ranger Hall|41.485310,-71.527416|
Davis Hall|41.486522,-71.528446|
Lippitt Hall|41.487155,-71.527480|
Kingston Fire Department|41.487251,-71.522052|
Coastal Institute Kingston|41.490157,-71.526490|
Hopkins Hall|41.486841,-71.532292|
Pastore Engineering Laboratory|41.484563,-71.528781|
Morrill Hall|41.484066,-71.528035|
University Police|41.483145,-71.524535|police;campus police;uri police;uri police department
URI Foundation|41.485405,-71.525728|
Alumni Center|41.484906,-71.525721|
IEP House|41.484581,-71.525687|
Texas Instruments House|41.484245,-71.525683|
Woodward Hall|41.488909,-71.527839|
Chafee Social Science Center|41.489200,-71.528703|
Center for Biotechnology and Life Sciences|41.490304,-71.528647|cbls;biotech;biotechnology building;life sciences
Tyler Hall|41.488990,-71.526965|
Kirk Center for Advanced Technology|41.487473,-71.525799|
Ryan Center|41.488202,-71.535984|the ryan
Mackal Field House|41.485464,-71.535809|
Roosevelt Hall|41.486506,-71.529587|
Adams|41.484205,-71.532235|
Aldrich|41.487825,-71.532317|
Hutchinson|41.486848,-71.530459|
Browning|41.485450,-71.532352|
Burnside|41.488139,-71.532679|
Peck|41.486625,-71.531001|
Carothers Library|41.487535,-71.528289|library;the library;carothers;carothers lib;uri library;campus library
Coddington|41.487704,-71.533131|
Dorr|41.486998,-71.532925|the best hall
Eddy|41.485464,-71.533238|
Ellery|41.486931,-71.533261|
Fayerweather|41.486059,-71.532877|
Fogarty|41.483852,-71.528976|
Gorham|41.486612,-71.532798|
Heathman|41.489291,-71.531979|
Merrow|41.487708,-71.531043|
Potter|41.485993,-71.531917|
Presidents' House|41.483777,-71.526679|
Rodman|41.488282,-71.528971|
Tucker|41.488103,-71.530536|
White|41.490012,-71.530666|
Hope Commons|41.486997,-71.530992|hope;hope commons;hope dining;hope dining hall;mainfare;corner store;mainfare dining;mainfare dining hall
Social Science Research Center|41.490618,-71.529483|
Human Resource Building|41.486308,-71.529276|
Carlotti Administration Building|41.485981,-71.528492|
Green Houses|41.489596,-71.525732|
Research and Grant Accounting|41.485560,-71.529336|
Adams Hall|41.485667,-71.525755|
Mallon Outreach Center|41.488804,-71.525967|
Anna Fascitelli Fitness and Wellness Center|41.487516,-71.532668|rec center;rec;fitness center;gym;wellness center;afwc
Barlow|41.483916,-71.531940|
Bressler Hall|41.484518,-71.530950|
Butterfield Hall|41.484948,-71.531237|butterfield;butterfield hall;butterfield dorm;butterfield residence hall
Garrahy|41.490759,-71.531760|
Parking Services|41.483835,-71.529419|
Weldin|41.483869,-71.532613|
Wiley|41.490364,-71.532267|
Kappa Delta|41.483779,-71.533636|
Chi Omega|41.483370,-71.533632|
Hillel Center|41.482862,-71.532335|
Zeta Beta Tau|41.483234,-71.533214|
Multicultural Student Services Center|41.485765,-71.529313|
Butterfield Dining|41.485491,-71.531696|butterfield dining hall;butterfield dining
Keaney Gymnasium|41.485987,-71.535633|keaney;keaney gym;gymnasium
Theta Delta Chi|41.482572,-71.533591|
Alpha Chi Delta|41.482596,-71.534806|
Theta Chi|41.481918,-71.532664|
Zeta Tau Alpha|41.482499,-71.532268|
Alpha Delta Pi|41.482353,-71.531433|
Delta Zeta|41.482066,-71.533422|
Sigma Delta Tau|41.482537,-71.535132|
Alpha Chi Omega|41.481799,-71.531532|
Sigma Kappa|41.482339,-71.533996|
Hillside|41.483547,-71.531475|
Emergency Medical Services|41.491167,-71.535798|ems
Child Development Center|41.481926,-71.530419|
Episcopal Center|41.482122,-71.529572|
Women's Center|41.481578,-71.525766|
Newman Hall|41.481245,-71.525766|
Kingston Free Library|41.480606,-71.525351|
Helme House Gallery|41.480327,-71.524658|
South County Art Association|41.480286,-71.524370|
United States Post Office|41.483476,-71.525156|
Kingston Pizza|41.483060,-71.523764|
Hart House|41.482366,-71.525889|
Transition Center|41.481353,-71.530687|
Phi Sigma Sigma|41.482851,-71.529121|
International Center|41.483265,-71.529017|
Christopher House|41.483295,-71.529652|
Pastore Annex|41.484928,-71.528354|
Dining Services Distribution Center|41.490923,-71.534629|
Avedisian Hall|41.489415,-71.526866|
Beaupre Center for Chemical and Forensic Sciences|41.489833,-71.529821|
Pettaquamscutt Historical Society Building|41.480289,-71.526323|
Fayerweather House|41.480344,-71.520195|
Oliver Watson House|41.488150,-71.530003|
Bru RI Coffee Bar|41.484394,-71.523439|
Robert J Higgins Welcome Center|41.483885,-71.525664|welcome center;higgins
Phi Gamma Delta|41.488703,-71.529888|
Tucker House|41.486312,-71.525478|
Gate House|41.483567,-71.532401|
Catholic Center|41.486936,-71.523809|
The Fascitelli Center For Advanced Engineering|41.487617,-71.526807|engineering
Central Receiving|41.491013,-71.535802|
Sherman|41.489582,-71.536409|
Wakefield House|41.489154,-71.536013|
Lands and Grounds|41.489000,-71.535187|
Automotive Garage|41.490354,-71.534360|
URI University Club|41.487219,-71.525061|
''';

  // Named or numbered parking features from the supplied OSM GeoJSON export.
  // Format: display name|latitude,longitude|search aliases separated by semicolons.
  // These OSM point coordinates are approximate lot locations, NOT verified pedestrian entrances.
  const parkingData = r'''
Parking Lot 16|41.4903389,-71.5305345|parking lot;16;lot 16;parking 16;parking lot 16
Keaney Lot 26|41.4835211,-71.5361509|parking lot;keaney;keaney parking;keaney lot;keaney lot 26;lot 26;parking 26;parking lot 26;parking near keaney
Parking Lot 4|41.4855935,-71.5226120|parking lot;4;lot 4;parking 4;parking lot 4
Parking Lot 3|41.4864874,-71.5252472|parking lot;3;lot 3;parking 3;parking lot 3
Parking Lot 14|41.4877440,-71.5295560|parking lot;14;lot 14;parking 14;parking lot 14
Parking Lot 8|41.4864444,-71.5259850|parking lot;8;lot 8;parking 8;parking lot 8
Fine Arts Lot 7|41.4886931,-71.5221183|parking lot;fine arts lot;fine arts parking;fine arts lot 7;lot 7;parking 7;parking lot 7;fine arts 7
Fine Arts Lot 6|41.4877039,-71.5224465|parking lot;fine arts lot;fine arts parking;fine arts lot 6;lot 6;parking 6;parking lot 6;fine arts 6
Parking Lot 29|41.4841667,-71.5390338|parking lot;29;lot 29;parking 29;parking lot 29
Boss Lot|41.4840935,-71.5368043|parking lot;boss;boss lot;boss parking;parking near boss
Ram Lot 23|41.4885913,-71.5360640|parking lot;ram;ram lot;ram parking;ram lot 23;lot 23;parking 23;parking lot 23
Parking Lot 22|41.4894348,-71.5346632|parking lot;22;lot 22;parking 22;parking lot 22
Parking Lot 28|41.4914143,-71.5359179|parking lot;28;lot 28;parking 28;parking lot 28
Plains Road Lot 25|41.4905627,-71.5388526|parking lot;plains road;plains road parking;plains road lot;plains road lot 25;lot 25;parking 25;parking lot 25
Briar Lane Lot|41.4839527,-71.5245333|parking lot;briar lane;briar lane parking;briar lane lot;parking near briar lane
Parking Lot 15|41.4866926,-71.5300764|parking lot;15;lot 15;parking 15;parking lot 15
Parking Lot 13|41.4888785,-71.5298271|parking lot;13;lot 13;parking 13;parking lot 13
Parking Lot 9|41.4899504,-71.5254006|parking lot;9;lot 9;parking 9;parking lot 9
Flagg Road Lot 20|41.4920760,-71.5342906|parking lot;flagg road;flagg road parking;flagg road lot;flagg road lot 20;lot 20;parking 20;parking lot 20
Parking Lot 17|41.4862678,-71.5315108|parking lot;17;lot 17;parking 17;parking lot 17
Parking Lot 19|41.4841943,-71.5333524|parking lot;19;lot 19;parking 19;parking lot 19
Parking Lot 10|41.4839185,-71.5278139|parking lot;10;lot 10;parking 10;parking lot 10
Parking Lot 11|41.4836614,-71.5287282|parking lot;11;lot 11;parking 11;parking lot 11
Parking Lot 2|41.4849671,-71.5250609|parking lot;2;lot 2;parking 2;parking lot 2
Parking Lot 12|41.4826006,-71.5291879|parking lot;12;lot 12;parking 12;parking lot 12
Parking Lot 5|41.4872430,-71.5245731|parking lot;5;lot 5;parking 5;parking lot 5
Plains Road South Lot 31|41.4889840,-71.5408535|parking lot;plains road south;plains road south parking;plains road south lot;lot 31;parking 31;parking lot 31
Parking Lot 18|41.4827295,-71.5313603|parking lot;18;lot 18;parking 18;parking lot 18
''';

  // Manually curated and OSM-derived building approach points. The newest export
  // has building footprints and footways but no explicit entrance=* / door=* tags.
  // Hope Commons has two user-confirmed entrances supplied in DMS:
  //   41°29'14.5"N 71°31'51.2"W -> 41.4873611,-71.5308889
  //   41°29'14.2"N 71°31'53.5"W -> 41.4872778,-71.5315278
  // Both are evaluated independently. The nearest mapped pedestrian edge is
  // approximately 7.83 m from the first and 4.14 m from the second, so Hope
  // Commons has a specific 9 m snap allowance. Its final short connector is
  // included in the route because these two coordinates were supplied as actual
  // entrance locations by the user. Other approaches remain inferred/manual.
  // Explicitly reported bad/employee-only points have been removed.
  const entranceData = r'''
Taft Hall|41.4873507,-71.5285380;41.4873936,-71.5282337;41.4873389,-71.5281894;41.4871648,-71.5281981;41.4873043,-71.5281908
Kirk Applied Engineering Laboratory|41.4879951,-71.5256046;41.4879824,-71.5253889;41.4882083,-71.5253015
Memorial Union|41.4845806,-71.5293582;41.4855047,-71.5295233;41.4850995,-71.5295457;41.4854791,-71.5295244;41.4855258,-71.5295301;41.4854463,-71.5295263;41.4843981,-71.5295142;41.4844065,-71.5293892;41.4846834,-71.5293693;41.4849547,-71.5293532;41.4854829,-71.5295520;41.4845152,-71.5297690;41.4845165,-71.5298009;41.4846793,-71.5297574;41.4846810,-71.5297948
Green Hall|41.4847517,-71.5272316;41.4846593,-71.5276634;41.4847397,-71.5274542
Edwards Auditorium|41.4854437,-71.5262881;41.4853069,-71.5264925;41.4850789,-71.5264917
East Hall|41.4868031,-71.5262926;41.4867463,-71.5260089;41.4868238,-71.5261643
Bliss Hall|41.4873810,-71.5263589;41.4872274,-71.5266177;41.4871131,-71.5263695;41.4872057,-71.5261139
Ballentine Hall|41.4871527,-71.5278284;41.4872986,-71.5280013;41.4873312,-71.5277958
Washburn Hall|41.4860742,-71.5263436;41.4858727,-71.5262385
Quinn Hall|41.4854012,-71.5283690;41.4852748,-71.5286148;41.4851317,-71.5283916;41.4855336,-71.5284756;41.4851442,-71.5286242
Ranger Hall|41.4853098,-71.5274160;41.4854569,-71.5273102;41.4852981,-71.5272216;41.4854074,-71.5276020
Davis Hall|41.4865236,-71.5284723;41.4865221,-71.5284460;41.4864884,-71.5281960
Lippitt Hall|41.4871551,-71.5274985;41.4871000,-71.5275237;41.4872373,-71.5268817
Coastal Institute Kingston|41.4901684,-71.5264798
Hopkins Hall|41.4868441,-71.5323125
Pastore Engineering Laboratory|41.4847536,-71.5281904;41.4845625,-71.5287815
Morrill Hall|41.4840631,-71.5279791
URI Foundation|41.4854342,-71.5254286;41.4854059,-71.5257294;41.4852930,-71.5254994
Alumni Center|41.4849113,-71.5254975;41.4849061,-71.5257212
IEP House|41.4845654,-71.5256990
Texas Instruments House|41.4842447,-71.5256896;41.4842161,-71.5257136
Woodward Hall|41.4889091,-71.5278395;41.4884873,-71.5277992
Chafee Social Science Center|41.4890801,-71.5286377;41.4887791,-71.5287849;41.4892097,-71.5289402;41.4891998,-71.5287034;41.4893593,-71.5281764;41.4894666,-71.5285364;41.4895673,-71.5289847
Center for Biotechnology and Life Sciences|41.4903041,-71.5286791
Tyler Hall|41.4890186,-71.5265456;41.4889896,-71.5269650;41.4890644,-71.5271957
Kirk Center for Advanced Technology|41.4874716,-71.5254436;41.4875444,-71.5257815;41.4874733,-71.5257990;41.4876949,-71.5255948;41.4876887,-71.5255654
Ryan Center|41.4872464,-71.5354301;41.4882024,-71.5359843;41.4882779,-71.5358327;41.4882332,-71.5357350;41.4880889,-71.5361857
Mackal Field House|41.4849922,-71.5359148;41.4847947,-71.5359702;41.4854638,-71.5358091
Roosevelt Hall|41.4866541,-71.5297690;41.4865097,-71.5297780;41.4866459,-71.5296030;41.4869746,-71.5296616;41.4861648,-71.5297224
Adams|41.4845410,-71.5320306;41.4841925,-71.5322361
Aldrich|41.4878243,-71.5323171;41.4880974,-71.5321547;41.4878223,-71.5323792
Hutchinson|41.4865994,-71.5307110;41.4862889,-71.5305451;41.4866165,-71.5306867;41.4866016,-71.5303613;41.4866006,-71.5303301;41.4868431,-71.5303841;41.4868475,-71.5304587
Browning|41.4856099,-71.5324731;41.4854643,-71.5323519;41.4850733,-71.5322192;41.4857168,-71.5319704
Burnside|41.4881738,-71.5324724;41.4881282,-71.5326846
Peck|41.4865388,-71.5313613;41.4866246,-71.5310011;41.4863690,-71.5309737
Carothers Library|41.4873440,-71.5290692
Coddington|41.4876807,-71.5331213
Dorr|41.4869907,-71.5328848
Eddy|41.4856139,-71.5330310;41.4857436,-71.5327087;41.4854653,-71.5332590
Ellery|41.4869548,-71.5332518;41.4865086,-71.5332961
Fayerweather|41.4860823,-71.5334829;41.4862027,-71.5330874;41.4860510,-71.5328686
Fogarty|41.4838523,-71.5289755;41.4838203,-71.5281253;41.4839296,-71.5286135;41.4837523,-71.5286502
Gorham|41.4866186,-71.5328057;41.4862951,-71.5329130;41.4868414,-71.5324561
Heathman|41.4900089,-71.5315232;41.4903605,-71.5313995;41.4896197,-71.5317082;41.4896836,-71.5316143;41.4892996,-71.5319780;41.4892570,-71.5318737
Merrow|41.4877083,-71.5310429;41.4880296,-71.5312022
Potter|41.4859793,-71.5319067
Presidents' House|41.4837755,-71.5266518
Rodman|41.4882784,-71.5287957;41.4886589,-71.5291076;41.4886818,-71.5290701;41.4882822,-71.5289707
Tucker|41.4881077,-71.5305408
White|41.4897784,-71.5304298;41.4899461,-71.5303890;41.4900387,-71.5306339;41.4898717,-71.5308346;41.4900117,-71.5306663;41.4897474,-71.5306369
Hope Commons|41.4873611,-71.5308889;41.4872778,-71.5315278
Social Science Research Center|41.4901732,-71.5291062;41.4904549,-71.5287295;41.4904590,-71.5296089;41.4906182,-71.5294832
Human Resource Building|41.4863466,-71.5293101
Carlotti Administration Building|41.4859815,-71.5284918;41.4859922,-71.5286658;41.4862675,-71.5285779
Green Houses|41.4895965,-71.5257321;41.4897051,-71.5257445;41.4897238,-71.5251121
Research and Grant Accounting|41.4855605,-71.5293508
Adams Hall|41.4855577,-71.5256438;41.4856669,-71.5257549
Mallon Outreach Center|41.4888040,-71.5259674
Anna Fascitelli Fitness and Wellness Center|41.4872036,-71.5320768;41.4875416,-71.5319615
Barlow|41.4839161,-71.5319402;41.4836810,-71.5320279;41.4838566,-71.5317424;41.4835940,-71.5317104
Bressler Hall|41.4848499,-71.5306903;41.4845186,-71.5309679;41.4844139,-71.5309131
Butterfield Hall|41.4845734,-71.5313038;41.4845571,-71.5314815
Garrahy|41.4907588,-71.5317600;41.4908659,-71.5313873
Parking Services|41.4838349,-71.5294188
Weldin|41.4838689,-71.5325938;41.4834802,-71.5329664
Wiley|41.4904064,-71.5318634;41.4900753,-71.5323485;41.4899612,-71.5326570;41.4903638,-71.5322670
Hillel Center|41.4828617,-71.5323347
Zeta Beta Tau|41.4833696,-71.5331578
Multicultural Student Services Center|41.4857525,-71.5293130
Butterfield Dining|41.4854918,-71.5317129;41.4849830,-71.5317403
Keaney Gymnasium|41.4859867,-71.5356330;41.4863612,-71.5364522
Theta Delta Chi|41.4825222,-71.5336090
Alpha Chi Delta|41.4830805,-71.5342819
Theta Chi|41.4819179,-71.5326636;41.4818846,-71.5326820
Zeta Tau Alpha|41.4824925,-71.5322321
Alpha Delta Pi|41.4823166,-71.5314445
Delta Zeta|41.4820660,-71.5334220;41.4822250,-71.5335710
Sigma Delta Tau|41.4825895,-71.5351043
Alpha Chi Omega|41.4816407,-71.5313603
Sigma Kappa|41.4824006,-71.5339744
Hillside|41.4835569,-71.5312712;41.4835470,-71.5314843;41.4837245,-71.5312268;41.4835632,-71.5315003;41.4834669,-71.5312795;41.4832269,-71.5311192
Emergency Medical Services|41.4912077,-71.5357503
Child Development Center|41.4819263,-71.5304187
Women's Center|41.4816420,-71.5257427;41.4815785,-71.5257657
Newman Hall|41.4812452,-71.5257657
Kingston Free Library|41.4806994,-71.5253944;41.4807392,-71.5252039;41.4805574,-71.5251907;41.4806060,-71.5253514
Helme House Gallery|41.4803184,-71.5246605
South County Art Association|41.4802702,-71.5243745
United States Post Office|41.4835884,-71.5251294
Hart House|41.4823884,-71.5257388
Transition Center|41.4813527,-71.5306874;41.4814823,-71.5305119
Phi Sigma Sigma|41.4828510,-71.5291207
International Center|41.4832648,-71.5290171
Pastore Annex|41.4849572,-71.5283514
Dining Services Distribution Center|41.4909102,-71.5345471
Avedisian Hall|41.4894186,-71.5268535
Beaupre Center for Chemical and Forensic Sciences|41.4895557,-71.5292922;41.4896773,-71.5290363;41.4897793,-71.5292699;41.4898329,-71.5298206;41.4895754,-71.5291746
Pettaquamscutt Historical Society Building|41.4803933,-71.5262960
Fayerweather House|41.4803059,-71.5201824
Oliver Watson House|41.4881764,-71.5300005
Bru RI Coffee Bar|41.4845396,-71.5233723
Robert J Higgins Welcome Center|41.4837292,-71.5253451;41.4835761,-71.5256524;41.4838845,-71.5256640
Phi Gamma Delta|41.4886957,-71.5297206
Tucker House|41.4863116,-71.5254776
Gate House|41.4835814,-71.5324335
Catholic Center|41.4869417,-71.5238467
The Fascitelli Center For Advanced Engineering|41.4884166,-71.5259658;41.4875973,-71.5265812;41.4881465,-71.5258242;41.4878010,-71.5265722;41.4879084,-71.5261796;41.4879255,-71.5265625;41.4880032,-71.5258337;41.4875983,-71.5266108;41.4883096,-71.5265694;41.4883079,-71.5267754;41.4883194,-71.5267959;41.4882915,-71.5261513;41.4883571,-71.5261476;41.4881886,-71.5265468;41.4876166,-71.5268065
Central Receiving|41.4912077,-71.5357503
Sherman|41.4891107,-71.5365883
Wakefield House|41.4890130,-71.5360427
Lands and Grounds|41.4889119,-71.5352061
Automotive Garage|41.4904247,-71.5343379
URI University Club|41.4871976,-71.5250685
''';

  String norm(String s) => s
      .toLowerCase()
      .replaceAll(RegExp("['\u2019]"), '')
      .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  final q = norm(searchQuery);
  if (q.length < 2) {
    return [];
  }
  final qTokens = q.split(' ');

  // Exact phrase > phrase prefix > all query words matching name/alias words > contains.
  // This keeps partial searches useful without accepting unrelated one-letter matches.
  int scoreName(String s) {
    if (s.isEmpty) return 0;
    if (s == q) return 100;
    if (s.startsWith(q)) return 85;

    final words = s.split(' ');
    if (qTokens.length == 1) {
      for (final w in words) {
        if (w.startsWith(q)) return 70;
      }
    }

    var all = true;
    for (final t in qTokens) {
      var found = false;
      for (final w in words) {
        if (w.startsWith(t) || (t.length >= 3 && w.contains(t))) {
          found = true;
          break;
        }
      }
      if (!found) {
        all = false;
        break;
      }
    }
    if (all) return 60;
    if (q.length >= 3 && s.contains(q)) return 45;
    if (s.length >= 4 && q.contains(s)) return 30;
    return 0;
  }

  var bestScore = 0;
  var bestKind = '';
  var bestName = '';
  var bestDistance = double.infinity;
  LatLng? destination;

  void considerDestinations(String data, String kind) {
    for (final raw in data.split('\n')) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      final parts = line.split('|');
      if (parts.length < 2) continue;

      var sc = scoreName(norm(parts[0]));
      if (parts.length > 2 && parts[2].isNotEmpty) {
        for (final alias in parts[2].split(';')) {
          final v = scoreName(norm(alias));
          if (v > sc) sc = v;
        }
      }
      if (sc <= 0) continue;

      final ll = parts[1].split(',');
      if (ll.length != 2) continue;
      final candidate = LatLng(double.parse(ll[0]), double.parse(ll[1]));
      final dx = toX(candidate.longitude) - toX(start.longitude);
      final dy = toY(candidate.latitude) - toY(start.latitude);
      final candidateDistance = math.sqrt(dx * dx + dy * dy);

      // Buildings win a same-score tie against parking aliases (e.g. "Fine Arts").
      // Within the same destination type, choose the closest duplicate/ambiguous match.
      final buildingPreferred = sc == bestScore &&
          sc > 0 &&
          kind == 'building' &&
          bestKind == 'parking';
      final genericParkingSearch = q == 'parking' || q == 'parking lot';
      final parkingPreferred = sc == bestScore &&
          sc > 0 &&
          genericParkingSearch &&
          kind == 'parking' &&
          bestKind == 'building';
      final sameKindCloser = sc == bestScore &&
          sc > 0 &&
          kind == bestKind &&
          candidateDistance < bestDistance;

      if (sc > bestScore ||
          buildingPreferred ||
          parkingPreferred ||
          sameKindCloser) {
        bestScore = sc;
        bestKind = kind;
        bestName = parts[0];
        bestDistance = candidateDistance;
        destination = candidate;
      }
    }
  }

  // Evaluate buildings first so a broad query such as "Fine Arts" resolves to the
  // building, while a more specific query such as "Fine Arts Lot 7" finds parking.
  considerDestinations(buildingData, 'building');
  considerDestinations(parkingData, 'parking');

  final initialDestination = destination;
  if (initialDestination == null) {
    return [];
  }

  // Select mapped approach points for this building when available.
  // Do not also test the old wall/centroid coordinate: that can create a straight
  // line across lawn or land on a staff-only side. The stored points are path
  // approaches inferred from building footprints and the supplied pedestrian ways,
  // plus manual corrections from the testing PDF. They are not verified door tags.
  final destinationCandidates = <LatLng>[];
  if (bestKind == 'building' && bestName.isNotEmpty) {
    for (final raw in entranceData.split('\n')) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      final parts = line.split('|');
      if (parts.length < 2 || norm(parts[0]) != norm(bestName)) continue;

      for (final rawCoordinate in parts[1].split(';')) {
        final ll = rawCoordinate.trim().split(',');
        if (ll.length != 2) continue;
        final lat = double.tryParse(ll[0]);
        final lng = double.tryParse(ll[1]);
        if (lat == null || lng == null || !lat.isFinite || !lng.isFinite) {
          continue;
        }
        final candidate = LatLng(lat, lng);
        final duplicate = destinationCandidates.any((existing) {
          final dx = toX(candidate.longitude) - toX(existing.longitude);
          final dy = toY(candidate.latitude) - toY(existing.latitude);
          return dx * dx + dy * dy < 0.25;
        });
        if (!duplicate) destinationCandidates.add(candidate);
      }
    }
  }

  // If no mapped/manual approach is available, allow the original coordinate
  // only when it can be snapped to a graph edge within a strict 3 m limit below.
  // The returned polyline still ends on the graph; it never draws a lawn connector.
  if (destinationCandidates.isEmpty) {
    destinationCandidates.add(initialDestination);
  }

  // ───────────────────── 4. Walkways, parking aisles and campus roads ─────────────────────
  // One way per line: class|y,x y,x y,x ...
  // Coordinates are millionths of a degree from (41.478, -71.542). The first pair is
  // absolute; later pairs are deltas. Shared OSM vertices become graph junctions.
  //
  // Network rebuilt from the latest complete Overpass GeoJSON export. Explicit
  // grass/earth/dirt/mud/sand/ground/unpaved surfaces, informal=yes paths, and
  // access/foot values private, no, permit, customers or employees are excluded.
  // Class 0 = mapped pedestrian ways; 1 = parking aisles / driveways;
  // 2 = emergency-access / regular roads; 3 = unrestricted campus service and
  // unclassified local-road candidates. Class 3 is a static OSM-tag preference,
  // NOT a claim that live traffic has been measured.
  // V7 graph based on V6 Overpass network, with two user-confirmed Hope Commons entrances. Included ways by class: class 0=707, class 1=161, class 2=28, class 3=152.
  // Excluded line features by reason: {'grass_or_unpaved_surface': 6, 'restricted_access': 10, 'informal': 22}.
  const waysData = r'''
3|7720,13854 24,-574 -12,-141 -31,-87 -37,-44
3|8460,7116 63,-22 95,-28 149,-101 200,-96 30,7 30,26 33,41 13,61 -6,52 -16,42 -32,55 -70,30 -271,-27 -66,-7 -152,-33 -368,-31 -133,-8 -911,-56 -45,-4 -236,-18 -62,-6
0|12585,14174 -91,-19 -35,-6 -847,-141 -63,-14 -402,-28 -229,-17 -711,-53 -109,-20 -157,-3 -197,-16 -17,-1 -38,-11 -78,-24 -77,-3 -162,-6 -68,-3 -124,-5
3|2772,16288 38,159 17,71
3|8975,16398 1,-83 5,-225 3,-162 2,-64 1,-56 6,-245 2,-78 8,-405
2|13317,8776 -7,53 -49,350 -83,571 -29,190 -76,511 -84,568 -45,259 -14,73 -80,600 -23,205 -7,64 -88,976 -90,988 -82,897 -64,635 -36,270 -17,114 -30,178 -63,374 -102,556 -58,261 -102,332 -30,81 -236,670 -70,221 -142,465 -163,561 -102,469 -12,60 -49,291 -67,476 -141,915 -83,584
2|2087,21126 -390,123 -167,52 -557,161 -64,18 -180,50 -484,145 -328,107 -229,115 -206,145 -282,228 -1635,1351 -121,102 -877,737 -2381,1969 -12,10 -37,28 -743,610 -489,412 -304,250 -466,405 -839,672 -297,235 -127,101 -233,160 -96,50 -156,81 -228,113 -218,112 -52,27 -325,167 -23,7 -172,92 -84,40 -27,13 -72,37 -229,119 -62,32 -315,163 -88,46 -419,211 -148,75 -292,149 -194,80 -316,166 -310,162 -540,282 -537,281 -242,126 -119,62 -366,184 -39,20 -583,302 -130,67 -88,42 -87,42 -335,120 -89,32 -518,164 -252,80 -125,32 -110,29 -89,23 -203,38 -133,16 -244,15 -62,-3 -297,-12 -496,-38 -791,-61 -289,-21 -148,16 -151,27 -179,54 -185,70 -251,111 -80,36 -168,95 -203,146 -150,134 -151,154 -142,162 -122,156 -29,38 -27,36 -130,168
3|6406,12934 118,2 177,7 287,13 154,7 149,6 169,8 29,1 122,5 53,25
3|3018,12014 76,15 421,81 277,55 230,50 33,10 218,65 24,9 62,18 288,88 75,24 207,68 555,200 65,24
3|4055,6341 -380,-86 -1362,-291 -160,-50 -132,85 -115,78 -189,130
3|10218,12065 -12,126 -7,74
3|10453,14843 14,142 7,121 7,83 5,72
2|1973,18936 -102,-31 -97,-30 -153,-58 -228,-87 -553,-190 -944,-267 -246,-69 -294,-84 -849,-267 -74,-23 -359,-107 -652,-145 -267,-68 -298,-77 -667,-183 -145,-46 -508,-137 -465,-160 -645,-244 -344,-111 -652,-211 -255,-82 -193,-52 -264,-70 -103,-28 -457,-137 -30,-9 -223,-62 -118,-32 -142,-23 -396,-38 -500,-38 -754,-58 -125,-14 -131,-13 -351,-24 -397,-26 -493,-33 -492,-45 -290,-16 -141,-15 -57,0 -611,-27 -83,-4 -42,-7 -171,-5 -72,-2 -28,-1 -451,-32 -87,-6 -188,-11 -213,-12 -396,-30 -572,-16 -117,-10 -40,-3 -137,-5 -229,-4 -511,-46 -121,-17 -81,-14 -256,-53 -198,-54 -111,-15 -88,-30 -18,-10 -104,-59 -175,-130 -180,-160 -62,-67 -23,-18 -35,-25 -67,-47 -259,-171 -252,-122 -204,-90 -158,-70 -805,-435 -755,-374 -54,-23 -110,-61 -19,0 -19,-8 -77,-15 -42,-15 -42,-8 -42,-15 -38,0 -38,-8 -206,0 -1179,229 -805,191 -428,92 -495,106 -293,38 -413,78 -591,121 -68,8 -65,0 -31,7 -80,15 -278,92 -96,46 -172,94 -38,20 0,8 -101,55 -497,273 -448,306 -550,375 -100,68 -1187,800 -493,328 -108,80 -78,57 -836,595 -832,555 -38,25 -309,167 -15,8 -423,210 -1484,736 -267,140 -546,288 -290,137 -23,13 -259,140 -793,404 -390,211 -72,41 -539,265 -98,48 -159,79 -371,149 -88,62 -229,236 -160,198 -225,267 -202,229 -220,233 -97,103 -313,244 -164,99 -377,206 -23,10 -27,13 -309,138 -301,144 -248,130 -950,443 -538,244 -130,68 -847,386 -225,103 -465,226 -99,48 -523,229 -313,153 -164,120 -23,17 -152,206 -141,305 -168,396
3|973,21462 -106,-679 -73,-420 -4,-8
3|756,20386 34,-31 -10,-70 -16,-105 -27,-84 -50,-31 -57,39 -30,114 15,122 30,76 50,0 61,-30
3|9029,13961 -90,-8 -371,-32 -81,-4 -48,-6 -94,-6 -580,-47 -45,-4
3|6077,10208 -11,8 -5,51 -3,34 -24,495 -7,141 -8,248 -5,113 -15,164 -18,102
3|5225,14815 -1265,-299
3|10486,15261 48,-7 222,163 117,108 48,44 135,103
3|9595,22095 42,389 156,1106 65,428 61,534 38,312
2|11058,5121 -57,426 -76,572 -105,836 -11,83 -72,571 -9,67 -90,669 -23,170
3|12944,11278 -65,-34 -320,-135 -162,-51 -132,-41 -381,-88 -27,-6 -19,-5 -622,-130 -37,-18 -145,-83 -86,-73 -16,-14 -202,-178 -205,-181 -86,-76
3|9793,23590 -534,138 -492,106
2|12058,17882 -71,-36 -830,-348 -25,-11 -237,-115 -114,-61 -291,-207 -59,-36 -73,-47 -57,-34 -6,-3 -250,-130 -337,-139 -61,-24 -379,-159 -293,-134 -67,-27 -642,-207 -117,-42 -109,-33 -114,-27 -185,-28 -62,-2 -56,-2 -66,-1 -92,1 -331,15 -233,9 -311,11 -74,3 -464,21 -255,9 -535,19 -95,20
1|10925,6119 66,17 238,59
3|11571,123 183,-405 183,-1176 23,-172 6,-74 47,-142 60,-147 45,-80 34,-64
3|4651,4311 7,138 -65,566 -21,223 -2,81 874,1120 75,75 70,70 313,206 114,61 119,46 258,67 35,9 77,8 72,0 43,5 85,7
3|4357,4287 294,24 156,46 141,76 80,58 119,87 68,61 65,69 130,167 61,92 126,153 27,40 137,181 107,137 53,61 118,122 65,54 130,84 42,18 27,12 202,69 110,23 59,0 62,0
0|4489,5429 -84,36 -121,15 -32,31 -99,681 -14,98 -5,35 -125,656 -193,939 -148,797 -158,821 -15,55 -16,58 -76,410 -105,683 -49,309 -73,454 -63,405 -4,24 280,37 74,61 69,14 265,53 268,53 215,71 91,31 251,85 34,12 562,202 277,91 18,-26
3|6705,6993 15,-562 13,-443 3,-67
3|5902,6790 -41,189 -51,239 -33,133 -103,565
3|4129,9822 17,-98 20,-109 47,-247 66,-344 24,-123 109,-528 30,-156 84,-427 39,-166
3|7720,13854 -37,839 -15,364 -7,146
2|23355,27057 -243,-80 -558,-189 -458,-171 -590,-220 -1158,-420 -99,-37 -2453,-900 -149,-56 -318,-120 -702,-266 -289,-115 -239,-84 -541,-186 -1329,-455 -296,-93 -66,-21 -988,-351 -648,-237 -220,-83 -560,-210 -458,-169 -696,-255 -702,-244 -858,-323 -432,-165 -202,-77 -385,-137 -54,-15 -461,-160 -398,-138 -216,-75 -27,-9 -118,-45 -194,-64 -78,-22 -213,-67 -189,-66 -51,-18 -42,-16 -263,-98 -607,-214 -82,-20
3|10453,14843 -152,1 -48,1 -244,10 -255,115 -143,51 -219,51
3|5006,19013 -245,-61 -450,-168 -269,-86
3|4026,18738 16,-40 2,-46 -13,-42 -26,-30 -33,-12 -33,8 -28,27 -16,40 -2,45 13,42 26,30 33,12 33,-8 28,-26
3|4725,20366 11,-50 228,-1101 42,-202 24,-150 -12,-120 -52,-198 -64,-172 -19,-120 -7,-171 66,-368 35,-230 81,-491 25,-152 26,-224 0,-240 12,-140 7,-92
3|10199,12265 -850,-230 -125,-36 -147,-43 -86,-6 -589,-45 -123,-52 -70,38
3|7718,21393 -27,336 -19,549 27,130 76,160 47,60 84,74 173,49
3|1856,15870 -279,-60 -441,-53 -75,-10 -313,-53
3|4297,12299 -8,56 -166,1113 -96,658 -67,390 -53,304 -93,600 -18,332 1,67 19,345 27,229 9,89
3|8737,21772 224,-1229 95,-522 39,-209 119,-736 79,-486 48,-321 89,-501 5,-28 66,-337 18,-89 6,-32 108,-497 14,-94
2|11058,5121 -55,-14 -18,-4 -133,-28 -77,16 -579,317 -33,26 -224,-34 -231,-48 -20,-4 -435,-32 -28,-2 -135,17 -167,17 -456,-34 -562,-42 -767,-46 -299,-2 -54,31 -19,85 -17,339 -13,242
3|4730,1671 278,46 314,-8 470,83 55,11
3|2705,16241 67,47 54,-27 47,-74 71,-176 67,-144 68,-146 63,-223 60,-351 109,-716 26,-173 -10,-59 -21,-30 -7,-10 -33,-27 -41,-14 -98,-28 -122,-35 -50,3 -31,34 -28,82 -72,442 -36,223 -69,431 -29,169 -60,378 0,101 -1,44 11,122 20,69 45,88
3|10439,10165 -36,-32 -18,-12 -23,-10 -32,-8 -132,-20 -109,-21 -159,-14 -259,31 -148,49 -272,89 -206,68 -215,20 -189,-13 -21,-2 -66,-6 -176,-15 -230,-13 -163,-1 -45,0 -38,-7 -48,-8 -22,-1 -34,-2 -813,-41 -53,-3 -145,0 -237,-15 -313,-21 -37,-2 -77,15 -46,38
3|8305,21607 57,-344 -19,-152 -57,-115 -169,-258 -145,-169
3|7131,18878 -360,-104 -79,-23 -84,9 -64,68 -26,86 -69,550 -140,1007 -59,416
3|7557,16029 -5,73 -88,516 -60,307 -19,115 -21,122 -8,48 -12,75 -23,137 -56,347 -10,66 -88,592 -29,363 -7,88
3|-736,15488 157,30 408,168 435,153 297,114 84,16 42,0 19,-23 42,-252 119,-710 57,-381
2|2510,23325 131,646 5,28 200,1116 55,344 114,706 56,357 193,1262 135,944 135,1142 317,2256 159,1083 197,1502 163,1184 109,944 110,781 28,330 74,898 71,695 103,592 103,446 128,412 257,636 518,1279
3|10993,22594 -23,149 -82,677 -37,424 -12,398 10,222 22,221 123,912 215,1540
3|11056,15672 216,65 96,33 309,86 172,28 150,24 90,39
3|4211,5306 -475,-489 -165,-171 -385,-587 -61,-108 -294,-525 -57,-84 -61,-69 -50,-15 -53,-8 -176,0 -64,-7 -81,0 -225,-46 -64,-31 -61,-38 -50,-46 -50,-68 -18,-35 -54,-103 -23,-76 -19,-84 -4,-114 4,-61 23,-176 7,-145 0,-76
3|2599,14833 -47,-7 -316,-48 -553,-76 -282,-30 -405,-62 -72,-7 -92,-23 -187,-31 -59,-17 -231,-66 -293,-115 -256,-91 -152,-46 -69,15 -54,53 -49,100 -61,274 -65,397 -92,435 -49,99 -115,137 -187,206 -148,138 -27,53 -34,61 -50,214 -43,271 -3,19 -18,134 -5,41 -80,481 -72,488
3|2932,12643 -55,-6 -153,-18 -156,-51 -76,-25 -119,-46 -156,-46 -313,-122 -309,-129 -427,-168 -465,-176 -504,-213 -488,-199 -477,-175 -427,-199 -122,-30 -381,-103 -550,-141 -332,-122 -64,-25 -103,-41 -193,-76 -67,-26 -260,-122 -21,-14 -192,-131 -115,-54 -118,-61 -279,-114 -217,-122 -236,-145 -317,-221 -198,-145 -306,-206 -354,-260 -363,-236 -343,-237 -313,-229 -1255,-900
2|11058,5121 149,-1211 106,-854 31,-236 20,-158
1|7356,17210 50,18 399,164 66,28 102,43 316,144 22,9 86,36
1|7973,17463 -148,674 -215,-90 26,-116 -323,-141 -48,-21
1|8289,17607 -114,746 -49,278 44,54 52,63
1|8868,17000 -97,-30
1|8771,16970 -16,-165 -310,-87 -61,32 -182,-43
1|8755,16805 36,-212 -285,-86
0|8202,16707 -32,222
3|8397,17652 38,-13 43,-5 101,18 53,13 58,-18 45,-68 102,-449 31,-130 33,-169 66,-339 8,-94
3|7348,18938 254,49 189,36 242,46 45,8 41,-3 35,-18 30,-59 38,-249 128,-997 21,-59 26,-40
3|7348,18938 -51,-14 -138,-38 -28,-8
3|9003,15080 2,-137 7,-221 2,-99 3,-125 11,-483 1,-54
0|11836,12595 1,147 43,216 23,109 29,95 2,108 -12,83 -34,93 -60,89 -79,51 8,31
1|10187,12398 138,16 588,36 42,-21
3|10453,14843 -36,-229 -31,-159 -13,-78 -14,-46 -44,-123 -18,-55 -90,-257 -15,-42 -20,-99 -15,-108 -8,-268 4,-182 6,-174 14,-417 2,-36 4,-80 8,-92
1|10179,12490 -248,-3 -498,-9
1|8981,16090 -59,-8 -391,-56 -64,-7 -285,-29 -57,25 -24,11 -18,18 -43,45
3|10187,12398 12,-133
3|12231,23056 32,211 52,421 32,437 6,309
0|7872,14073 181,261 263,366 251,326 316,454
0|9012,14722 -471,-14 -225,-8 -354,2 -171,-5 -62,-4 -46,0
0|8595,15653 12,-194 -40,-433 -26,-318 -54,-791
0|8074,15656 12,-232 -124,-722 -35,-235 -55,-394 -71,-101 -14,-45 -22,-69
0|8942,15483 -59,-3 -180,-16 -96,-5 -521,-35 -388,-23 -50,-4
0|8703,15464 -10,195
0|8568,13921 446,702
0|8439,13911 -386,423 -126,133 -104,121 -32,39 -62,66
0|8563,12532 -19,552 -4,61 -13,300 -3,83
0|9071,12437 -527,647
0|9124,13133 -60,-8 -520,-41 -541,-71 -13,-3 -188,-25
0|7759,12374 348,21 115,136 25,27 77,86 220,440 169,377 161,362 65,130
0|9180,13804 -129,-19 3,-130 10,-530 -11,-131 18,-428 0,-129
0|9051,13785 -22,176
0|7765,13858 5,-109 29,-694 3,-70 -53,-112
0|6390,13011 55,9 124,27 210,12 204,14 172,7 128,5 162,9 214,12 -18,369 -1,56 -13,339 -16,241 -6,266 -10,316 -9,260 0,25 -16,411 -16,335 -3,208
0|7627,13870 -235,-15 -274,-20 -168,-17
0|7392,13855 9,-224
0|6988,12956 -5,117 -33,745 -6,148 0,213 47,212 46,284
0|7083,15345 227,15 50,3 210,26
0|7570,15389 78,8
0|7019,15939 -121,6 -258,13 -51,3 -495,25
0|7291,12969 -8,116 -8,300
0|7118,13835 14,-227
0|7749,12873 -247,3 -28,0 -306,0 -255,-7 -139,-12 -204,-16 1,-28 10,-171 56,34 137,181
0|7759,12374 -237,103 -17,0
0|7248,12729 -18,-123 -131,-152 347,20
1|4942,17714 40,11 406,118
1|7385,17040 -297,-76 -489,-126 -53,-5
1|6128,16770 85,-146 75,-30 205,39 71,93 -18,107 -418,-63 -31,-3 -157,-5 -167,48 -88,38 -82,55 -45,381 -92,597
2|1939,19402 123,50 269,110 431,153 391,128 517,169 580,206 475,148
3|10615,8515 -6,44 -138,1058 -4,37 -18,201 -14,153 -1,35 -1,25 3,62 3,35 1,16 9,48 3,27 0,33 -10,160 -10,106 -9,57 -28,174 -19,110 -20,105 -35,156 -11,51 -18,96 -12,97 -16,165 -6,130 -40,369
3|11333,20328 -74,-9 -73,-9
1|4977,17484 44,13 327,96
0|10982,19019 -6,-195 53,-601 108,-655
0|7404,16925 -32,-10 -253,-72 -202,-57 -193,-52 -141,-34
0|7119,16843 28,-159 54,-132
0|6917,16786 -6,-283
0|9132,15968 -115,-87 -5,154
0|11757,13617 402,43 20,-273
0|9391,15261 5,81 -15,299 -13,490
3|5847,1803 51,12 91,31 113,193 50,77 46,-13 49,-99
1|4943,2197 37,72 12,92 -54,310 -30,39 -59,7 -59,-64 18,-142 32,-204 37,-71 66,-39 65,-480
0|9246,6570 -48,29 -384,-28 -189,-14 -645,-39 -328,-23 -224,-13 -452,-32 -97,-5 -91,-11
0|6767,6999 4,-101 17,-464 7,-126
0|7980,6518 7,-151
0|7652,6495 -213,-253 23,2 367,23
0|7439,6242 -11,240
0|9024,7630 27,-42 49,-12 31,-7 55,-19
0|7980,6518 -12,458 176,12 481,-431 -14,405
0|8625,6557 274,251 68,61
0|8625,6557 5,-113 4,-130
0|6372,9018 35,-24 27,-228 36,-235 25,-366 44,-625 4,-320 58,-167
0|7749,12873 6,-299 4,-200 13,-316 4,-84
3|7661,15203 -13,194 -19,546 -6,87
0|7776,11974 6,-179
0|7801,11305 7,-137
0|7782,11795 3,-99 12,-298 4,-93
0|7797,11398 -65,-91 -1,-129 80,-77
0|7772,12058 -34,-33 -46,-43 -8,-112 20,-84 6,-7 75,-83
0|7808,11168 3,-67 66,-83 9,-340 6,-121 -61,-100 -2,-152
0|7886,10678 -232,-10 -124,28 -119,92 -145,99 -103,51 -143,10 -69,16 -16,-6 -75,-29 -144,-55 -53,-61 -94,-122 -21,-50 -20,-44 -250,-375 -41,-65
0|8295,11175 61,58 63,33 198,25 130,13 99,52 67,57 111,62 79,25 76,8 57,-2 63,-16 93,-36 100,-63 90,-125 58,-25 107,-58 162,3
0|8302,11688 23,48
0|8231,11658 -13,50
0|8275,11559 -44,99
0|7505,12477 -26,-1
0|8419,11266 -123,134
0|8276,11622 26,66
0|7522,12477 77,-152 93,-343
0|8369,11026 -74,149
0|8218,11708 -10,60 -30,75
0|8993,11009 -97,25 -70,18 -95,12
0|8368,10636 -82,49 -89,78 -58,44 -195,133 -67,78
0|9492,11391 -110,336 -134,68 -70,22 -44,-10 -30,-14 -35,-18 -36,-23 -41,-41 -36,-48 -26,-55 -17,-195 -85,-191 -35,-96 -62,-62 -110,-26 -252,-12 -61,-42 -24,-43 -3,-32 -4,-52 11,-82 31,-64 49,-75 143,3 128,-3 12,-77 71,-76 75,-55 12,-9 21,-47 0,-67 8,-69 -6,-74 -26,-82 -61,-92 -29,-81 4,-144 29,-75 40,-35 31,28 117,29 213,36 52,94 2,128 38,202 9,47 27,91 7,24 42,186 15,167 83,381 18,92 49,233
0|7479,12476 -33,-2 -53,50 -145,205 -80,147
0|7892,10557 141,106 106,144 18,16 58,108 23,44 57,200 1,225 -21,159 1,63
1|6111,11948 -22,43 64,316
2|23753,12572 -63,-108 -99,-135 -84,-206 -54,-351 -91,-717 -54,-282 -64,-260 -37,-88 -74,-164 -184,-292 -258,-414 -168,-282 -105,-153 -68,-83 -184,-149 -80,-47 -227,-136 -195,-145 -441,-197 -1767,-985 -275,-115 -115,-30 -118,-38 -42,-8 -343,-99 -134,-46 -866,-215 -1748,-456 -791,-207 -1278,-324
3|5981,11564 -52,102 -147,235 -66,106 -41,72 -45,135 -19,117 -33,207 -15,96 -14,87
1|6153,12307 -8,369 -76,128
3|6002,12800 86,146
0|6074,11849 -69,-208
3|5981,11564 -395,-189 -75,-11 -28,-4 -183,-9 -76,-3 -168,-9 -117,-19 -47,-25 -48,-42 -45,-83 -38,-117 8,-114 14,-87 16,-33 32,-64 58,-106 48,-75 13,-28 37,-78 56,-84 44,-106 39,-124
3|5126,10154 -128,-37 -630,-211 -162,-57 -77,-27 -87,-30 -53,-19 -173,-61 -291,-110
2|5883,-14369 -25,145 -14,85 -27,160 -70,424 -29,177 -130,807 -179,1040 -37,227 -71,399 -77,434 -68,241 -24,86 -66,207 -118,305 -88,156 -228,421 -496,960 -133,308 -73,179 -83,256 -65,262 -31,211 -26,187 -29,376 -5,279 1,151 -7,473 8,229 8,162 8,104 47,280 64,319 93,338 135,333 57,146 160,367 58,122 103,251 89,241 77,283 69,323 33,206 45,407 36,911 8,178 17,453 -9,594 -9,122 -52,715 -186,1278 -187,1338 -146,1019 -14,176
2|2349,16450 -10,68 -64,487 -15,108 -77,478 -26,161 -43,270 -60,370 -65,404 -16,140 -4,16 -30,450 -12,190 4,306 15,244 30,222 58,434 53,328
2|3018,12014 -86,629 -83,646 -43,265 -15,90 -27,164 -118,721 -47,304 -121,783 -80,514 -25,159 -15,100 -9,61
3|6163,12756 -37,51
3|6126,12807 -21,41 -10,35 -2,23 -5,40
3|6088,12946 28,59 19,41 26,34 31,25 35,14 36,3 36,-9 33,-20 29,-30 29,-52 9,-30 7,-47 -2,-49 -10,-48 -19,-43 -26,-35 -15,-12
2|5167,16137 -39,8 -93,22 -388,110 -295,84 -339,91 -161,30 -224,5 -120,6 -107,5 -413,19 -20,1 -141,0 -103,0 -220,-38 -56,-11 -99,-19
3|5549,12721 -15,92 -42,272 -21,136 -138,898 -3,16 -17,111 -12,74 -76,495 -48,309 -16,103 -23,283 9,378 10,163 10,86
2|11771,362 -200,-239 -27,-31 -34,-46 -81,-84 -152,-154 -113,-116 -931,-890 -818,-793 -1017,-1039 -417,-426 -366,-428 -2140,-2509 -492,-633 -847,-1069
3|7881,9398 -29,0 -1378,-49 -124,-25 22,-306 -118,-21 -36,-7 -165,-140 -156,-21 -209,32 -157,-64 -50,-21
3|5481,8776 -158,644 -11,34 -64,223 -45,193 -31,144 -24,74 -2,9 -20,57
3|7928,7756 2,-58 5,-115 15,-446
3|7879,9588 194,-59 145,0 141,54 164,45 145,16 121,9 92,-131 53,-79 74,-67 24,-36 73,-108 48,-46 11,-8 63,-18 17,-5 187,8 81,6 206,14 83,-20 136,-34 13,-67 2,-231 1,-54 82,-218 246,-73
0|7499,12033 8,-263 12,-226 61,-24 217,-122
0|6183,11360 88,15 207,2 55,39 126,39 44,-7 80,6 118,15 356,31 150,17
0|6935,10958 -15,128 -84,268 -53,100
0|6951,10964 94,73 64,89 123,186 175,205
0|5557,10729 103,88 312,321
0|6068,11123 131,-56 104,-62 89,-69 130,-47 78,-6 116,-9
0|6557,10513 -9,128 -2,63 -24,185 -3,143
0|5993,14076 1,-61 41,-619 15,-394 -8,-67 -183,-39 -127,-24 -145,-39
0|5863,12838 -4,58 -7,129
0|6222,12318 33,93 39,67 35,33 69,-25
0|6324,12663 1,-61 5,-89 -1,-2
0|6296,12666 28,-3 68,37 40,53 103,-106 -50,-28 -160,-17
0|6999,12649 -44,-2 -272,-16 -102,11 -46,5
0|6913,12869 42,-142 0,-80
0|6094,15986 11,-204 20,-373 88,-75 49,-33 38,-26 247,3 92,13 48,27 396,27
0|6639,15660 0,-369 -8,-88 -28,-86 -76,-91 -73,-116 -38,-120 -14,-46 -98,215 -107,171 -56,151 -12,97 -4,31
0|6838,15106 -7,12 -144,200
0|7310,14584 -41,8 -24,30 -16,52 -103,-6 -89,7 -18,72 -42,110 -93,166 -53,95 -95,23 -77,-8 -56,-16
0|6752,14768 132,255 199,322
1|7023,15664 -4,275 446,-6 86,-1
0|6402,14744 1,-126 29,-182 56,-129 47,-67 18,-12 54,-36 66,-19 89,-8 167,109 62,117
0|6944,13966 -86,78 -96,121
0|6659,14337 14,-164
0|6619,14031 -62,35 -563,-51 -181,-21 -404,-31
0|5322,14538 217,16 864,64
0|6607,14192 -18,-61 -32,-65
0|6754,13810 196,8
0|6740,14546 189,-272
0|7360,15363 -46,-47 -65,-78 -81,-153 -25,-71 -20,-85 3,-261 40,-136 62,-166 121,-123 48,-49 189,-238 41,-86
0|8544,13084 368,402 142,169
0|9054,13655 -78,80 -102,88
0|9394,14547 -66,-39 -238,-9 -73,-1
0|9334,12625 -65,84 -216,285
0|9062,12011 -14,117 -2,214 25,95
0|9344,12931 -1,-32 -9,-274 -3,-80 -5,-172 23,-338 4,-52 25,-141 4,-115 251,18 99,-1 90,-22 79,-36 55,-14 55,-4 135,16 46,3 66,9
0|9582,11266 -70,-76 -69,-32
0|9640,11241 67,22 47,15 63,15 146,26 127,110 31,52 30,61 -5,142
3|3675,6255 -10,-111 -51,-570 -843,-804 -450,126
3|11451,22763 34,-282 3,-269 32,-183 100,-144 109,-92 176,-1 148,11 93,-41 87,-110 31,-167 -8,-198 -5,-115
3|4725,20366 -20,210 -40,306 -9,127 -10,262 3,52 0,49 0,20 -4,89 -25,119 -14,95 -14,101 -4,32 1,62
3|3741,7840 -397,-127 -729,-5 -217,-12 -127,58 -100,120 -80,149 -42,177 6,209 111,229 127,86
0|11612,14008 -161,1124 -68,31 -34,226 -48,138 -29,210 -33,290 -12,502 -3,446 -5,312 -42,141
0|14682,16074 4,-651 218,-413 71,-938 -315,-709 -223,-1064 176,-361 411,-213 832,355 257,144 739,14
1|11634,4192 -145,-20 -27,25 -42,385 13,50 140,64 173,38 177,54 671,170 976,279 37,-39 29,-195 37,-241 33,-220 21,-330 -9,-349 -124,-488 -44,-103
3|13927,4606 -221,-64 -312,-79 -160,-40 -168,-43 -168,-42 -211,-54 -150,-37 -161,-41 -165,-42 -201,-51 -176,-44 -179,-46 -384,-97 -64,-16
2|2087,21126 18,95 183,963 55,299 33,177 134,665
2|4197,5482 -72,501 -57,286 -13,72 -314,1499 -124,601 -120,684 -51,309
0|7928,7756 -16,137 -39,75 -37,91
2|11058,5121 107,28 434,115 668,176 195,52 117,30 240,64 546,143 184,52 122,35 75,24
2|11771,362 73,93 316,363 257,294 292,360 215,255 156,171 215,278 206,333 125,264 124,310 75,279 66,337 36,372 6,312 -6,223 -181,1234
3|6126,12807 -57,-3 -67,-4
0|8616,11313 1,-22 4,-253 4,-39
0|8511,10639 -5,-42 10,-44 66,-48 57,131
0|8047,10334 103,12 329,15
0|8479,10361 72,11 61,10 8,-92 -8,-65
0|8612,10382 -30,123
0|8047,10334 -56,-3 -49,-2
0|7942,10329 -44,-9 -69,-15 -35,-2 -811,-43 -423,-23
0|8178,11843 65,-78 82,-29 228,-69 48,3 1,-31
0|8601,11670 214,96 61,-63 33,-80 21,-15
0|8843,11616 66,7
0|8843,11616 5,-75
0|8815,11766 -2,45 362,30 3,-24
0|8813,11811 -223,-15 -245,-5 -20,-55
0|8601,11670 -11,126
3|6002,12800 -132,-22 -254,-46 -67,-11
3|10358,17021 21,-98 65,-548 16,-134 18,-443
3|6334,12747 -25,-18 -27,-10 -36,-4 -39,11 -44,30
1|11838,10918 -42,79 -41,76 -78,107 -22,30 -57,133 -132,115 -93,27
0|12158,12078 -54,-69 -69,-62 -68,-122 -58,-93 -13,-22 -151,-179 -70,-84 -33,-39 -7,-11 -37,-54
0|11846,12432 62,109 84,106 95,74 78,128 22,122 6,213 -7,100 -7,103
0|12773,12146 -57,-6 -185,-21 -373,-41 -58,-4 -49,12 -72,43 -52,56 -19,48 -35,89 -27,110 -10,163
3|13568,3172 182,-89
1|5726,3087 583,164 138,38 28,-223 32,-251 -131,-33 -640,-159
3|10486,15261 -8,537
1|5333,14119 50,7 201,25 738,48
1|5492,13085 53,13 71,17 47,18 16,27 -6,185 -3,81
3|13465,7796 -68,-18 -156,-36 -156,-44 -176,-52 -182,-44 -148,-40 -110,662 159,40 179,48 170,48 167,51 97,-669
1|10264,11566 136,-1 465,38
1|5981,11564 60,18 130,25 136,22 257,28 150,31 65,40 10,16 22,102 6,45 -203,-8 -128,-4 -293,-11 -31,2 -41,62 -10,16
1|6779,11728 244,18
3|5677,20698 9,-50 59,-362 48,-329 -19,-251
1|6577,18217 -239,-66 19,-160 27,-64 46,-60 44,-42 162,64
1|6723,17385 34,-245 -420,-96 -30,253 416,88
1|9341,18269 47,66 222,89 153,33 33,-32
3|12924,1727 -82,75 -58,143 -34,280 -91,714
1|12750,2225 -123,-23 -175,-49 -188,-37 -172,-40 -190,-46 -175,-35 121,-926 51,-56 62,-12 37,15 31,29 166,194 160,176 166,206 149,192 -43,389 -95,710 -156,1294
1|11727,1995 -83,725
3|1810,24505 -27,-155 8,-73 16,-45 42,-36 126,-27 370,-105 296,-93
3|11754,-282 226,34 422,82 179,53 165,49 40,7 581,111 49,8 70,12
1|5177,15124 50,2 199,6 54,1 149,-2 79,-87
1|6263,13122 30,91 -3,150 -5,206 14,18 61,4
1|6805,21080 38,-104 106,-737 110,-738 62,-470 5,-9
1|6097,16767 -122,859 -185,201 -165,72 -59,9 -100,-27 -47,-23 -31,-15
1|5940,16762 -150,1065
1|5773,16810 -148,1089
3|1522,17560 66,-408 27,-400
3|2260,17113 -117,-29 -235,-57 -43,12 -60,32 -30,82
1|11849,15884 -1,53 -15,675 -14,390 39,154 58,37 63,-37 106,-1159 4,-50
1|11007,12350 9,-103 6,-126 7,-134 13,-37 5,-15 60,-27 285,29 -9,214 -14,217 -362,-18 -52,79
3|10163,5434 44,103 26,61 60,130 24,75 40,124 42,129 63,198 67,211 62,196 59,169 39,76 56,28 29,7 46,14
1|10233,5598 604,-338 29,-4 30,16 18,43 -22,163 -21,155 -21,159 -35,262 -38,279 -28,214 -16,27 -142,87
1|4412,8373 -75,-29 -355,-124 -86,-24 -50,64 -42,141 -68,370
1|3580,9967 36,62 55,55 207,66 28,-32 36,-122 47,-223
1|2849,13289 147,28 152,29 43,17 36,35 21,63 1,70 -19,71 -33,35 -40,24 -49,21 -37,-6 -39,-30 -46,-27 -25,-6 -4,1 -19,5 -43,14 -38,7 -66,4
3|2275,17005 -115,-32 -176,-46 -45,-28 -45,-56 -49,-64 -16,-32 -12,-42 83,-459 26,-41 31,-16 37,5 263,66 17,5 99,24
3|1926,16205 6,-56 -6,-54 1,-25 13,-37 27,-20 41,7 271,78 -22,162
1|1697,21249 -5,157 -15,161 -8,173 8,141 21,130 38,123 50,114 28,56 29,36 36,5 34,-4 95,-37 200,-87 80,-33
1|6276,5817 -69,188 -66,178 -6,22 -55,198 -55,196 -210,-122 -199,-199 -244,-247 -300,-380 -278,-319 -51,-123 -19,-76 11,-104 24,-224 28,-260 20,-188
1|5624,5160 -89,135 279,352 219,237 174,121 239,81 127,18 -10,223 -9,195 -10,209 -138,0 -381,-132
1|4787,4545 242,145 222,257 284,348
1|9095,19812 194,42 13,-70 180,-1167 -189,-27
1|9482,18617 157,39 144,35 154,42 -160,1054 -158,-36 -28,177 -146,-40 -156,-34
1|4950,10546 -239,-83 -66,289 154,67
1|4782,956 306,21 47,-54 26,-479 35,-341 3,-49 8,-182 -23,-86 -55,-77 -156,-92 -198,-8
1|4565,7624 -36,-59 -8,-5 -443,-289
1|4722,12429 -19,96 -6,20 -47,251 -13,63 -8,73 2,25 11,37 18,24 29,20 31,16 215,49 536,118
1|10756,15417 7,-40 19,-110 14,-415
3|2183,17591 89,24 235,60 92,78 299,145
1|10009,14855 -19,-16 -134,-124 -104,-97 -66,-60 -292,-11
1|6276,5817 39,-115 -172,-77 -174,-193 -209,-285 -85,-93 -69,-100 21,-135 18,-177 57,18 373,117 512,160 26,9 -14,93 -17,117 -20,215 -17,216 -8,147 -222,-32
1|5675,5054 -51,106
1|3153,19843 -44,176 -69,269 -17,66 -31,23 -138,-51 -8,-65 54,-300 42,-18 167,76
3|1906,6077 -45,-99 -39,-87 -18,-7 -20,2 -32,20 -122,109
3|10820,6955 69,13 107,21 152,30 167,33 155,30 17,4 154,30 167,33 57,11 111,22 83,17
1|12462,5492 -205,1351
1|6949,20239 299,81 73,29 44,12 22,-34 15,-71 26,-138 36,-75 46,-244 44,-216 155,32 155,32 162,34 60,-490 -162,-32 -148,-30 -186,-28 -162,-30 -145,-27 -145,-27 -12,5
1|7554,19583 -1,-48 -10,-45 47,-389 7,-62 5,-52
1|11179,10770 74,-231 32,-33 33,-16 46,-3 431,161 31,37 16,45 14,72 2,74 -1,47
1|12267,5440 -79,523 -22,143 -60,399 -381,-103 60,-399 381,103
1|13674,6377 194,52 183,51 228,63 165,45 150,42 -328,2271 -164,-40 -158,-38 -234,-58 -158,-39 -157,-38 -38,-9 -23,-6
1|4570,5319 -81,110 8,37 23,33 416,511 463,572 25,18 27,0 46,-23 22,-63
3|10281,8486 292,25 42,4
3|7874,8439 20,32 10,38 5,41 -10,296 -2,88 -9,260 -7,204 -1,121 -1,69
3|7879,9588 -7,180 -16,415 -2,57
1|12059,7199 50,-386 148,30 151,30 230,47 19,-143 48,-351 7,-189 23,-157 84,-494
1|11599,5264 -170,917 -36,31 -31,17 -57,-15 -76,-19
3|13568,3172 -57,-18 -115,-30 -172,-41 -166,-43 -197,-48 -164,-39 -38,-14 -127,-27 -160,-34 -203,-48 -169,-35 -188,-36 -168,-39 -280,-58
3|5481,8776 49,-222 130,-574 14,-64
3|5674,7916 -443,-158 -151,-40 -126,-18 -285,-41 -104,-35
3|6247,2004 23,-266 -60,-56 -189,-83 -56,-11 -59,50 -59,165
1|5847,1803 -13,121 -98,699 -28,233 -16,141 34,90
0|6214,16155 2,131 1,25 172,-5 176,-5 26,-161
0|6052,16154 162,1 377,-15 311,-15 510,-25 52,6 21,50 11,27 -6,81 -118,651
0|7485,16156 -79,115
0|7269,18850 -67,-22 -32,-37 6,-87 137,-914 93,-562 69,-396 120,-690 9,-39 39,-6 31,-5 364,56 217,71 30,9 606,211 15,9 13,39 -1,37 -13,75
0|6389,16306 0,120 -21,46 -6,96
0|6902,16125 4,154
1|5058,16993 36,16 295,105
1|5625,17899 -64,107 -32,42 -142,189
1|5529,18048 -363,-80
0|4965,17834 -46,307 -6,151 40,128 47,114 24,57 44,168
0|4997,17634 -15,91 -17,109
0|5428,17807 -9,51 -10,52
0|5263,16186 -1,-69 -3,-80
0|5110,16069 -18,3 -63,17 -688,185 -355,95 -70,25 -14,-12 -15,-13 -10,-76
0|3788,16403 -141,7 -142,7 -105,5 -145,8 -250,13 -40,2 -78,4 -77,-2 -50,-1 -36,-1 -244,-19 -30,-33 -18,-19 -10,-55
1|2988,16517 17,-74 31,-136 91,-398 56,-87 169,-32 48,51 -3,415 0,20 1,51 2,95 1,76
0|3788,16403 55,-10 59,-11
0|4736,20316 -286,-96 -783,-273 -931,-318 -590,-200 -45,-55 -13,-29 -31,-113 31,-405 10,-206 77,-514 43,-159 54,-333 139,-824 36,-211 26,-9 230,35 14,-1 41,-1 754,-32 129,-5
0|6094,15986 -42,2 -793,49 -54,-3 -6,-75 -14,-315 8,-177 34,-341 95,-588 40,-275 21,-137 26,-163 43,-272 93,-593 42,-265 23,-39
0|6052,15988 0,101 0,65
0|6589,15961 1,104 1,75
0|7674,16092 5,-60 7,-82 -57,-7 -78,-11
0|7882,13957 -66,6 -8,5 -7,4 -16,9 -25,47 -31,665 -31,708 -11,295 0,53 -1,201 21,20 204,26 172,48 61,17 136,45 211,69 389,130 29,-21 12,-67 1,-135
0|8540,13145 -173,211 -3,74 -19,475
0|7990,13010 85,-272 35,-174 -3,-169 -46,-37 -146,-157 -143,-143
0|8247,12558 -137,6
0|8107,12015 212,19 111,6 86,4 144,8 202,10 76,57 48,4 62,5
0|9269,12709 -198,-143
1|7968,11453 33,202 90,99 20,22 52,94 46,21
0|8209,11891 -53,53 -49,71 -16,10 -80,42 -96,134 -156,173
0|8091,12025 20,118 0,31 -2,98 -2,123
0|8660,12052 -6,179
0|8516,12044 -6,164 0,14
0|8646,12397 -2,50 -10,48 -31,37 -40,0 -39,-11 -23,-45 3,-88
0|9175,11841 15,92 163,50 246,76 525,149 17,-21 8,-19 11,-46 16,-118 16,-317 35,-447 21,-64 31,-93 60,-304 21,-179 7,-63 -5,-316 -13,-13 -14,-15 -248,-39 -147,-24 -97,13 -127,18 -170,45 -50,13 -218,89 -74,30 -221,42 -153,-8 -167,-8 -51,18
0|8284,10941 -46,34
0|8255,16219 -9,40 -26,132 -22,117
0|8280,16106 -14,58 -11,55
0|9022,16336 -46,-21 -67,-31 -1,87 -2,77 61,44 57,26
0|8952,16875 3,-21 45,-258 24,-78 46,-8 186,87 304,147 7,13 16,35 -104,534
0|9482,18617 -90,-240 -4,-42 0,-77 68,-403 17,-28 24,-15 42,2 36,-5 33,-22 28,-42 31,-127 27,-126 3,-57 -18,-56 -25,-44 -38,-28 -30,-33 0,-47 82,-363 29,-51 78,-2 318,129 187,97 20,10 98,71 18,13 216,156 239,153 266,128 30,12 774,319 14,27 9,18 -6,51
0|12018,17767 -31,79 -32,80
0|12018,17767 -15,-4 -826,-335 -87,-35 -280,-134 -349,-271 -8,-8 5,-57 22,-126 18,-384 1,-35 37,-930 3,-45 11,-29 27,-7 28,13
0|11177,17428 -20,70 -20,70
0|10323,16879 56,44 74,57
0|10301,14844 31,68 53,41 25,43 18,69 5,119 7,158 -17,514 -11,308 -30,28 -2,51 -6,143 -3,83 -13,308 -17,71 -18,31 -52,14 -92,-50 -145,-80 -23,-8 -100,-34 -10,-3 -182,-62 -22,-8 -70,-23 -111,-49 -77,-34 -155,-79 -191,-86 -71,-41
0|9719,16656 21,-139 4,-53 9,-108 4,-56 14,-149 -69,-282 -47,-205 -58,-245
0|9719,16656 -11,59 -11,98 -64,-28 -66,-28
0|9284,16463 -16,69 -12,65
0|9256,16597 -58,334 -243,-77
0|8867,16818 34,13 54,23
0|9791,17672 -124,-54
0|9132,15968 67,46 169,117 98,-6 11,1 74,6 220,19 232,15 379,26
0|9368,16131 -109,97 -166,149
0|9284,16463 84,-332
0|9237,15118 -145,-3 -29,28 -16,51 -16,430 -14,257
0|8815,15996 9,-160 4,-91 -38,-57 -64,-25 -33,-4 -98,-6 -108,-2 -20,368
0|8746,15991 69,5 109,9 0,-4 6,-167 12,-351
0|8824,15836 106,-2
0|9028,14015 60,69 78,106 49,6 -5,95 -27,2 -93,206
0|9744,13857 -3,61 -3,55 -10,185 -1,19 -5,93
0|9738,13973 77,100 109,135 157,203 76,119 95,185 49,129
0|9990,14839 95,-138 42,-83 30,-88 19,-128 7,-170 89,-62
0|10207,13896 56,-50 668,-273 55,-88 62,-81 32,-42
0|10909,14161 2,-68 7,-144 13,-376 -65,-73 -69,-117 -90,-163
0|10779,13215 -72,5 -32,2 -455,-20 -67,-5
0|10207,13896 4,-157 -8,-146 17,-391 6,-176 10,-273 6,-140 30,2 421,30 281,29 130,2 95,-8 32,26 237,11 88,3
0|11210,13060 -451,-146 -77,-14 -365,-120 -81,-27 -63,-147 -842,-61
0|10279,12219 82,34 553,43 29,31
0|10279,12219 -73,-28 -57,-23
0|10943,12327 12,102 12,42 5,17 8,31
0|11468,12705 10,-308 1,-30 37,-786 43,-54
0|11200,13297 10,-237 21,-366
0|10697,12480 -4,165 -11,255 -2,241 -5,81
0|10974,12674 -81,61 -63,63 -71,116 -27,52 -32,105 -20,70
0|10980,12519 45,52 30,36 49,69
0|11199,12668 27,-18 44,-29 89,-72 119,-152
0|11231,12694 30,65 30,33 107,118 25,34 52,10 82,-33 127,45 -14,378 -26,187 -6,34 -41,264 15,179
0|11880,12958 -25,186 -110,129 -75,71
0|11992,12647 -71,43 -59,38 -25,14 -29,-4 -29,-8
0|10471,10611 21,-147 37,-50 70,-19 53,36 144,131 104,88 109,94 145,74 303,97 194,47 119,29 26,6 72,14 96,20 270,55 129,27 18,7 40,71 397,163 -16,97 -60,454 -26,235 -19,201 -11,117 -52,548 31,73 5,91
0|12599,13331 -33,382 -10,52 -19,32 -19,30 -24,328 -72,798 -21,418 -31,319 -25,189 -12,75 -14,91 -32,107 -32,135 -4,286 -28,189 -52,195 -16,136 -41,211 -19,189 -92,270
0|12670,13170 -71,161
1|10321,11157 -73,19 -46,11 -242,-22
1|10432,10555 -65,-18 -29,-10 -253,-13
0|10493,10049 -59,-6 -62,-5 -10,73 -13,97
0|10091,10003 -2,59 -2,92
0|10500,9864 346,-63 222,-46 220,-7 33,3 155,18 334,159 57,46 168,135 151,35 162,18 59,-26 23,-10 161,-209
0|12842,9852 -15,60 -30,49 -40,32 -47,12 -46,-10 -42,-30 -31,-48 -16,-52 -3,-57 10,-56 23,-48 33,-37 39,-21 43,-4 41,14 37,30 27,44 17,59 0,63
0|13158,9398 -102,130 -112,78 -183,50
0|11897,10863 153,40 311,83 265,78 162,75 21,10 82,-17 24,-89 41,-276 108,-730 17,-118 77,-521 64,-435 5,-36 25,-165 9,-60 13,-62 11,-74 112,-788 27,-183 183,-1241 59,-397 -11,-68
0|12793,7553 109,-102 522,144
0|13424,7595 67,20 49,16
0|13252,8762 65,14 59,12 19,-100 11,-97 -57,-15 -64,-10
0|13791,6827 -121,787 -44,56 -47,10 -39,-49
0|13579,7680 -59,471 24,59 26,72 -10,119 -30,133 -46,49 -78,8 10,-64 58,-359 19,-21 27,4
1|13868,6429 -316,2297
1|14051,6480 -341,2285
1|14279,6543 -335,2280
1|14444,6588 -342,2273
0|12477,5060 -1137,-311 -69,42 -85,286 -21,72 -40,174 -14,89 -40,69 -70,66 -45,30 -85,56 -514,294 -40,23 -95,54 -20,12
0|13595,5283 57,10 35,30 58,124 -40,257 -17,30 -54,0
0|13688,5734 -17,82 -16,73
0|12075,9652 -77,-18 -65,28 -109,46 -59,51 -94,38 -136,-23 -59,-5
0|11867,9974 -50,-156 7,-110 109,-46 -61,-260 65,-65 392,94 10,33
0|13064,10037 -267,-76 -38,279
0|12572,9808 -208,-75
0|12407,10136 32,133 21,189 -52,166 -36,53 -48,54 -93,59 -84,4 -129,-74 -62,-52 30,-98 23,-93
0|12050,10903 97,-109 84,-4 93,25 122,49 130,8 80,32 14,13 63,57 44,98 11,67
0|12360,10600 12,77 25,99 49,88
0|10539,9464 -25,240 -2,20 -12,140 -7,185 1,71 81,93 386,343 32,-9 225,-136 69,24 297,104 154,53 218,76 -22,108
0|11287,10435 198,-63 83,-7 49,21 -2,-66 5,-28
0|11738,10592 -14,-110 -5,-45 -35,-51 -67,0 -33,153
0|11321,9751 -23,289
0|10961,10556 -29,44 -32,50
0|10500,9864 -51,-9 -46,-9
0|11897,10863 -13,66 -16,82
0|12891,11132 -12,112 -10,102
1|11186,20310 -45,-21 -130,-62 -154,-74 -158,-75 -145,-74 -149,-45 -128,-26 -188,-61 -68,-18 -80,-22 -164,-45
1|9987,20520 129,33 69,1 130,-1 143,41 149,90 152,77 151,85 67,34 41,-6 25,-35 98,-550 196,-979 2,-118 -37,-89 -98,-70 -160,-30 -62,16 -141,133 -145,-33 -142,-50 -125,-82 -76,-76 -99,-84 -165,1045 -102,648
1|10841,19152 -142,926 -92,606
1|10696,19119 -142,885 -96,590
1|10554,19069 -149,890 -90,594
1|10429,18987 -152,946 -92,621
1|9777,19787 -102,659 167,37 99,-651 165,-1059 -41,-10 -128,-30
1|9783,18691 -164,1060
1|9639,18656 -194,1232
1|11044,19003 -187,1150 -98,608
1|11204,19033 -193,1194 -101,619
0|10520,15164 4,28 10,62 16,120
0|7966,15930 -75,-2 -52,-32 -6,-90 2,-42 38,-3 -186,-12
0|9534,13818 -76,-94 -36,-96 -46,-121 -57,-102
0|9422,13628 -10,99 -40,85
0|7981,13508 -10,311 -134,-9 -44,-19 -23,-42
0|8003,13013 -11,321 -141,-204 -52,-75
0|7755,12574 -100,-28 -75,21 -18,42 -2,40
0|6783,11454 -50,126 -19,108 -31,77 -69,118 -44,-180 -6,-46 -4,-33 -11,-55 -52,-122 -19,-70
0|6368,12127 126,-46 19,-7 115,-39 22,-7 -11,-44
0|6650,12028 34,118 -166,-8 -30,-3 -120,-8 -51,103
0|5984,10816 50,-20 46,-19
0|6067,11532 -27,-51 18,-172 8,-81 2,-105 12,-346 8,-195 22,-280 51,-4 47,-42 27,-35 43,1 100,3 182,12
0|5972,11138 6,-161 4,-136 2,-25 43,-573 3,-29 -7,-94 24,-60 62,-26 29,-5 37,-7 33,32 18,17 19,31 242,18 15,-35 33,0 62,0 29,33 246,18 115,8 220,16 35,-33 31,3 186,14 33,28 222,16 69,5 19,-20 16,-15 31,-677
0|7905,10193 241,9 76,2 390,21 155,7 71,4 103,1 176,-23 125,-44 187,-66 74,-43 24,-13 73,-47 177,-37 49,51 9,-1 194,-20 62,9 119,8 35,11 74,24 53,-8 21,-124 10,-68 12,-91 32,-249 112,-882 0,-49
0|10660,8544 -51,15 -50,16
0|10539,9464 92,-701 29,-219 29,-139 37,-205 15,-119 48,-373 11,-83 77,-566
0|10784,6844 -10,97 -9,83 44,14 68,21 12,-91 11,-72
0|10654,6678 45,151 35,36 50,-21 27,-92 145,-1175 42,-345 -8,-23 -7,-21 -95,-40 -129,5 -476,275 -23,54 9,47
0|10543,6636 48,25 63,17
0|10765,7024 -34,-18 -65,-34 -54,-94 -69,-242 -9,-27 -32,-99 -135,-80 -44,-130 -101,-296 -100,-295 49,-142 -48,-52 -31,-22 -5,-4 -38,-20 -163,-22 -180,-7 -151,-9
0|9709,5314 -1,38 -2,88
0|10260,5482 -53,55 -36,30
0|11071,5481 -80,655 -91,760
0|10697,7654 31,22 31,22
0|10393,9914 -57,64 -91,44
0|10415,9755 -91,-128 -62,-42 -73,-49 -131,-72 -74,-132 -54,-95 -129,-74 -66,-63 -42,-173 -88,-350 -124,7
0|9396,8589 -34,2 -43,8
0|9481,8584 -85,5
0|9952,8831 64,122 98,53 39,38 5,175 -44,142 -78,12 -52,-41 -94,118 -36,53 -31,70 -1,48 0,52 16,61 13,148 -16,132
0|10447,9506 -69,54 -116,25
0|8716,9907 -26,110 -64,82 -14,126
0|8146,10202 2,54 2,90
0|7970,10071 28,65 152,14 -4,52
0|7905,10193 -49,-10 -54,-10
0|7905,10193 -3,55 -4,72
0|7802,10173 -4,64 -4,66
0|9546,10206 97,396 13,97 3,29 -10,162 -16,147 -5,44 -46,185
0|9633,11037 74,3 1,-83
0|10085,10514 -46,-7 -4,119 -5,172
0|9843,10143 -44,79 -115,252 -14,156 -14,69
0|9503,10061 20,67 23,78
0|10098,9822 -7,181
0|8973,8408 8,25 -2,210 -33,145 -26,76 -20,57 -10,113 -30,46 44,-7 35,26 183,58 8,7 23,22
2|9227,9160 6,-35 64,-393 22,-133 1,-198 -33,-134 -69,-63 -138,-35 -63,75 -44,164 -264,-31 -160,-9 -77,-5
0|8549,8368 -62,68 -31,126 26,112 131,149 56,60 53,57 99,118 39,22 -24,41 15,55 83,267
2|9024,7630 -81,23 -116,34 -71,-23 -46,-55 -50,-152 13,-264 5,-37
0|8092,7085 0,60 207,183 369,300 42,-19
0|8118,7567 15,-40 20,-35 146,-164 126,-140 31,-1 217,6 247,17 66,-1 44,-14 54,-30 43,-119 -6,-110 -42,-88 -67,-52 -35,-4 -40,-5 -38,21 -288,154 -80,47 -68,5 -42,-1 -277,-25
0|9198,6599 -221,193
0|9084,7165 47,404
0|7968,6976 -963,-64 -234,-14
0|7894,8471 35,-5 33,-1 14,0 84,51 212,9 184,37
0|8272,8525 -9,315 32,16 374,27 48,-16 203,-3
0|8836,9121 -27,49 -90,27 -100,-3
0|8295,8856 0,51 0,180
0|8203,8913 92,-6
0|7897,8934 60,48 105,167 -30,16 -144,29
0|7880,9519 226,-22 153,-8 133,41 130,45 121,24 146,-10 57,-49 88,-97 179,-270 17,-9 67,-31 36,-8
1|8064,9784 -192,-16
0|7871,8803 -92,115 -51,59 -114,-8
0|7728,8977 45,72 30,70 -8,102 -10,14 -65,88
0|7785,9235 64,77
0|6947,9422 32,6 50,56 113,8 324,24 144,11
0|7417,9463 49,53 -3,228
0|7142,9492 -4,67 -57,86 -16,268 24,51 -10,40 -74,65 -18,75
0|6987,10144 -2,52 -2,64
0|6535,10085 15,93 10,59
0|6541,9969 -6,116
0|6872,10136 1,-204 38,-32 -2,-183 -318,-21 -4,-91 -139,2 -20,134 -233,-24 -12,196 32,8 -7,133
0|6254,8997 -4,146 -97,153 -11,59 -21,113 -30,166
0|5908,9347 234,8 268,30 60,3
0|6047,10060 -114,-60 -43,-22 -90,-153 -23,-38 -64,-121 4,-166 11,-17 35,-58 51,-19 85,0 9,-59 28,58 109,106 46,123 16,43 14,167 17,185
0|6121,9844 -139,77 -49,79 -17,60
0|5345,9471 141,49 64,23 163,123 -2,143 -4,24 -26,139
0|5800,9825 -53,-16 -40,24
0|5717,9500 -72,46 -95,-3
0|7641,13475 -47,-34 -23,53 -37,30 65,1 41,6
0|7155,13025 0,55 -11,296
0|6779,13059 -118,61 -79,50 -19,49 6,-172
0|6088,10582 186,20 138,26 19,5 88,19 29,-11
0|6414,11087 -60,-6 -51,-76
1|6053,8850 26,-175 18,-127 38,-19 199,86 6,67 -36,78 -225,-85
1|5530,8554 -104,-35 -180,-60
1|4442,8217 49,18 71,26 148,53
0|5972,11138 -8,150 -14,151 -32,23 -180,-89 -211,-90 -72,-35 -111,-4 -40,38 -154,-3 -130,-6 -105,-39 -49,-54 -38,-66 -21,-75 -7,-77 9,-80 24,-79 47,-63 53,-27 24,-43 53,-78 -1,-67 109,-208 67,-193
0|5950,11439 49,23 41,19
0|5950,11439 31,125 24,77 36,-59 26,-50
0|6074,11849 37,99 31,92
0|6005,11641 -195,301 -74,125 -52,139 -10,64 10,17 -12,56 -9,41 -18,23 -28,182 13,58 204,35 45,7 97,19 72,10 4,-42
0|5513,12620 50,14 67,13 -14,85 -6,62
0|6183,11360 -143,121
1|5611,12331 61,12 153,-99 286,55 42,8
0|4703,12525 192,68 407,145 164,54 23,8
0|5489,12800 45,13 53,20
0|5302,12738 -37,245
0|4895,12593 -44,286
0|7717,10030 -3,158
0|7459,10144 -10,-63 -56,-27 -66,-3 -44,38 -10,41
1|4759,4805 152,71 159,149 464,608 167,223 212,192 222,157 250,90 178,32
1|6554,6522 -206,-21 -268,-98 -217,-136 -257,-251 -396,-485 -243,-297 -136,-146 -96,-59
1|6545,5587 -576,-155
1|6562,5371 -802,-224
1|6582,5156 -955,-337
1|4658,4449 -116,-2 -29,53 -48,453 38,46 90,16
1|5861,6979 60,17 96,28 276,102 53,-3 47,-159
0|6639,6432 81,-1 68,3
0|6566,6794 72,131
0|6638,6925 -18,61 -19,67
0|5717,3178 -264,-67
0|5588,1875 213,61 -97,640 -26,174 -34,228 17,84 63,88 -7,28 -35,258 -3,27 -57,338 -107,631 -4,26 42,72 154,56 -5,74
0|5893,3432 1,-10 -138,-36 -13,65 -61,-15
0|5315,2545 64,-298 23,-33 100,35 35,-19 51,-355
0|5704,2576 -55,91 -67,-9 58,30 38,62
1|6475,3066 -134,-37 -633,-173
1|6376,2782 -35,247 -32,222
1|11573,4696 61,-504 21,-169 27,-214 105,-847 25,-203 90,-729 127,-985
1|11746,4734 88,-665 166,-1274 92,-719 103,-837
1|11923,4788 34,-261 28,-218 25,-196 159,-1283 95,-714 91,-701
1|12211,4164 161,-1286 80,-725 69,-532
1|12697,2953 -160,1294
1|12861,2992 -174,1292 -29,206 -31,227 -33,241
1|13058,3040 -12,94 -21,171 -127,1033
1|13186,3336 -120,1044
1|13352,3369 -118,1054
1|13568,3172 -11,66 -7,34 -22,134 -134,1057
1|11787,2962 -121,-18 -50,17 -106,768 26,64 146,16
1|11985,4309 673,181 1015,272
1|13636,5003 -1009,-286 -670,-190
3|13085,7698 -108,662
3|12909,7646 -102,666
3|12727,7602 -99,662
3|12579,7562 -98,-20 -38,17 -85,482 -24,147 135,36
0|6088,12946 302,65
0|6042,12935 46,11
0|5539,14554 -10,134 -40,58 -4,41
0|5480,15133 -11,190 660,55
1|4355,15746 -37,164 23,364 11,87
1|3797,15819 -96,11 -107,-12
0|6553,14228 -160,0
0|5820,13875 -7,119
0|6208,15779 -103,3
0|6262,15301 2,97
1|10659,15675 -20,368 -1,29 24,91 -5,101 -21,36 -15,27 -70,49 -52,2 -55,-3
1|11752,18773 53,53 64,58 97,153 2,118
1|5426,15132 14,-49 13,-246
0|5464,15042 16,91
3|9473,3339 -108,-3 -263,-64
0|6266,3351 -29,161 51,19 -201,1192 -12,54
0|11016,5003 -13,104 -13,102
0|11606,4073 -289,-54 -56,-10 -19,15 -110,922 7,70 23,47 24,14
0|11627,3928 -325,-63 -23,-17 -11,-28 121,-988
0|11279,3848 -8,78 -10,83
1|9758,14337 -13,227 7,54
1|8554,10284 -3,88 -1,56 -50,64 -165,14 -287,-16 -49,-49 -8,-110 -6,-76
1|9032,9340 42,82 -6,201
1|11022,12121 361,30
1|10892,5478 -575,325
1|10850,5792 -451,264
1|10815,6054 -353,200
1|10777,6333 -248,132
1|3941,4063 -150,265 -42,167 -13,322
0|2300,16503 39,15 54,24 28,12 26,26
0|2450,16393 -1,11 -1,65 -1,111
0|2088,19345 -19,27 -7,80 -9,73
0|1916,18770 73,26 99,31
1|1658,18537 -13,181 -24,99
1|1939,19402 -106,-22 -142,10 -72,0
0|7247,16442 -17,2 -16,8 -12,16 -9,19 -2,23 2,22 8,20 13,16 15,9 17,2 16,-5 14,-12 11,-18 6,-21 0,-22 -5,-22 -10,-18 -14,-13 -17,-6
0|7444,15712 110,12
0|7310,15360 -3,147
0|7457,14690 138,3 88,0
1|4697,12545 -68,26 -48,42 -35,81 -44,217 14,80 126,46 47,1
0|3642,16257 5,153
0|3578,16234 -46,47 -34,36 -100,10
0|3397,16276 -151,13 -210,18
0|3245,16234 1,55 9,141
0|3311,14431 -64,-3 -167,-52 8,194 -38,231 -28,170 -27,51 -65,399 -41,244 -40,38 -20,111
0|3050,14801 135,40
0|2930,15421 160,50
0|2630,15918 176,47 8,-45
0|3306,14169 -62,50 -38,19 -99,-27 20,-121
0|2930,14647 -106,-31
0|2894,14875 -106,-36
0|2820,15298 -101,-28
0|2790,15472 -100,-33
1|3574,11915 -11,-41 47,-221 21,-18 140,34 18,22 27,34 10,71 -252,119 -42,133 -17,62
0|3610,11653 -32,-27 -16,83 -62,80 -50,19 -43,-23 -16,-72 42,-64 33,-56 12,-46 105,30 -5,49
0|3353,11313 -23,64 -15,99 24,69 66,21 47,-2 26,-17 4,-59
0|3792,12165 5,-64 2,-109 41,-146 33,-60 23,-41 3,-105 27,-59 -48,-16 -53,27
0|3825,11592 -36,99
0|6110,10302 -49,-35 -34,-24
0|6245,10102 -8,55 -2,64
0|6027,10243 -233,20 -163,21 -37,-4 -98,-7 -81,-13 -150,-102 -80,-34
0|4862,9665 -61,-22 -45,215 233,81 49,36 40,46 22,15 17,12
0|5117,10048 31,40 37,36
0|5519,8855 -61,281 -34,110 -8,24 2,102 68,148
0|5424,9246 139,38 94,40 62,83 9,76
0|5557,10729 -56,224 89,46 275,112 107,27
0|5563,10500 -3,14 -13,2 -36,-42 -38,-28 -68,-10 -57,-14 -36,-29 -28,-41 -29,-104 -70,-124
0|5590,10999 -63,284
0|5982,10841 -425,-112
1|4060,10150 4,236 1,15 -31,148 29,116 55,31 86,-4 49,-62 22,-88 -36,-118 -94,-43 -80,20
3|5080,7718 -6,73 -2,28 -15,87 -37,53 -41,32
3|11865,7160 51,-366 18,-17 175,36
3|5418,19325 -41,7 -207,-46 -206,-71
3|3226,3116 -71,320 -29,268 -1,247
3|909,21480 87,524 57,32 53,-2 87,-22
3|5301,14320 -110,-22 -308,-70 -33,-39 -2,-57 25,-68 40,-20 77,10 340,81
1|6589,21005 -15,260 20,425 26,170 50,191 80,109 92,88
1|7553,19535 -171,-57 -146,-48 47,-386 6,-59 8,-61
1|7791,19023 -7,49 -8,57
3|12358,8041 -344,-92 -1214,-324 -63,-16
3|10996,6989 -63,468 153,39 159,40 167,42 154,39 164,42 168,42 58,15 92,25 252,69
3|12048,7741 -34,208
3|11976,7182 -78,519
3|11808,7149 -78,510
3|11641,7116 -75,501
3|11487,7086 -75,492
3|11245,7536 70,-484
3|11148,7019 -62,477
3|12397,11058 -16,62 -25,132
3|12085,11210 67,-6 113,27 91,21 55,21 163,59
0|9341,18269 -90,-35 -200,-52 -372,-97 48,-360 -37,-78
3|11470,7082 42,-305 -35,-231 -80,-140 -71,-62 -22,-31 1,-99
1|13365,5729 -72,494
1|12011,22973 33,-160 34,-247 3,-133
0|7365,20361 -16,109 -146,748
3|586,14532 39,-252 32,-363 17,-54 39,-51 60,-26 183,-13
0|5594,10280 -2,69 -29,151
0|5467,10721 90,8
0|4880,10740 347,141
0|11747,15912 -8,359 -15,617
0|11596,16268 1,-46 1,-192 10,-53 13,-74
0|11621,15903 22,-13 89,16 15,6
0|11608,15977 13,9 73,237 15,44 30,4
0|11747,15912 101,25 237,60
0|12160,15824 -43,-10 -574,-130 -35,-6 -16,2 -21,10 -26,31
0|12345,15879 -185,-55
0|12160,15824 39,-299 1,-12 -2,-9 -7,-3 -23,19 -6,15 -3,18 -4,27 -38,234
3|1630,6015 87,192
0|7836,8059 -26,148 9,202
0|12576,10872 57,-82 58,-91 -21,218
0|11257,10126 -26,146 -19,69 6,70
3|13149,9940 -68,-21 -239,-67
2|11364,2662 70,-571 106,-878 50,-343 21,-172 18,-54 20,-63 21,-52 22,-42 79,-125
3|11277,-192 -240,432 -50,136 -47,384 -146,1205
3|11434,2091 -145,-28 -176,-35 -174,-34 -145,-29 -136,-29 -180,-39
1|11289,2063 202,-1691 -161,-200 -99,-14 -68,76 -26,112 -53,444 -116,959 -29,245
1|11330,172 -217,1856
3|11084,790 -144,-30 -141,-26 -168,-30
1|10799,734 -141,1202
3|2157,17752 -111,-36 -169,-54 -247,-68 -108,-34
2|3423,9580 -147,761 -207,1290 -22,138 -29,245
2|3446,9434 -23,146
3|12089,15947 172,75 58,23 124,55
0|7586,14953 -272,363
0|7229,14674 17,62 28,34 24,8
0|7519,11544 -112,-27
0|7507,11770 62,21 115,79
0|7444,13039 1,55 75,131 62,136 11,33 1,47
0|7483,12448 16,-415
0|7479,12476 4,-28
0|9368,16131 172,-280 115,-187 146,-236 -16,383 -14,340
0|9908,15820 -76,-5 -47,-4 -83,58 -94,74 -240,188
3|9392,15072 -248,10 -141,-2
0|9381,15641 159,210 68,92 163,208
0|9381,15641 216,-222 204,9 48,4 77,6
1|9591,19928 -72,462
0|2317,16382 41,7 91,15
3|15093,5734 788,211
3|15815,6371 66,-426 16,-150 -30,-70 -41,-16 -641,-171 -35,0 -32,39 -25,157 -69,430
0|6431,10633 -36,56 -69,68 -68,32 -88,-1 -90,-11
0|6183,11360 -125,-51
3|1697,21249 8,-126 -76,-528 -5,-103 75,-56 277,-72
3|9056,20021 -108,-44 -240,-84 -43,-38 5,-136
0|13227,8927 -30,-9 -37,-18 -22,-23 -56,-92 -45,-65 -50,-51 -72,-45 -143,-68 -223,-40 -265,36 -336,186 -289,51 -305,-143 -58,-27 -187,-121 -53,-9 -134,-23 -142,19 -45,-39 -46,-41
0|5169,51 -42,-5 -50,-66 -108,-151 -55,-48 -78,0
0|5231,57 -32,-3 -30,-3
0|6853,5174 2,-81 -2,-64 -38,-75 -101,-70 -41,-59 -24,-46 -35,-79 -23,-72 -14,-92 9,-156 38,-220 60,-333 52,-305 42,-108 48,-84 88,-80 85,-64 31,-46 20,-39 21,-65 48,-337 43,-309 37,-285 -5,-144 -32,-113 -88,-97 -197,-69 -514,-172 -611,-247 -61,-91 -176,-247 -169,-214 -48,-150 12,-156 20,-209 -7,-56 -37,-55 -55,-28
0|6824,5290 15,-66 14,-50
0|7005,6967 0,-55 2,-59 -9,-47 -20,-36 -30,-44 -55,-59 -18,-29 -4,-43 8,-150 1,-185 -18,-33 -38,-32 -20,-29 -9,-43 -1,-40 1,-53 12,-294 13,-370 4,-76
0|7000,7073 3,-56 2,-50
0|8118,7567 -63,48 -40,47 -85,36 -9,-6 -49,-21 -165,-140 -136,-112 -149,-130 -197,-152 -178,-19 -42,-15 -5,-30
2|9080,8169 -80,-259 19,-52 5,-228
0|10564,8300 -602,-181 -500,-134 -332,-97
0|10689,8405 -51,-60 -25,-20
0|6976,6450 16,-365
3|9473,3339 12,-712 117,-983
0|10512,9724 85,-53 96,-172 47,-180 11,-216 -29,-170 -91,-170
0|10693,9499 31,142 122,160
0|12317,8105 -27,207 -6,240
0|11068,9755 80,-78 252,-371 34,-73 6,-86 1,-73 -109,-225 -3,-142 25,-61
0|11872,9402 -249,-164 -140,-126 -42,-38
0|9600,10001 -6,-131 -74,-9 7,-128 -15,-564
3|6152,2116 108,152 113,76
0|6605,2410 -124,-156 -108,90
0|5588,1875 -93,26 -238,-65
0|5622,3801 -130,-5
0|5028,4491 31,-162
0|4967,4099 124,44 188,74 54,104 75,80 107,31
0|5091,4143 -7,32
0|6587,4937 9,-55 13,-63 40,-40 74,-72 -1,-24 13,-15 18,-1 9,9 0,22 -12,17 -13,4 -14,-12
0|6599,5039 256,54 196,42 153,16 289,19 220,15 294,20 662,36 178,74 94,8 48,-13
0|7713,5185 3,-107
0|7504,4958 -12,-2 1,214
0|6537,5734 89,132
0|6795,6030 -31,-3
0|6626,5866 48,55 59,67 31,39
0|8463,7014 -3,102 -4,71
0|8458,5555 -10,200 -86,181
0|8630,5787 -21,-1 0,-18 -94,-190 1,-21
0|8519,5481 -3,76 -58,-2 -97,-7 3,-72
3|8467,5314 -9,241
0|5969,6883 -17,4 -11,18 -20,91 -210,927 -15,69 -67,293 20,28 -81,356 -13,23 -12,50
0|5519,8855 12,-58 12,-55
0|5618,7965 -113,-39 -16,65 -230,-85 -77,-87 -84,-25 -24,-3 -132,-17 -29,55 -145,-17 -120,-21 7,-83 -50,-17 -25,23 -11,52 10,23 -88,446 -15,73 58,22 -147,732 -39,194 -52,19 -22,36 -81,423 36,39 32,-85 495,170
0|5618,7965 42,15 36,12
0|4942,7774 12,-74 29,-176
0|4711,6491 -280,934 62,84 36,27
0|4936,6010 -84,120 -45,53 -34,104
0|4773,6287 -62,204
0|4063,6088 -16,75 -12,58 -18,29 -34,0 -231,-74 -16,-33
0|4017,6250 51,19 71,21
0|3736,6143 -71,1 -14,0
0|3651,6144 -91,-40 -26,52 -34,26 -48,7 -134,-66 -174,-55 -46,43 -27,0 -118,-108 -268,-81 -239,-59 -50,-13 -29,7 -270,-70 -236,191
0|3639,6040 -41,6 -38,58 -16,-6 -33,-6 -615,-546 -24,-6 -454,115 -21,-133 -35,-100 -51,-341
0|1797,5750 -4,-164 119,-86 -66,-198 185,-160 236,-106 44,45
0|2418,5655 28,208
0|5489,7991 -4,32 26,108 -85,388 -11,53 3,31 23,69 -2,21 -24,115 -45,34 -76,328 0,109 -27,153 -10,62 -157,542
0|5267,9432 45,22 33,17
0|4229,9773 -14,34
0|4215,9807 -9,42 -9,42
0|4197,9891 -23,122 -11,106 15,137 33,80 50,43 44,80 12,96 -25,99 -17,22 -12,15 -16,21 -39,26 -17,35 -53,7 -51,-18 -24,-16 -9,-47 -35,-47 -22,-84 4,-107 1,-53 2,-326 -2,-37 32,-208
1|4129,9822 -69,328
0|4050,9748 9,-46 13,-63 132,-644 71,-344 39,-191 16,-79 7,-37 21,-103 91,-463 40,12 19,-99 -8,-69
0|4050,9748 -8,44 -8,45
0|4059,9702 49,14
0|4108,9716 38,8 47,10
0|4387,9062 -78,-24
0|4204,8995 45,14
0|4249,9009 30,15 30,14
0|4529,7536 -8,24 -21,62
0|4211,10336 -53,-10
0|4002,10408 30,-2
0|4158,10326 -94,60 -32,20
0|3109,11936 -9,42
0|3100,11978 -6,51 -7,63
0|3117,12090 -30,2 -26,32 -16,49
0|6050,13002 38,87 60,50 89,33 21,33 -134,140 -36,37 -53,14
0|6124,13345 166,18
0|6432,12753 27,43 112,17
0|10207,13896 78,107 44,127 21,58 54,153 3,18 63,324 7,69 43,412 215,190 28,23 248,206 8,-129
0|10157,14530 57,-66 121,-68
0|10329,14130 -32,23 -25,17
0|9741,13918 171,-4 69,3 145,12 44,18 36,80
0|9227,15382 10,-264 154,143 141,131 65,27
0|10335,14396 38,-19 34,-18
0|10407,14359 36,3 424,29 -23,201 -7,60 -2,78 -8,290 163,15
0|11064,14804 3,-27 -232,-47
0|10443,14362 48,145 353,85 190,39 175,18 18,-226 -360,-32
0|-5269,9077 496,346 561,389 294,171 285,112 50,28 183,103 119,84 177,90 333,136 145,64 60,27 114,51 296,87 341,77 359,100 163,52 194,62 308,133 504,201 488,195 582,228 591,234 471,187 495,202 256,80 141,43 82,21 61,-22
0|2880,12558 -3,79 -4,101
0|2873,12738 -88,682 -225,1364
0|2560,14784 -8,42 -15,87
0|2537,14913 -64,349 -45,206 -57,385 -57,101 -32,271 -8,40 -18,101 -16,121 -71,433 -9,53 -17,111 -97,632 -33,218 -9,67 -95,686 -12,57 -35,20 -31,-2 -186,-44
0|1678,18909 28,16 36,6 109,72 13,22 6,32 -9,66 1,37 -27,51 -15,44 -10,85
0|1851,19003 20,-98 21,-113
0|1897,18744 1,22
0|1916,18770 -18,-4
0|1892,18792 6,-26
0|2053,19525 -30,3 -15,32 -11,135 32,519 25,238 73,443 58,295 38,192 82,434 89,475 30,159 93,492 70,381
0|2185,21190 -80,31 -43,16
0|2240,16487 60,16
0|9527,9733 39,-1 27,17 49,15 51,7 36,-5 69,-26 11,-17 -7,-71 4,-28 16,-3
0|11389,2832 -45,-12 -55,-14
0|11289,2806 85,-616 -3,-27 -15,-22 -92,-21
0|4736,20316 83,26
0|4819,20342 687,245 180,61 503,172 14,2 11,-8 62,-348 54,-347 50,-367 75,-565 46,-336 39,-223
0|6540,18628 59,15 20,5
0|6619,18648 8,26 18,28 23,14 109,27 246,63 22,-7 16,-12
0|7061,18787 77,3 32,1 -11,95 -9,74
0|7150,18960 139,25 308,54 187,33 316,56 50,3 45,-24 33,-59 18,-70 50,-408
0|11223,27189 57,-15 -18,-127 -307,-2205 -33,-274 -13,-171 -6,-133 -2,-181 5,-145 11,-218 16,-176 86,-756 9,-34 4,-14 26,-28 36,-17 31,-2 47,18 280,106
0|10200,22366 645,222 54,64 6,35 -4,39
0|10901,22726 69,17 58,11
0|10952,22392 297,-1975
0|11097,22321 290,-1937 19,-95 39,-191 65,-290 68,-241 227,-741
0|11406,20289 -61,-21 -54,-18
0|11261,20299 -2,20 -10,98
0|12018,17767 70,34 57,47
0|12294,17313 112,-614 81,-449 34,-253 61,-451 14,-44 -6,-58 60,-594 12,-33 -7,-55 51,-570 56,-628 12,-30 -7,-49 56,-609 14,-41 -6,-47 53,-556 7,-63 45,-402 56,-400
0|12869,11346 61,5 62,16
0|12891,12169 -64,-13 -54,-10
0|12585,14174 57,10 64,8
0|12404,15973 56,13 61,11
0|8920,7210 -6,213 4,77 25,153
0|7462,6244 2,-53
0|11927,12185 8,-104 3,-120 -16,-130 -13,-99 37,-121
0|11908,12233 -75,-54
0|11638,13565 -136,-69 8,39 37,33 -64,195 -58,65 -81,-5 -197,143
0|11502,13496 -35,-32
0|6052,16154 -34,83 -19,93 -80,391 -190,-66 -62,15 -47,61 -25,104 -7,36
0|5919,16721 3,22
0|5576,16348 65,1 54,22 16,-41 32,-33 31,-12 47,3 70,17 108,25
0|5891,16305 -6,31
0|6018,16237 198,49
0|6638,15870 2,88
0|6902,16125 -1,-71 -3,-109
0|7464,16106 1,-76 0,-97
0|7464,16106 88,-4 52,1
1|8289,17607 -8,-196 -21,-78 -21,-76 -320,-93 -48,256
1|8260,17333 388,135
1|8659,17203 -475,-151 55,205
0|10759,7698 30,10 908,236 265,68 355,93 4,-22
0|11660,8192 24,90 49,61 53,21 42,-6 43,-21 32,-44 26,-48 -18,-7 -11,-30 -29,-50 -33,-28 -41,-16 -43,4 -29,14 -32,27 -33,33
0|11697,7944 -12,83 -25,165 -64,-13
0|11962,8012 -11,80 -22,153 136,39
0|11951,8092 -266,-65 -153,-38 -5,30
0|11322,8376 -247,14 -67,-120 -14,-83 -117,-34 -22,-21 -35,-33
0|10820,8099 -79,-18
0|10735,8446 120,-314 5,-49
0|11075,8390 -19,99
0|9602,1644 94,184 301,71 89,63 199,39 95,-24 18,-22 5,-52 75,-6
0|12186,13284 -74,-6
0|12186,13284 118,37 126,-25 26,-27 26,-30 17,-13 -17,-75 183,-72
0|11559,11527 76,-130
0|12039,11366 26,-37 20,-119
0|11964,11031 -81,125 -11,9
0|11883,11156 144,160 -15,18
1|12574,11332 -63,466 136,32 62,-446 -135,-52
0|12647,11830 25,56 70,19
0|12459,12391 1,-88 71,-184
0|11745,11531 52,-78 -58,-78 8,-12
0|10471,10611 -48,1 -63,-12
0|10242,12613 -34,-4 -35,-3
0|10159,13023 67,3 56,3
0|10323,16879 -28,105 -15,53
3|10374,16386 -296,-23
3|10299,16464 72,5
0|10003,16166 -8,229
0|10011,16755 -29,-101 -81,64
0|9982,16654 0,-43
0|10208,16699 -28,137 -1,7
0|9551,16132 -7,87
0|9477,16126 -4,75
0|9516,16576 85,-33 64,-52 24,-56 16,-78 48,-1
1|9501,17403 -76,-34 -63,-22 -148,43
1|9214,17390 -96,-26 -31,199 98,26 29,-199
0|9304,13809 -5,166
0|9215,14196 104,-15
0|9381,15641 -8,0
0|9031,15624 82,7
0|9206,15886 -7,128
0|9031,15624 -38,-61 -51,-80
0|9017,15881 -31,-17 -56,-30
0|8922,16082 2,-81
0|8220,16391 92,131
0|7643,16097 24,148
1|7344,17285 -217,-63 -3,18 -23,114 220,68
0|10233,6265 90,35 94,-49
0|10122,5709 -33,105
0|10171,5567 30,48 21,51 2,6 54,160 39,118 37,110 56,169 7,22 9,26 33,103 15,44 28,86
3|9429,5677 -176,-361
1|2764,13808 103,19 213,9 114,14 187,51
0|5527,11283 -16,81 -9,52
3|5457,11460 -102,-5 -23,-19 -32,-85
0|4263,10691 31,37 42,34 54,21 76,20 88,9 41,17 50,-77
0|8819,6433 -5,138
0|10731,7006 -79,633 -77,619 15,50 10,34 -20,135
0|10580,8477 -7,34 -14,64
0|8267,13422 97,8 163,15 31,2 155,14
0|8524,13528 -2,26
0|8488,13804 -1,113
0|10873,15525 -58,120 -6,107 -66,85 -10,196 5,36 19,43 8,42 -3,66 -30,31 -55,71 -41,-22
0|10639,16043 94,-10 71,0
0|10652,7639 45,15
0|11066,12403 -25,6 -28,21 -24,31 -17,27 -30,14 -39,0
0|11479,12367 -71,-7
0|11291,12792 18,-31 94,106 17,1
0|11575,12825 -8,190
0|12866,10613 27,9 9,11 6,19 -5,59 5,28 14,16 34,12
0|12869,11346 -32,12 -19,-4
1|13025,3305 161,31 166,33 176,37
2|13046,3134 511,104
0|12686,12458 -18,0 -13,6 -12,16 -9,22 -7,12 -9,3
0|7465,8741 7,-82 15,-71 26,-44 39,-29 79,0 55,35 42,24
3|7899,8846 -28,-43 -131,-199 -12,-30 -6,-39 4,-40 14,-36 22,-28 27,-17 30,-5 29,9 26,21
0|7968,6976 -3,53
0|7950,7137 9,-60 6,-48
0|6587,9605 -117,-217
1|4308,11950 -21,134 -7,141 -7,65
1|2114,18022 -110,-21 -120,-23
0|2739,16796 14,-19 3,-19 -6,-15 -13,-8 -2,-17 1,-18 18,1
0|2754,16701 4,-97
0|2411,16791 17,2 129,16
0|2606,16649 -20,0 -24,10 -124,124 -10,10
1|10478,1897 153,-1193
1|13549,5781 -71,490
0|13607,6354 -399,-104
3|6608,18760 -9,-117 -7,-91 21,-227 -36,-108 59,-328 44,-184 43,-320
0|9597,15419 8,-227 6,-171
0|10524,15192 -43,-3 -48,-5
0|10292,15849 16,-388 2,-30
0|10433,15184 -61,-3 -54,44 -10,0
0|10318,15225 11,-240 3,-73
0|10310,15431 8,-206
0|10357,15852 -54,-3 -11,0
0|10423,15856 -66,-4
0|10189,15453 119,8
0|9605,15192 12,1
0|9071,12437 12,-109 57,-131 65,-107 19,-91
0|9004,16257 2,46 16,33
0|11597,16222 97,1
0|9689,16435 55,29
0|5428,17807 -414,-124 -17,-49 24,-137 73,-488 45,-297 10,-110 5,-291 -1,-54 17,-38 38,-26 55,-7 91,-2
0|3505,16417 3,76 4,79
0|5205,16034 -48,17 -47,18
0|8867,16818 -65,-23
0|8906,16448 -64,58 -51,87
3|7059,19501 163,41 14,-112
3|7428,19071 -46,407
3|7776,19129 -67,486
3|7924,19159 -60,488
3|12657,6777 251,54
2|13746,5840 -72,537 -183,1238 -26,181 -63,413 -53,367 -15,97 -17,103
0|10613,8325 -23,-17 -26,-8
0|9130,7888 -27,-7 -84,-23 -156,-57 -112,-44 -54,-30 -116,-89 -60,-27 -329,-58 -38,3 -36,11
0|10536,15448 14,6 15,17 10,26 27,117 9,37
0|10350,14188 137,13
0|7407,14398 1,-43 -7,-25 -52,-87
0|4072,9639 -104,-36 46,-228 -96,-39
0|3968,9603 -10,44
0|3885,9318 -40,-16 -57,289
0|4275,8651 -209,-73
0|5835,12581 1,46 140,81
0|5836,12627 -2,55
0|5878,12724 -6,39 -2,15 -7,60
0|5879,12689 -1,35
0|5466,12792 6,-37
0|5472,12755 12,-58 11,-51
0|5591,13501 -5,66 -4,49 -2,18 -5,57
0|5634,13575 -48,-8 -49,-7 -8,46 53,10 49,7 3,-48
0|5565,13694 10,-3 9,4 2,4 4,6 3,12 -3,13 -6,9 -10,4 -2,-1 -8,-3 -7,-9 -3,-13 1,-5 2,-9 8,-9
0|5580,13634 -34,8 -25,31 -6,31 -2,13 9,44 26,30 18,4 16,3 28,-15 19,-30 5,-29 2,-10 -7,-38 -21,-29 -28,-13
0|5452,13691 26,6 37,7 40,8
0|5593,13717 41,7 30,6 20,4
0|5664,13730 -8,99 -33,-4 -60,-6 -63,-6 13,-96
0|5529,13606 -8,67
0|5572,13742 -6,53 -3,24 -3,37
0|5629,13753 -6,72
0|5478,13697 5,-41
0|6035,13396 -105,-10
0|5752,13350 -79,-5
0|6142,12040 59,164 21,114
0|6317,12230 -51,51
0|6266,12281 -44,37
1|6121,11932 224,136 23,59 9,47 -5,163
0|6484,11951 29,123 5,64 -1,35
0|6486,11879 -2,55
0|6484,11934 0,17
0|6516,12199 -1,32
0|6517,12173 -1,26
0|6630,11947 -16,-64
0|6639,11984 -9,-37
0|6681,12205 -2,38
0|6684,12146 -2,38
0|6682,12184 -1,21
0|6052,12676 20,-207 39,-170
0|6052,12676 47,2
0|6099,12678 46,-2 151,-10
1|8384,16750 14,111 373,109
0|8324,17510 -13,106 -141,1069 -30,230 -16,27 -26,20 -28,6 -357,-56
0|4314,8460 -89,-31
0|4002,10408 -30,-2 -28,5 -28,20 -19,21 -17,7 -4,-32 32,-145 0,-26 -10,-17 -157,-61 -15,83 -12,32 -22,32 -30,28 -34,29 -17,17 -10,20 -17,83 -15,72 -1,22 5,18 13,13 52,24 11,4 44,16 221,36 23,-1 17,-7 11,-19 8,-19 30,34 27,41 21,19 12,-9
0|3880,10459 -24,20 -22,2 -35,-13
0|3876,10427 -18,-6
0|3584,10502 14,5
0|3641,10640 -3,11
0|3973,10661 -39,-17
0|5362,14263 -19,-6
0|5343,14257 -30,-11 -39,-15
0|5183,14143 82,20 -9,63 -8,54 -48,-10
0|5274,14231 -18,-5
0|5711,14734 -1,69 5,73 -2,40 -7,34 2,94
3|9435,17740 109,25 50,-34 63,-315 -36,-55 -102,-47
0|4065,12154 -4,28
0|4061,12182 -6,43 -5,40
0|4050,12265 -1,11 83,23 60,25 22,20 17,42 7,53
0|4214,12344 10,-7 65,18 59,17 11,-55 8,-38
0|4367,12279 4,-23
0|4348,12372 16,52 35,29 42,17 178,76 10,25
0|7083,15345 3,142 -63,177
0|7444,13039 16,-62 14,-56
0|7474,12921 0,-45
0|6560,10277 -3,236
0|6560,10237 0,40
0|6948,10763 -1,67 -47,-1 -23,13 -11,33 -6,54
0|9046,12342 -71,-4
3|8991,11950 -5,173 -2,63
0|8109,12272 56,6
0|8111,12174 399,34
0|9012,14722 61,6
0|9073,14728 26,2
''';

  // ───────────────────── 5. Build the graph ─────────────────────
  const baseLat = 41.478;
  const baseLng = -71.542;
  const unit = 1e-6;

  final nodeX = <double>[];
  final nodeY = <double>[];
  final nodeLat = <double>[];
  final nodeLng = <double>[];
  final adj = <Map<int, double>>[]; // adj[a][b] = cost of walking a→b
  final nodeIndex = <int, int>{};

  double nodeDist(int a, int b) {
    final dx = nodeX[a] - nodeX[b];
    final dy = nodeY[a] - nodeY[b];
    return math.sqrt(dx * dx + dy * dy);
  }

  int nodeFor(int y, int x) {
    // Heal tiny OSM endpoint rounding gaps, but verify the real metric distance
    // so nearby parallel paths are not merged merely because their grid cells
    // are close. Register aliases too; otherwise a chain of near-matches can
    // become disconnected because only the first coordinate was indexed.
    final key = y * 100000 + x;
    final lat = baseLat + y * unit;
    final lng = baseLng + x * unit;
    final px = toX(lng);
    final py = toY(lat);
    var bestId = -1;
    var bestD2 = 0.45 * 0.45;
    for (var dy = -4; dy <= 4; dy++) {
      for (var dx = -4; dx <= 4; dx++) {
        final existing = nodeIndex[(y + dy) * 100000 + (x + dx)];
        if (existing == null) continue;
        final ex = px - nodeX[existing];
        final ey = py - nodeY[existing];
        final d2 = ex * ex + ey * ey;
        if (d2 <= bestD2) {
          bestD2 = d2;
          bestId = existing;
        }
      }
    }
    if (bestId >= 0) {
      nodeIndex[key] = bestId;
      return bestId;
    }
    final id = nodeX.length;
    nodeIndex[key] = id;
    nodeX.add(px);
    nodeY.add(py);
    nodeLat.add(lat);
    nodeLng.add(lng);
    adj.add(<int, double>{});
    return id;
  }

  void addEdge(int a, int b, double mul) {
    if (a == b) return;
    final w = nodeDist(a, b) * mul;
    final old = adj[a][b];
    if (old != null && old <= w) return;
    adj[a][b] = w;
    adj[b][a] = w;
  }

  for (final rawLine in waysData.split('\n')) {
    final line = rawLine.trim();
    if (line.isEmpty) continue;
    final bar = line.indexOf('|');
    final cls = int.parse(line.substring(0, bar));
    final mul = classCost[cls < classCost.length ? cls : classCost.length - 1];
    var y = 0;
    var x = 0;
    var prev = -1;
    for (final tok in line.substring(bar + 1).split(' ')) {
      final comma = tok.indexOf(',');
      y += int.parse(tok.substring(0, comma));
      x += int.parse(tok.substring(comma + 1));
      final id = nodeFor(y, x);
      if (prev >= 0) addEdge(prev, id, mul);
      prev = id;
    }
  }

  final realN = adj.length;
  if (realN == 0) {
    return [];
  }

  // ───────────────────── 6. Connected components ─────────────────────
  // Find connected components so both endpoints can be snapped to the same network.
  final comp = List<int>.filled(realN, -1);
  final compSize = <int>[];
  for (var s = 0; s < realN; s++) {
    if (comp[s] >= 0) continue;
    final id = compSize.length;
    final stack = <int>[s];
    comp[s] = id;
    var size = 0;
    while (stack.isNotEmpty) {
      final u = stack.removeLast();
      size++;
      for (final v in adj[u].keys) {
        if (comp[v] < 0) {
          comp[v] = id;
          stack.add(v);
        }
      }
    }
    compSize.add(size);
  }
  // Do not force every route onto the single largest component. Small mapped
  // pedestrian networks can be valid shortcuts. During route selection, evaluate
  // each component that can serve BOTH endpoints and compare actual weighted A*
  // route costs rather than choosing a component from snap distance alone.
  // Debug aid:
  // debugPrint('route graph: nodes=$realN components=${compSize.length}');

  // ───────────────────── 7. Hazards ─────────────────────
  final hazX = <double>[];
  final hazY = <double>[];
  for (final h in activeHazards ?? <LatLng>[]) {
    hazX.add(toX(h.longitude));
    hazY.add(toY(h.latitude));
  }

  bool pointInHazard(double px, double py) {
    for (var k = 0; k < hazX.length; k++) {
      final dx = px - hazX[k];
      final dy = py - hazY[k];
      if (dx * dx + dy * dy <= hazardRadiusM * hazardRadiusM) return true;
    }
    return false;
  }

  // True if the straight segment a→b passes within hazardRadiusM of any hazard.
  bool edgeHitsHazard(int a, int b) {
    final ax = nodeX[a];
    final ay = nodeY[a];
    final abx = nodeX[b] - ax;
    final aby = nodeY[b] - ay;
    final len2 = abx * abx + aby * aby;
    for (var k = 0; k < hazX.length; k++) {
      var t = len2 == 0
          ? 0.0
          : ((hazX[k] - ax) * abx + (hazY[k] - ay) * aby) / len2;
      if (t < 0.0) {
        t = 0.0;
      } else if (t > 1.0) {
        t = 1.0;
      }
      final dx = hazX[k] - (ax + t * abx);
      final dy = hazY[k] - (ay + t * aby);
      if (dx * dx + dy * dy <= hazardRadiusM * hazardRadiusM) return true;
    }
    return false;
  }

  // ───────────────────── 8. Snap start / destination onto the mapped path network ─────────────────────
  // All distances below are physical distances in metres (before class penalties).
  // Start GPS can be a little off the mapped walkway; building arrival points must
  // be very close to a mapped line. Parking coordinates refer to lot areas, so they
  // receive a wider limit and snap to a mapped aisle/approach instead of the lot centre.
  const maxStartSnapDistanceM = 30.0;
  const maxBuildingSnapDistanceM = 3.0;
  // The two manually verified Hope Commons doors are 4.14 m and 7.83 m
  // from the closest mapped pedestrian edge in the current export.
  const maxHopeCommonsEntranceSnapDistanceM = 9.0;
  const maxParkingSnapDistanceM = 25.0;

  // Each snap is [nodeA, nodeB, x, y, effectiveDistance, physicalDistance].
  // The effective distance includes a small penalty for snapping to a parking
  // aisle or regular road instead of a sidewalk / curated quiet campus road.
  List<List<double>> findSnapsForPoint(double px, double py) {
    final bestAny = List<double>.filled(compSize.length, double.infinity);
    final bestSafe = List<double>.filled(compSize.length, double.infinity);
    final any = List<List<double>>.generate(compSize.length, (_) => <double>[]);
    final safe =
        List<List<double>>.generate(compSize.length, (_) => <double>[]);

    for (var a = 0; a < realN; a++) {
      final componentId = comp[a];
      for (final edge in adj[a].entries) {
        final b = edge.key;
        if (b <= a || b >= realN || comp[b] != componentId) continue;

        final abx = nodeX[b] - nodeX[a];
        final aby = nodeY[b] - nodeY[a];
        final len2 = abx * abx + aby * aby;
        if (len2 <= 0.000001) continue;

        var t = ((px - nodeX[a]) * abx + (py - nodeY[a]) * aby) / len2;
        if (t < 0.0) {
          t = 0.0;
        } else if (t > 1.0) {
          t = 1.0;
        }

        final qx = nodeX[a] + t * abx;
        final qy = nodeY[a] + t * aby;
        final dx = qx - px;
        final dy = qy - py;
        final physicalDistance = math.sqrt(dx * dx + dy * dy);

        final segmentLength = math.sqrt(len2);
        final edgeMultiplier = edge.value / segmentLength;
        final preferredAccess =
            edgeMultiplier <= 1.10; // walkway or quiet campus road
        final effectiveDistance =
            physicalDistance + (preferredAccess ? 0.0 : 8.0);

        final snap = <double>[
          a.toDouble(),
          b.toDouble(),
          qx,
          qy,
          effectiveDistance,
          physicalDistance,
        ];

        if (effectiveDistance < bestAny[componentId]) {
          bestAny[componentId] = effectiveDistance;
          any[componentId] = snap;
        }

        if (effectiveDistance < bestSafe[componentId] &&
            !pointInHazard(qx, qy)) {
          bestSafe[componentId] = effectiveDistance;
          safe[componentId] = snap;
        }
      }
    }

    return List<List<double>>.generate(
      compSize.length,
      (componentId) =>
          safe[componentId].isNotEmpty ? safe[componentId] : any[componentId],
    );
  }

  final startSnaps =
      findSnapsForPoint(toX(start.longitude), toY(start.latitude));
  if (startSnaps.every((snap) => snap.isEmpty)) return [];

  // Add a temporary endpoint on an existing graph segment.
  int addVirtual(List<double> snap) {
    final a = snap[0].toInt();
    final b = snap[1].toInt();
    final id = nodeX.length;

    nodeX.add(snap[2]);
    nodeY.add(snap[3]);
    nodeLat.add(refLat + snap[3] / mPerDegLat);
    nodeLng.add(refLng + snap[2] / mPerDegLng);
    adj.add(<int, double>{});

    final segmentLength = nodeDist(a, b);
    final multiplier =
        segmentLength > 0 ? (adj[a][b] ?? segmentLength) / segmentLength : 1.0;

    for (final end in <int>[a, b]) {
      final weight = nodeDist(id, end) * multiplier;
      adj[id][end] = weight;
      adj[end][id] = weight;
    }
    return id;
  }

  // Every trial route adds exactly two virtual nodes. Remove them after each A*
  // run so one entrance candidate cannot leave stale edges/nodes that affect the
  // next candidate's route or cause loops around a building.
  void removeLastVirtual(int id) {
    if (id != adj.length - 1 || id != nodeX.length - 1) return;

    final neighbours = adj[id].keys.toList();
    for (final neighbour in neighbours) {
      adj[neighbour].remove(id);
    }

    adj.removeLast();
    nodeX.removeLast();
    nodeY.removeLast();
    nodeLat.removeLast();
    nodeLng.removeLast();
  }

  // ───────────────────── 9. A* ─────────────────────
  // Strict mode excludes every edge that passes through an active hazard buffer.
  List<int>? findPath(int s, int g, bool strict) {
    final total = adj.length;
    final gScore = List<double>.filled(total, double.infinity);
    final parent = List<int>.filled(total, -1);
    final closed = List<bool>.filled(total, false);
    final heapNode = <int>[];
    final heapKey = <double>[];

    void swap(int i, int j) {
      final node = heapNode[i];
      heapNode[i] = heapNode[j];
      heapNode[j] = node;

      final key = heapKey[i];
      heapKey[i] = heapKey[j];
      heapKey[j] = key;
    }

    void push(int node, double key) {
      heapNode.add(node);
      heapKey.add(key);
      var i = heapNode.length - 1;

      while (i > 0) {
        final parentIndex = (i - 1) >> 1;
        if (heapKey[parentIndex] <= heapKey[i]) break;
        swap(parentIndex, i);
        i = parentIndex;
      }
    }

    int pop() {
      final top = heapNode[0];
      final lastNode = heapNode.removeLast();
      final lastKey = heapKey.removeLast();

      if (heapNode.isNotEmpty) {
        heapNode[0] = lastNode;
        heapKey[0] = lastKey;
        var i = 0;
        final size = heapNode.length;

        while (true) {
          final left = 2 * i + 1;
          final right = left + 1;
          var smallest = i;
          if (left < size && heapKey[left] < heapKey[smallest]) {
            smallest = left;
          }
          if (right < size && heapKey[right] < heapKey[smallest]) {
            smallest = right;
          }
          if (smallest == i) break;
          swap(i, smallest);
          i = smallest;
        }
      }
      return top;
    }

    // Every graph edge costs at least its physical length, so this is admissible.
    double heuristic(int u) => nodeDist(u, g);

    gScore[s] = 0.0;
    push(s, heuristic(s));

    while (heapNode.isNotEmpty) {
      final u = pop();
      if (closed[u]) continue;
      closed[u] = true;
      if (u == g) break;

      for (final edge in adj[u].entries) {
        final v = edge.key;
        if (closed[v]) continue;

        var cost = edge.value;
        if (hazX.isNotEmpty && edgeHitsHazard(u, v)) {
          if (strict) continue;
          cost *= hazardCostFactor;
        }

        final tentative = gScore[u] + cost;
        if (tentative < gScore[v]) {
          gScore[v] = tentative;
          parent[v] = u;
          push(v, tentative + heuristic(v));
        }
      }
    }

    if (gScore[g].isInfinite) return null;

    final path = <int>[];
    var current = g;
    while (current != -1) {
      path.add(current);
      current = parent[current];
    }
    return path.reversed.toList();
  }

  // Compare every candidate approach using the actual weighted A* route cost.
  // Building candidates must be within 3 m of the graph; the original building
  // coordinate is used only as a conservative fallback when no approach exists.
  // Parking lot centres are snapped to their nearby parking aisles or walkways.
  List<LatLng>? bestRoutePoints;
  var bestRouteScore = double.infinity;

  final destinationSnapLimit = bestKind == 'parking'
      ? maxParkingSnapDistanceM
      : (norm(bestName) == 'hope commons'
          ? maxHopeCommonsEntranceSnapDistanceM
          : maxBuildingSnapDistanceM);

  for (final candidateDestination in destinationCandidates) {
    final destinationSnaps = findSnapsForPoint(
      toX(candidateDestination.longitude),
      toY(candidateDestination.latitude),
    );

    for (var componentId = 0; componentId < compSize.length; componentId++) {
      final snapStart = startSnaps[componentId];
      final snapDestination = destinationSnaps[componentId];
      if (snapStart.isEmpty || snapDestination.isEmpty) continue;

      // Compare physical snap distance, not the extra class penalty.
      if (snapStart[5] > maxStartSnapDistanceM ||
          snapDestination[5] > destinationSnapLimit) {
        continue;
      }

      final startNode = addVirtual(snapStart);
      final destinationNode = addVirtual(snapDestination);

      try {
        // If both endpoints lie on the same segment, add a direct segment
        // between the virtual points using that segment's same cost multiplier.
        final sameSegment = (snapStart[0] == snapDestination[0] &&
                snapStart[1] == snapDestination[1]) ||
            (snapStart[0] == snapDestination[1] &&
                snapStart[1] == snapDestination[0]);

        if (sameSegment) {
          final a = snapStart[0].toInt();
          final b = snapStart[1].toInt();
          final segmentLength = nodeDist(a, b);
          final multiplier = segmentLength > 0
              ? (adj[a][b] ?? segmentLength) / segmentLength
              : 1.0;
          final weight = nodeDist(startNode, destinationNode) * multiplier;
          adj[startNode][destinationNode] = weight;
          adj[destinationNode][startNode] = weight;
        }

        var candidatePath = findPath(startNode, destinationNode, true);
        if (candidatePath == null &&
            hazX.isNotEmpty &&
            allowRouteThroughHazards) {
          candidatePath = findPath(startNode, destinationNode, false);
        }
        if (candidatePath == null) continue;

        var pathCost = 0.0;
        for (var i = 1; i < candidatePath.length; i++) {
          pathCost += adj[candidatePath[i - 1]][candidatePath[i]] ?? 0.0;
        }

        final score = pathCost + snapStart[4] + snapDestination[4];

        if (score < bestRouteScore) {
          final routePoints = <LatLng>[];
          for (final nodeId in candidatePath) {
            final point = LatLng(nodeLat[nodeId], nodeLng[nodeId]);
            if (routePoints.isNotEmpty) {
              final previous = routePoints.last;
              final dx = (point.longitude - previous.longitude) * mPerDegLng;
              final dy = (point.latitude - previous.latitude) * mPerDegLat;
              if (dx * dx + dy * dy < 0.04) continue; // less than 20 cm
            }
            routePoints.add(point);
          }

          // For Hope Commons only, finish with a short connector from the
          // mapped footway to the user-confirmed entrance coordinate. This is
          // bounded by the 9 m Hope-specific snap limit above; it is not applied
          // to inferred entrances at other buildings.
          if (norm(bestName) == 'hope commons' &&
              snapDestination[5] <= maxHopeCommonsEntranceSnapDistanceM) {
            final entrance = candidateDestination;
            final last = routePoints.isNotEmpty ? routePoints.last : null;
            if (last != null) {
              final dx = (entrance.longitude - last.longitude) * mPerDegLng;
              final dy = (entrance.latitude - last.latitude) * mPerDegLat;
              if (dx * dx + dy * dy >= 0.04) {
                routePoints.add(entrance);
              }
            }
          }

          if (routePoints.isNotEmpty) {
            bestRouteScore = score;
            bestRoutePoints = routePoints;
          }
        }
      } finally {
        // Remove destination first, then start; each is the final node at removal.
        removeLastVirtual(destinationNode);
        removeLastVirtual(startNode);
      }
    }
  }

  if (bestRoutePoints == null || bestRoutePoints!.isEmpty) {
    return [];
  }

  // Return mapped graph points for the walk itself. The only deliberate
  // off-graph terminal connector is for Hope Commons: it ends at one of the two
  // user-confirmed entrance coordinates, after passing the 9 m snap-distance
  // check above. No raw GPS start coordinate or general building centroid is added.
  return bestRoutePoints!;
}
