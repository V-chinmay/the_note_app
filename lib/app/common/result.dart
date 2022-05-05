abstract class Result<T, Error> {
  T? data;
  Error? error;
}

class SuccessResult<T, Error> implements Result<T, Error> {
  SuccessResult(this.data);
  
  @override
  T? data;

  @override
  Error? error = null;
}

class FailureResult<T, Error> implements Result<T, Error> {
  FailureResult(this.error);

  @override
  T? data = null;

  @override
  Error? error = null;
}
