class HttpException implements Exception{
  String cause;
  HttpException(this.cause);

  @override
  String toString(){
    return cause;
  }
}