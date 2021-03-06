 class AppException implements Exception{
   AppException([this.message, this.prefix, this.url]);
  final String message;
  final String prefix;
  final String url;

  

}
class BadRequestException extends AppException{
  BadRequestException([String message,String url]):super(message, 'Bad request',url);
}
class FetchDataException extends AppException{
  FetchDataException([String message,String url]):super(message,'Unable to process',url);
}
class ApiNotRespondingException extends AppException{
  ApiNotRespondingException([String message,String url]):super(message,'Api not response',url);
}
class UnAuthorizedException extends AppException{
  UnAuthorizedException([String message,String url]):super(message,'User not authorized',url);
}
class NotFoundException extends AppException{
  NotFoundException([String message,String url]):super(message,'Action not found',url);
}