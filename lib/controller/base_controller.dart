import '../helper/dialog_helper.dart';
import '../services/app_exception.dart';

class BaseController {
  void handleError(dynamic error) {
    if (error is BadRequestException) {
      final message = error.message;
      DialogHelper.showErrorDialog(description: message);
    } else if (error is FetchDataException) {
      final message = error.message;
      DialogHelper.showErrorDialog(description: message);
    } else if (error is ApiNotRespondingException) {
      const message = 'Api Not Responding Exception';
      DialogHelper.showErrorDialog(description: message);
    } else if (error is NotFoundException) {
      DialogHelper.showErrorDialog(description: 'Page not Found');
    }
  }
}
