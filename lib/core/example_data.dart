import 'package:latlong/latlong.dart';
import 'package:living_city/data/models/point_of_interest_model.dart';
import 'package:living_city/data/models/trip_model.dart';

final LatLng swBound = LatLng(38.358, -9.634);
final LatLng neBound = LatLng(39.15, -8.458);
final LatLng lisbon = LatLng(38.748753, -9.153692);

var markers = [
  TimedPointOfInterestModel(
      PointOfInterestModel(1, 1, 'Castelo de S. Jorge', 15, 15, 61,
          LatLng(38.713434885851484, -9.133620912637578)),
      1),
  TimedPointOfInterestModel(
      PointOfInterestModel(1, 1, 'Praça do Comércio', 20, 15, 61,
          LatLng(38.70816559446653, -9.136622677359982)),
      1),
  TimedPointOfInterestModel(
      PointOfInterestModel(1, 1, 'Largo do Regedor', 60, 15, 61,
          LatLng(38.71493746027443, -9.139745024718508)),
      1),
  TimedPointOfInterestModel(
      PointOfInterestModel(1, 1, 'Largo da Academia Nacional de Belas Artes',
          30, 15, 61, LatLng(38.70861933474137, -9.140110592695562)),
      1),
];

var line = [
  LatLng(38.713434885851484, -9.133620912637578),
  LatLng(38.71343483135331, -9.133724513658684),
  LatLng(38.71324502780836, -9.133734199413677),
  LatLng(38.71309061452204, -9.133682231612852),
  LatLng(38.71275384827153, -9.133697132774378),
  LatLng(38.71257708324292, -9.133622254437705),
  LatLng(38.712520086300074, -9.133470076325612),
  LatLng(38.7125320072293, -9.133323299884571),
  LatLng(38.71264637364402, -9.133129398520204),
  LatLng(38.712553613913514, -9.133022296421728),
  LatLng(38.712477990518764, -9.133037197583254),
  LatLng(38.71223938566981, -9.133013355724811),
  LatLng(38.71217437935265, -9.132974053911285),
  LatLng(38.71220474046926, -9.13264883606096),
  LatLng(38.712169909004196, -9.132681991145358),
  LatLng(38.71212446046154, -9.132868069399924),
  LatLng(38.711820663030906, -9.132854472090031),
  LatLng(38.71144962410889, -9.132901783277878),
  LatLng(38.71154368769103, -9.133191610869577),
  LatLng(38.71158764611753, -9.133569727843323),
  LatLng(38.71142168443102, -9.133362787962618),
  LatLng(38.71135388414608, -9.133308398723045),
  LatLng(38.71115663002036, -9.13329927176161),
  LatLng(38.71108733961926, -9.133432450892757),
  LatLng(38.7109256620167, -9.133821743737647),
  LatLng(38.7109578857785, -9.133902023745373),
  LatLng(38.71051085093269, -9.134197811801682),
  LatLng(38.710107029455315, -9.134513343897016),
  LatLng(38.70985538609003, -9.134505148258175),
  LatLng(38.709415429295944, -9.136328119106475),
  LatLng(38.708626971586654, -9.136026370585554),
  LatLng(38.70836638752445, -9.135901945886804),
  LatLng(38.70833304617553, -9.13594143396485),
  LatLng(38.70816559446653, -9.136622677359982),
  LatLng(38.70816559446653, -9.136622677359982),
  LatLng(38.70815032068231, -9.136684815660525),
  LatLng(38.71235524220069, -9.138360823803264),
  LatLng(38.713064351224844, -9.138629976033345),
  LatLng(38.7130911733156, -9.138627182065559),
  LatLng(38.71315413072305, -9.13875123423527),
  LatLng(38.71321876451117, -9.138806368532919),
  LatLng(38.71387348429576, -9.139063786098296),
  LatLng(38.71444326745964, -9.139310586586086),
  LatLng(38.71448331433125, -9.139421972768499),
  LatLng(38.7147131647478, -9.139278735353322),
  LatLng(38.714845226291835, -9.139238874746239),
  LatLng(38.714906321054094, -9.139247629178636),
  LatLng(38.71502161879141, -9.13942793323311),
  LatLng(38.71494972068704, -9.139698016785786),
  LatLng(38.71493746027443, -9.139745024718508),
  LatLng(38.71493746027443, -9.139745024718508),
  LatLng(38.71480797338801, -9.14024153665248),
  LatLng(38.714701988876655, -9.140203724955105),
  LatLng(38.71448405938933, -9.140144306573516),
  LatLng(38.7144350718208, -9.139976854770858),
  LatLng(38.71425830679219, -9.139893222001788),
  LatLng(38.713176482465336, -9.13944227560108),
  LatLng(38.712871194918556, -9.139416943626484),
  LatLng(38.71282928540176, -9.139605815848839),
  LatLng(38.71201530945335, -9.139631334087953),
  LatLng(38.71096794406253, -9.13963412805574),
  LatLng(38.71083532372494, -9.140478092591719),
  LatLng(38.70971345252648, -9.140140395018616),
  LatLng(38.70930255299738, -9.140005725771317),
  LatLng(38.70915894305316, -9.139934572725025),
  LatLng(38.70914739465298, -9.140087123366158),
  LatLng(38.709128581936554, -9.140144865367075),
  LatLng(38.709054634922474, -9.140170756135227),
  LatLng(38.70861933474137, -9.140110592695562),
];

var trip = TripModel([...markers], [...line], 60, 320, 81, 50, 100, 350);
