import '../helper/dialog_helper.dart';
import 'package:astrology_app/services/app_exception.dart';

class BaseController {
  void handleError(dynamic error) {
    if (error is BadRequestException) {
      var message = error.message;
      DialogHelper.showErrorDialog(description: message);
    } else if (error is FetchDataException) {
      var message = error.message;
      DialogHelper.showErrorDialog(description: message);
    } else if (error is ApiNotRespondingException) {
      var message = 'Api Not Responding Exception';
      DialogHelper.showErrorDialog(description: message);
    } else if (error is NotFoundException) {
      DialogHelper.showErrorDialog(description: 'Page not Found');
    }
  }
}
